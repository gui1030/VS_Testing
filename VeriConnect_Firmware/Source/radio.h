#pragma once

#include "application.h"
#include "debug.h"

#define RADIO_BUFFER_SIZE 64
#define RESET_SERVER_PIN A4
#define HEALTH_CHECK_MAX_ATTEMPTS 5

namespace VeriRadio {
  struct Message {
    bool valid;
    char type;
    unsigned int index;
    String payload;
  };

  extern char mac[13];
  extern bool healthy;
  extern bool humidityHealth;
  extern bool flashHealth;

  void init();
  void reset();
  int sendRplRepair(String command);
  int sendNewSendInterval(String interval);
  int sendNewChannel(String channel);
  int resetVeriRadio(String required);
  String send(String cmd);
  Message read();
}
