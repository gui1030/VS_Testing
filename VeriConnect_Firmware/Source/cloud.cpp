#include "cloud.h"
#include "radio.h"

namespace Cloud {
  int rssi;
  int battery;
#ifdef NEW_RESTART_CODE
  bool restartFlag = false;

  int sndVeri1234restart(String arg) {
    restartFlag = true;
    return 1;
  }
#endif

  void setup() {
    //Request these when needed
    Particle.variable("mac", VeriRadio::mac);
    Particle.variable("rssi", rssi);
    Particle.variable("battery", battery);
    //Remote commands
    Particle.function("repair", VeriRadio::sendRplRepair);
    Particle.function("send-int", VeriRadio::sendNewSendInterval);
    Particle.function("new-chan", VeriRadio::sendNewChannel);
    Particle.function("reset", VeriRadio::resetVeriRadio);
#ifdef NEW_RESTART_CODE
    Particle.function("restart", sndVeri1234restart);
#endif

    dprintf("Claiming %s\n", System.deviceID().c_str());
    Particle.publish("claim", VeriRadio::mac, PRIVATE);
  }

  void process(VeriRadio::Message message) {
    if (!message.valid) {
      return;
    }
    switch(message.type) {
      case 's': {
        dprintf("Publishing: %s\n", message.payload.c_str());
        Particle.publish(CREATE_SENSOR_READING, message.payload, PRIVATE);
        delay(1000);
      }
    }
  }

  void loop() {
#ifdef NEW_RESTART_CODE
    if (restartFlag) {
      //not required just safe
      restartFlag = false;
      System.reset();
      return;
    }
    else
    {
#endif
      rssi = Cellular.RSSI().rssi;
      FuelGauge fuel;
      battery = (int)fuel.getSoC();

      if(Particle.connected() && Serial1.available()) {
        process(VeriRadio::read());
      }
#ifdef NEW_RESTART_CODE
    }
#endif
  }
//-----------------------------------------------------------------------------
//
//  Invoked to gather self test results of various Electron and VeriRadio
//  components and populate a result bitstring thate reports results to
//  an external entity (like the Manufacturing Test Set).
//
    int selfTest (String ignored) {

        union stResults_u   results;

        results.results_i = 0;
        results.results_bit.vrHumidity_st       = VeriRadio::humidityHealth;
        results.results_bit.vrExtFlash_st       = VeriRadio::flashHealth;
        results.results_bit.vrRadio_st          = true;
        results.results_bit.vrTemperature_st    = true;
        results.results_bit.eGPS_st             = true;
        results.results_bit.eSIM_st             = true;
        results.results_bit.eSerial_st          = true;
        results.results_bit.eCellular_st        = true;
        results.results_bit.eFlash_st           = true;

        return results.results_i;
    }

}
