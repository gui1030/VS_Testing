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
 *      debug.h
 *
 *      Defines needed by debug.cpp
 *
 *
 ******************************************************************************
 */

#pragma once

//#define DEBUG_MODE              // comment this out to disable debug output

// Defines for outputting to serial debug port (or not)
#if defined(DEBUG_MODE)
  #define dprintf(...)
  #define dprintln(str)
  #define DPPRINTF(...) DP.printf(__VA_ARGS__)
  #define DPPRINT(...)  DP.print(__VA_ARGS__)
#else
  #define dprintf(...)
  #define dprintln(str)
  #define DPPRINTF(...)
  #define DPPRINT(...)
#endif

// Test Set Password Definition
#define TS_PASSWORD     "*TestSet17!."

// External visibility of Debug namespace
namespace Debug {
    void init();
    void loop();
}
