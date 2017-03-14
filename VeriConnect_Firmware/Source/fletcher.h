#pragma once

#include "application.h"

/**
 * Checksum used for serial communication between Electron and VeriRadio
 */
unsigned short fletcher(const char* payload, unsigned int length);
unsigned short fletcher(const char * payload);
unsigned short fletcher(String str);
