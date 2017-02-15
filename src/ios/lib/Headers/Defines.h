//
//  Defines.h
//  Demo
//
//  Created on 11. 3. 14..
//  Copyright 2011 BIXOLON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <netinet/in.h>
#import <unistd.h>

//
//

#define MSRMODE_12CMD		0x30 //1/2 읽기 모드 커맨드 사용
#define MSRMODE_23CMD		0x31 //2/3 읽기 모드 커맨드 사용
#define MSRMODE_1AUTO		0x32 //1 읽기 모드 자동
#define MSRMODE_2AUTO		0x33 //2 읽기 모드 자동
#define MSRMODE_23CMD2		0x34 //2/3 읽기 모드 커맨드 사용
#define MSRMODE_2AUTO2		0x35 //2 읽기 모드 자동
#define MSRMODE_3AUTO		0x36 //3 읽기 모드 자동
#define MSRMODE_23AUTO		0x37 //23 읽기 모드 자동
#define MSRMODE_NONE		0x38 //2 읽기 모드 자동

#define MSR_TRACK1 200 //77 or 79
#define MSR_TRACK2 200 //39 or 41
#define MSR_TRACK3 200 //105

#define MSR_TRACK_ENCRYPTED 286 //105


#define BXL_TEXTENCODING_SINGLEBYTEFONT 0x00000001
#define BXL_TEXTENCODING_KSC5601        0x80000422
#define BXL_TEXTENCODING_SHIFT_JIS      0x00000008
#define BXL_TEXTENCODING_BIG5           0x80000a03
#define BXL_TEXTENCODING_GB2312         0x80000421
#define BXL_TEXTENCODING_GB18030        0x80000632


#define	/* not Support!!!! */ CONNECTION_CONTROL_AUTO			100	// Not Support,  
																	// Non Auto 인데 이름이 잘못되었음,  앞으로 사용하지 않음.
                                                                    // BXCode.h , BXL_CONNECTIONMODE_NOAUTO 값 참조.
#define SOCKET_WIFI                0x01
#define SOCKET_ETHERNET            0x02

#define	SOCKET_ERROR		-1
#define INVALID_SOCKET		SOCKET_ERROR



typedef unsigned long		DWORD;
typedef	unsigned short		WORD;
typedef unsigned char		BYTE;
typedef int					SOCKET;
typedef struct sockaddr_in	SOCKADDR_IN;
typedef struct sockaddr		SOCKADDR;
typedef char				*PCHAR;
typedef unsigned char		*PBYTE;
typedef unsigned int		UINT;
typedef char				*LPSTR;
typedef unsigned char		byte;
typedef unsigned short		UINT16;
typedef unsigned int		UINT32;
typedef unsigned char		UINT8;
typedef unsigned short		*PUINT16;
typedef unsigned int		*PUINT32;
typedef unsigned char		*PUINT8;



#pragma pack(1)	
typedef struct
{
	unsigned char		string[18];
	unsigned char		name[64];
	unsigned char		region;
	unsigned char		networkMode;
	unsigned char		ipConfigMode;
	unsigned char		ipAddress[4];
	unsigned char		subnetMask[4];
	unsigned char		gateway[4];
	unsigned char		ssid[32];
	unsigned char		authMode;
	unsigned char		cryptoMode;
	unsigned char		wepKey0[26];
	unsigned char		wepKey1[26];
	unsigned char		wepKey2[26];
	unsigned char		wepKey3[26];
	unsigned char		pskKey[64];
	unsigned char		adhocChannel;
	unsigned char		eapMode;
	unsigned char		eapId[32];
	unsigned char		eapPasswd[32];
	unsigned char		userName[32];
	unsigned char		userPasswd[32];
	unsigned char		port[2];
	unsigned char		dummy;
	unsigned char		sysContact[64];
	unsigned char		sysLocaltion[64];
	unsigned char		isDefaultTTL;
	unsigned char		dummy2;
	unsigned char		isWebSSL;
	unsigned char		isTelnet;
	unsigned char		isFTP;
	unsigned char		isSNMP;
	unsigned char		isSNMPTrap;
	unsigned char		snmpSetCommunity[16];
	unsigned char		snmpGetCommunity[16];
	unsigned char		snmpTrapCommunity[16];
	unsigned char		trapIP[4];
	unsigned char		inactivityTime[3];
	unsigned char		checksum[2];
	
	
} _BXPrinterConfigrationStruct;


typedef struct
{
	unsigned char		pin_08;
	unsigned char		pin_07;
	unsigned char		pin_06;
	unsigned char		pin_05;
	unsigned char		pin_04;
	unsigned char		pin_03;
	unsigned char		pin_02;
	unsigned char		pin_01;
	unsigned char		eof;
} _BXPrinterMSW;

typedef struct
{
    _BXPrinterMSW       msw[12];

    NSInteger                  settingByUseMSW;
    NSInteger                 printingDensity;
    NSInteger                 printingSpeed;
    NSInteger                 codePage;
    NSInteger                 printerEmulation;
    NSInteger                 partialCuttingLevel;
    NSInteger                 powerSavingTime;
    
    NSInteger                 labelMode;
    NSInteger                 fontType;
    NSInteger                 beepForPaperEnd;
    NSInteger                 beepForLowBattery;
    NSInteger                 blackMarkSensor;
    
    
    NSInteger                 msrTriggerMode;
    NSInteger                 msrDataMode;
    
    NSInteger                 doubleByteCharacterMode;
    NSInteger                 powerOffTime;
    
    NSInteger                 paperSaveMode;
    NSInteger                 paperSaveModeCuttingCorrection;
    NSInteger                 print2InchMode;
    
    NSInteger                 internalBuzzer;
    NSInteger                 externalBuzzer;
    NSInteger                 upsideDownMode;

} _BXPrinterSettingConfigrationStruct;
	
	

#pragma pack()
