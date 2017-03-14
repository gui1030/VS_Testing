#include "application.h"
#include "serial.h"
#include "debug.h"
#include "util.h"
#include "radio.h"
#include "cloud.h"

PRODUCT_ID(1206);
PRODUCT_VERSION(23);

//Reset the system if something hangs for over a minute
ApplicationWatchdog wd(60000*10, System.reset);

STARTUP(init());

void init() {
  VR.begin(BAUD_RATE);

  Debug::init();
  Power::init();

  VeriRadio::init();
  Display::init();
}

void setup() {
  Cloud::setup();
}

void loop() {
  Debug::loop();
  Power::loop();
  Cloud::loop();
  Display::loop();
}
