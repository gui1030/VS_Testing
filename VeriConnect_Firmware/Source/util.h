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
 *      util.h
 *
 *      Defines needed by util.cpp and others
 *
 *
 ******************************************************************************
 */

#pragma once

#include "application.h"
#include "debug.h"

// Defines for Electron I/O
#define USB             Serial
#define VR              Serial1 // VeriRadio port via pins 3/4 (TX/RX)
#define GPSU            Serial4 // CAM-M8C GPS Receiver
#define DP              Serial5 // Debug serial port via pins 19/20 (C0/C1)
#define BAUD_RATE       115200

// Defines dictating certain pin I/O's
#define LED_BLUE        D7      // The blue LED on the Electron
#define GPS_INT         B0      // Pin 18 on the Electron leads to CAM-INT
#define GPS_RESET       B1      // Pin 17 on the Electron leads to CAM-RESET
#define RADIO_REBOOT    A4      // Pin 8 on the Electron leads to 6LoWPaNRESET

// Define designating how fast time progresses
#define CLOCK_SECOND    1000    /* in milliseconds */

// Prototypes of public functions
char*           now_char(void);
String          now_string(void);

// External visibility of External Display namespace
namespace Display {
    void init();
    void loop();
    void test();
}

// External visibility of Power namespace
namespace Power {
    void    init();
    void    loop();
    int     battDisconnect(String);
}
