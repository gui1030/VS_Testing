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
 *      debug.cpp
 *
 *      Debug namespace that provides some output to a serial port when the
 *      Electron has been compiled in "Debug Mode."  The switch to turn Debug
 *      mode on and off is in "debug.h"
 *
 *
 ******************************************************************************
 */

#include <application.h>
#include "debug.h"
#include "cloud.h"
#include "radio.h"
#include "util.h"
#include "spark_wiring_fuel.h"
#include "dct.h"
#include "platform_flash_modules.h"
#include <Serial4/Serial4.h>
#include <Serial5/Serial5.h>
#include "spark_protocol_functions.h"

namespace Debug {
    
//-----------------------------------------------------------------------------
//
//  These are private function prototypes
//
    void        particleHandler (const char*, const char*);
    void        handleTestSetIO();

//-----------------------------------------------------------------------------
//
//  These are private global variables
//
    char        sparkStr[64];

//-----------------------------------------------------------------------------
//
//  Invoked to initialize debug output to a serial port
//
//
    void init() {

#if defined(DEBUG_MODE)
        DP.begin(BAUD_RATE);
#endif
    }

//-----------------------------------------------------------------------------
//
//  Invoked as rapidly as possible to perform various debug operations
//
    void loop() {
        // Determine if Test Set is connected and deal with it
        handleTestSetIO();
    }

//-----------------------------------------------------------------------------
//
//
//
void handleTestSetIO() {

    static enum { openPort_st, connect_st, grabPswd_st, getCmd_st,
                        } tsState = openPort_st;
    const  int          tsBaudRate  = 115200;
    static bool         tsPrevConn  = true;
    bool                tsConnected = true;     // USB.isConnected();
    static unsigned int inCnt       = 0;
    static char         inBuf[128];
    static bool         gcPrompt    = false;

    if (!tsConnected && tsPrevConn && (tsState != openPort_st))
        tsState = connect_st;

    switch (tsState) {
        case openPort_st: {
            USB.begin(tsBaudRate);
            tsState = connect_st;
            DPPRINTF("@%s USB Serial Port enabled\n", now_char());
            break;
        }

        case connect_st: {
            if (tsConnected != tsPrevConn) {
                DPPRINT("@" + now_string() + " Test-Set ");
                DPPRINTF(tsConnected ? "I/O Now Connected at %d Baud\n" :
                        "is NOT Connected\n", tsBaudRate);
                tsPrevConn = tsConnected;
            }
            if (tsConnected) {
                USB.printf("** VeriSolutions Test-Set Interface **\n");
                USB.printf("Please enter password:\n");
                tsState = grabPswd_st;
                gcPrompt = false;
            }
            break;
        }

        case grabPswd_st: {
            const char  *tsOurPassword = TS_PASSWORD;   // in debug.h
            int         c = Serial.read();
            if (c == 0x7f) {       // backspace in PuTTY
                if (inCnt > 0)
                    inBuf[--inCnt] = '\0';
            }
            else if ((c == '\r') || (inCnt >= (sizeof(inBuf)-1))) {
                inBuf[inCnt] = '\0';
                inCnt = 0;
                if (strcmp(inBuf, tsOurPassword) == 0)  // they match
                    tsState = getCmd_st;
                else                                    // don't match
                    USB.printf("Please enter password:\n");
            }
            else if (c > 0)
                inBuf[inCnt++] = c;
            break;
        }

        case getCmd_st: {
            int c = USB.read();
            if (!gcPrompt) {
                USB.printf("Command? ");
                gcPrompt = true;
            }
            if (c == 0x7f) {       // backspace in PuTTY
                if (inCnt > 0) {
                    inBuf[--inCnt] = '\0';
                    USB.printf("\b \b");
                }
            }
            else if ((c == '\r') || (inCnt >= (sizeof(inBuf)-1))) {
                inBuf[inCnt] = '\0';
                inCnt  = 0;
                gcPrompt = false;
                USB.printf("\n");
                if (strcmp(inBuf, "self-test") == 0) {
                    USB.printf("%d\n", Cloud::selfTest(""));
                }
                else if (strcmp(inBuf, "led-test") == 0) {
                    Display::test();
                }
                else if (strcmp(inBuf, "batt-disc") == 0) {
                    Power::battDisconnect("");
                }
                else if (strcmp(inBuf, "exit") == 0) {
                    tsState = connect_st;
                }
                else 
                    USB.printf("Say what?\n");
            }
            else if (isgraph(c)) {
                inBuf[inCnt++] = c;
                USB.printf("%c", c);
            }
            break;
        }
    }
}

//-----------------------------------------------------------------------------
//
//  Handler to extract data we've requested from Particle 
//
    void particleHandler (const char *topic, const char *data) {
        strncpy(sparkStr, data, sizeof(sparkStr)-1);
    }

//-----------------------------------------------------------------------------

}
