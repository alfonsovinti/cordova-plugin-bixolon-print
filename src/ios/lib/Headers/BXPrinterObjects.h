//
//  BXPrinterObjects.h
//  Demo
//
//  Created by Beomjin Kim on 11. 3. 15..
//  Copyright 2011 BIXOLON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXPrinter: NSObject
{

	
}

@property (retain)	NSString		*name;
@property (retain)	NSString		*address;
@property (retain)	NSString		*modelStr;
@property (retain)	NSString		*versionStr;
@property (retain)	NSString		*friendlyName;
@property (retain)	NSString		*macAddress;
@property (retain)	NSString		*bluetoothDeviceName;

@property (assign)	unsigned short	port;
@property (assign)	char			*mac;
@property (assign)	unsigned short	version;
@property (assign)	char			*subnet;
@property (assign)	char			*gateway;
@property (assign)	char			baudrate;
@property (assign)	char			dhcp;
@property (assign)	unsigned short	inactivityTime;
@property (assign)	char			https;
@property (assign)	unsigned short	value;
@property (assign)  unsigned short  connectionClass;




@end
