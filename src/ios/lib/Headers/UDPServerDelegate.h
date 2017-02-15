//
//  UDPServerDelegate.h
//  Demo
//
//  Created by Beomjin Kim on 11. 3. 14..
//  Copyright 2011 SAVIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@interface UDPPacket : NSObject
{
	
}

@property (assign)	SOCKADDR_IN		*addr;
@property (assign)	char			*data;
@property (assign)	NSInteger		size;


@end

@protocol UDPServerDelegate <NSObject>

@required
- (void)didUDPReceive:(UDPPacket *)packet;

@optional

- (void)didUDPServiceStart;
- (void)didUDPServiceStop;


@end

