/*
 ******************************************************************************
 *
 *   This File Contains PROPRIETARY and CONFIDENTIAL TRADE SECRET information
 *   which is the exclusive property of VeriSolutions, LLC.  "Trade Secret"
 *   means information constituting a trade secret within the meaning of
 *   Section 10-1-761(4) of the Georgia Trade Secrets Act of 1990, including
 *   all amendments hereafter adopted.
 *
 *   (c) 2017 by VeriSolutions, LLC.                 www.VeriSolutions.co
 *
 ******************************************************************************
 *
 *      util.cpp
 *
 *      Defines LED and Power namespaces as well as several globally
 *      visible utility routines
 *
 *
 ******************************************************************************
 */

#include <application.h>
#include "util.h"
#include "debug.h"
#include "cloud.h"
#include "radio.h"
#include "spark_wiring_fuel.h"
#include "dct.h"
#include "platform_flash_modules.h"

//=============================================================================
//
//  Various Public utilty routines
//
//
//=============================================================================

//-----------------------------------------------------------------------------
//
//  Routine to return a NULL terminated char[] containing time since boot
//
char *now_char() {
    static char   s[32];
    unsigned long now = millis();

    sprintf(s, "%ld.%.2ld", now/CLOCK_SECOND, ((now*100)/CLOCK_SECOND)%100);
    return s;
}

//-----------------------------------------------------------------------------
//
//  Routine to return a String containing time since boot
//
String now_string() {
    static char   s[32];
    String        S;
    unsigned long now = millis();

    sprintf(s, "%ld.%.2ld", now/CLOCK_SECOND, ((now*100)/CLOCK_SECOND)%100);
    S = s;
    return S;
}

//=============================================================================
//
//  LED namespace conains routines to set the LEDs on the mothercard to
//  various colors and blink rates
//
//=============================================================================
#define LED_GREEN   D1
#define LED_RED     D2

namespace Display {

    enum { none_s,  start_s, red_s,     // state of LED test
           green_s, yellow_s } testMode = none_s;

    enum color_t { red, yellow, green };
    enum rate_t  { slow=1, fast=10, constant=500 };

    enum color_t    ledColor = yellow;  // the color which has been set
    enum rate_t     ledRate = fast;     // the blink rate which has been set

    void set (color_t);                 // private function prototypes
    void set (rate_t);


//-----------------------------------------------------------------------------
//
//  Initialize LED output pins and set an initial color & rate
//
    void init() {
        pinMode (LED_GREEN, OUTPUT);    // init DIO pins for output only
        pinMode (LED_RED, OUTPUT);

        set(ledColor);                  // set initial display values
        set(ledRate);
    }

//-----------------------------------------------------------------------------
//
//  Externally invoked to trigger an LED Self-Test Cycle
//
    void test () {
        testMode = start_s;
    }

//-----------------------------------------------------------------------------
//
//  Invoked every iteration through loop() to ensure LEDs display the properly
//  set color status (depending on Cellular RSSI) and the blink rate (depnding
//  on health indicated by the VeriRadio).  This routine also implements a
//  means of sending the LEDs cycling through their three colors, typically for
//  manufacturing test purposes.
//
    void loop () {
        static long         timeToChange;
        static enum color_t currColor;
        static enum rate_t  currRate;

        switch (testMode) {
            case none_s:
                VeriRadio::healthy ? set(constant) : set(slow);
                if (!Particle.connected() || Cloud::rssi < -120)
                    set(red);
                else if (Cloud::rssi < -90)
                    set(yellow);
                else
                    set(green);
                break;
            case start_s:
                timeToChange = Time.now() + 5;
                currColor = ledColor;
                currRate  = ledRate;
                set(constant);
                set(red);
                testMode = red_s;
                DPPRINTF("==> LED Test (RED)\n");
                break;
            case red_s:
                if (Time.now() >= timeToChange) {
                    timeToChange = Time.now() + 5;
                    set(green);
                    testMode = green_s;
                    DPPRINTF("==> LED Test (GREEN)\n");
                }
                break;
            case green_s:
                if (Time.now() >= timeToChange) {
                    timeToChange = Time.now() + 5;
                    set(yellow);
                    testMode = yellow_s;
                    DPPRINTF("==> LED Test (YELLOW)\n");
                }
                break;
            case yellow_s:
                if (Time.now() >= timeToChange) {
                    set(currColor);
                    set(currRate);
                    testMode = none_s;
                    DPPRINTF("==> LED NORMAL display\n");
                }
        }
    }

//-----------------------------------------------------------------------------
//
//  This private routine is invoked to set the 8 mothercard LEDs to the
//  appropriate color and blink rate
//
    void set (color_t newColor) {
        ledColor = newColor;
        switch (ledColor) {
            case red:
                analogWrite(LED_GREEN, 0);
                analogWrite(LED_RED, 12, ledRate);
                break;
            case green:
                analogWrite(LED_GREEN, 80, ledRate);
                analogWrite(LED_RED, 0);
                break;
            case yellow:
                analogWrite(LED_GREEN, 50, ledRate);
                analogWrite(LED_RED, 5, ledRate);
                break;
            default:
                analogWrite(LED_GREEN, 0);
                analogWrite(LED_RED, 0);
                break;
        }
    }

//-----------------------------------------------------------------------------
//
//  This private routine is used to set the blink rate for the LEDs
//
    void set (rate_t newRate) {
        ledRate = newRate;
    }
}

//=============================================================================
//
//  Power namespace provides routines to tell the Electron to no longer use
//  its external battery power, only power coming from the connected USB power
//  supply.   These routines are primarily used following Manufacturing Test
//  just before preparation for shipping.  The Hub will only power up again
//  when connected to USB power.
//
//=============================================================================
namespace Power {

    // Bitfield defined in chip literature
    union MOCR_ut {    // BQ24195 Misc Operation Control register
        byte          Reg;
        struct MOCR_t {
            unsigned int INT_MASK       : 2;
            unsigned int                : 3;
            unsigned int BATFET_Disable : 1;    // only bit we deal with
            unsigned int TMR2X_EN       : 1;
            unsigned int DPDM_EN        : 1;
        } Bit;
    };

    enum battState_e {
        battOff,
        battOn,
    };

    PMIC                powerMgmt;
    static battState_e  desiredBattState = battOn;  // default is batt=on

//-----------------------------------------------------------------------------
//
//  Invoked to perform any needed initialization
//
    void init() {
    }

//-----------------------------------------------------------------------------
//
//  Invoked as rapidly as possible to handle any power change requests
//
    void loop() {

        MOCR_ut            regValue;

        // Read the control register's value
        regValue.Reg = powerMgmt.readOpControlRegister();

        if ((desiredBattState == battOn) && regValue.Bit.BATFET_Disable) {
            // Set Electron to use Battery Power
            powerMgmt.enableBATFET();
            DPPRINTF("@%s==> Battery was DISABLED but is now ENABLED\n",
                    now_char());
        }
        else if ((desiredBattState == battOff) &&
                !regValue.Bit.BATFET_Disable) {
            // Set Electron to disconnect from Battery Power
            powerMgmt.disableBATFET();
            DPPRINTF("@%s ==> Battery was ENABLED but is now DISABLED\n",
                    now_char());
        }
    }

//-----------------------------------------------------------------------------
//
//  Invoked in response to Particle command line to trigger power disconnect
//
    int battDisconnect (String ignored) {
        DPPRINTF("@%s ==> battDisconnect() invoked\n", now_char());
        desiredBattState = battOff;
        return true;
    }
}

//-------------------------------------------------------------------------
