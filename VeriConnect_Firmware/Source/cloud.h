#pragma once

#include "application.h"
#include "debug.h"

#if defined(STAGING)
  #define CREATE_SENSOR_READING "staging/sensor-readings/create"
#else
  #define CREATE_SENSOR_READING "sensor-readings/create"
#endif

// Defines bit meanings in Self-Test Results value
struct stResults_bit {
    unsigned int    vrHumidity_st       : 1;    // Least Significant Bit
    unsigned int    vrExtFlash_st       : 1;
    unsigned int    vrRadio_st          : 1;
    unsigned int    vrTemperature_st    : 1;

    unsigned int    eGPS_st             : 1;
    unsigned int    eSIM_st             : 1;
    unsigned int    eSerial_st          : 1;
    unsigned int    eCellular_st        : 1;

    unsigned int    eFlash_st           : 1;    // Most Significant Bit
    unsigned int    future_st           : 23;   // Presently unused bits
};

// Overlays bit definitions with 32-bit integer
union stResults_u {
    int                     results_i;
    struct stResults_bit    results_bit;
};

namespace Cloud {
  extern int rssi;
  extern int battery;
  int  selfTest(String);
  void setup();
  void loop();
}
