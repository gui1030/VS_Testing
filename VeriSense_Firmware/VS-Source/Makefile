all: vr-sensor vr-hub
CONTIKI=../contiki

TARGET=srf06-cc26xx
BOARD=veriradio/cc2650
CPU_FAMILY=cc26xx

CFLAGS += -DPROJECT_CONF_H=\"project-conf.h\"

MODULES+=core/net/llsec/noncoresec

ifdef WITH_COMPOWER
APPS+=powertrace
CFLAGS+= -DCONTIKIMAC_CONF_COMPOWER=1 -DWITH_COMPOWER=1 -DQUEUEBUF_CONF_NUM=4
endif

ifdef SERVER_REPLY
CFLAGS+=-DSERVER_REPLY=$(SERVER_REPLY)
endif
ifdef PERIOD
CFLAGS+=-DPERIOD=$(PERIOD)
endif

CONTIKI_WITH_IPV6 = 1
include $(CONTIKI)/Makefile.include
