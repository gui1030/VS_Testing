#include "radio.h"
#include "fletcher.h"

namespace VeriRadio {
  char mac[13] = {};
  bool healthy = false;
  bool humidityHealth = false;
  bool flashHealth = false;

  void parseHealth(String response) {
    char buffer[RADIO_BUFFER_SIZE];
    response.toCharArray(buffer, RADIO_BUFFER_SIZE);
    char* type = strtok(buffer, ",");
    char* responseMac = strtok(NULL, ",");
    char* humidityTest = strtok(NULL, ",");
    char* flashTest = strtok(NULL, ",");
    // char* channel = strtok(NULL, ",");
    // char* pingInterval = strtok(NULL, ",");
    // char* radioVersion = strtok(NULL, ",");

    if (!type || !responseMac || !humidityTest || !flashTest) {
      dprintln("Bad Reading");
      return;
    }
    if(strlen(responseMac) != 12) {
      dprintln("Invalid MAC ID");
      return;
    }

    humidityHealth = (*humidityTest=='1');
    flashHealth = (*flashTest=='1');

    strncpy(mac, responseMac, 12);
    mac[12] = '\0';
    dprintf("Radio MAC: %s\n", mac);
    healthy = atoi(humidityTest) && atoi(flashTest);
  }

  String verifyChecksum(String str) {
    if (NULL == str.c_str()) {
      return NULL;
    }
    int index = str.lastIndexOf(',');
    if (index < 0) {
      return NULL;
    }
    String payload = str.substring(0, index);
    int givenChecksum = str.substring(index + 1).toInt();
    int computedChecksum = fletcher(payload);

    if (givenChecksum == computedChecksum) {
      return payload;
    } else {
      return NULL;
    }
  }

  /**
   * String param required by Particle
   */
  int sendRplRepair(String command) {
    String response = send("5,0");
    if(response == "ag") {
      dprintln("got ack");
      return 1;
    }
    return 0;
  }

  /**
   * Interval is the time between client sends, in minutes
   */
  int sendNewSendInterval(String interval) {
    int sendInterval = interval.toInt();
    if(sendInterval <= 0 || sendInterval >= 60)
      return 0;
    String response = send("1," + interval);
    if(response == "ap") {
      dprintln("got ack");
      return 1;
    }
    return 0;
  }

  int sendNewChannel(String channel) {
    int chan = channel.toInt();
    if(chan < 11 || chan > 26)
      return 0;
    String response = send("3," + channel);
    if(response == "ac") {
      dprintln("got ack");
      return 1;
    }
    return 0;
  }

  int resetVeriRadio(String required) {
    reset();
    return 1;
  }

  void healthCheck() {
    int attempts = 0;
    while (attempts < HEALTH_CHECK_MAX_ATTEMPTS) {
      dprintln("Health Check");
      String response = verifyChecksum(send("31,0"));
      parseHealth(response);
      attempts ++;
      if (healthy) {
        return;
      }
    }
  }

  void init() {
    pinMode(RESET_SERVER_PIN, OUTPUT);
    reset();
    delay(500);
    healthCheck();
  }

  void reset() {
    digitalWrite(RESET_SERVER_PIN,HIGH);
    delay(100);
    digitalWrite(RESET_SERVER_PIN,LOW);
    delay(100);
  }

  String send(String cmd) {
    //Calculate checksum
    int checksum = fletcher(cmd);
    String payload = cmd + "," + checksum + "\n";
    dprintln(payload);
    //Send command
    Serial1.write(payload);
    return Serial1.readStringUntil('\n');
  }

  Message read() {
    Message message;
    message.valid = false;

    String raw = Serial1.readStringUntil('\n');
    dprintf("Raw: %s\n", raw.c_str());

    String body = verifyChecksum(raw);
    if (body.c_str() == NULL) {
      dprintln("Bad read");
      return message;
    }

    unsigned int split = body.indexOf(',', 2);
    message.valid = true;
    message.type = body.charAt(0);
    message.index = body.substring(2, split).toInt();
    message.payload = body.substring(split + 1, body.length());

    if(message.type == 's' || message.type == 't') {
      dprintf("Acknowledging: a%c%u\n", message.type, message.index);
      Serial1.printf("a%c%u\n", message.type, message.index);
    }
    return message;
  }
}
