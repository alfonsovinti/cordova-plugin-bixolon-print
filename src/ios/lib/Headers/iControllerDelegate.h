//
//  iControllerDelegate.h
//  BXSDK
//
//  Created by Sabin on 9/3/11.
//  Copyright 2011 SAVIN. All rights reserved.
//

#import "BXPrinterObjects.h"

@class iController;


@protocol iControllerDelegate<NSObject>

@required
- (void)msrArrived:(iController *)controller 
			 track:(NSNumber *)track;

@optional
- (void)willConnect:(iController *)controller;
- (void)didConnect:(iController *)controller;
- (void)didNotConnectWithError:(iController *)controller
						 error:(NSError *)error;

- (void)didBeBrokenConnection:(iController *)controller
						error:(NSError *)error;
- (void)didDisconnect:(iController *)controller;

- (void)msrTerminated:(iController *)controller;
- (void)message:(iController *)controller
		   text:(NSString *)text;
- (void)didUpdateStatus:(iController*) controller
				status:(NSNumber*) status;


@end