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
 *
 *
 *
 *
 *
 ******************************************************************************
 */

#ifndef DATA_HOLD
#define DATA_HOLD

#include "net/ip/uip.h"

#define UDP_CLIENT_PORT 8765    // These are not IANA assigned!!
#define UDP_SERVER_PORT 5678

#define VERISENSE_SIZE 14
#define VERITRACK_SIZE 8

#define ACK               ((uint8_t)0x01)
#define CHANGE_CHANNEL    ((uint8_t)0xA5)
#define VERITRACK_CONFIG  ((uint8_t)0xA6)
#define PING_INTERVAL     ((uint8_t)0xA7)
#define CONTROL           ((uint8_t)0x21)
#define JOIN              ((uint8_t)0xF0)
#define VERITRACK         ((uint8_t)0x11)
#define VERISENSE         ((uint8_t)0x15)

enum veriPacketMsgType {   // range 0..31
    ptACK               = 1,
    ptJOIN              = 2,
    ptVERISENSE         = 3,
    ptVERITRACK         = 4,
    ptRECONFIGURE       = 5,
};

struct veriAckPacket_t {        // 2 bytes - little endian order
    unsigned int           msgPadding   : 2;
    bool                   msgSuccess   : 1;
    enum veriPacketMsgType msgWhat      : 5;  // ie, what's being ack'ed
    unsigned int           msgSeq       : 3;
    enum veriPacketMsgType msgType      : 5;
};

struct veriJoinPacket_t {       // 1 byte - little endian order
    unsigned int           msgSeq       : 3;
    enum veriPacketMsgType msgType      : 5;
};

struct veriSensePacket_t {      // 14 bytes - little endian order
    unsigned char          msgMAC[6];
    unsigned int           msgChksum    : 5;
    signed int             msgRSSI      : 10;
    signed int             msgBattLevel : 10;
    signed int             msgHumidity  : 14;
    signed int             msgTemp      : 14;
    unsigned int           msgSeq       : 3;
    unsigned int           msgFormat    : 3;
    enum veriPacketMsgType msgType      : 5;
};

struct _sensor { 
    signed short temp;
    uint8_t      humidity;
    uint8_t      battery;
};

struct vsMsgData_t {
    char            mac[13];
    uint8_t         index;
    signed short    temp;
    uint8_t         rssi;
    uint8_t         humidity;
    uint8_t         battery;
    uint8_t         parent_mac[6];
};

enum clientKind {
    clientNone      = 0,
    clientSensor,
};

struct client_t {
    enum clientKind kind;
    uip_ipaddr_t    ip;
    char            mac[16];
    int             seqNum;
    clock_time_t    lastReportTime;
};

#endif
