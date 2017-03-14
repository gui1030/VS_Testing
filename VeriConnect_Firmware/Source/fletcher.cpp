#include "fletcher.h"

/**
 * Checksum used for serial communication between Electron and VeriRadio
 */
unsigned short fletcher(const char* payload, unsigned int length) {
  char A = 0;
  char B = 0;
  unsigned int i;
  for(i = 0; i < length; i++) {
    A = (A + payload[i]) % 255;
    B = (B + A) % 255;
  }
  return ((A<<8) | B);
}

unsigned short fletcher(const char * payload) {
  return fletcher(payload, strlen(payload));
}

unsigned short fletcher(String str) {
  return fletcher(str.c_str(), str.length());
}
