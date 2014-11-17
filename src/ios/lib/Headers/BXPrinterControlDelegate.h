//
//  BXPrinterControlDelegate.h
//  Demo
//
//  Copyright 2011 BIXOLON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXPrinterObjects.h"

@class BXPrinterController;


@protocol BXPrinterControlDelegate<NSObject>

@required

- (void)didFindPrinter:(BXPrinterController *)controller 
               printer:(BXPrinter *)printer;
- (void)msrArrived:(BXPrinterController *)controller 
			 track:(NSNumber *)track;

@optional
- (void)willConnect:(BXPrinterController *)controller 
                     printer:(BXPrinter *)printer;
- (void)didConnect:(BXPrinterController *)controller
		   printer:(BXPrinter *)printer;
- (void)didNotConnect:(BXPrinterController *)controller
			  printer:(BXPrinter *)printer
			withError:(NSError *)error;
- (void)didDisconnect:(BXPrinterController *)controller
			  printer:(BXPrinter *)printer;
- (void)didBeBrokenConnection:(BXPrinterController *)controller
                      printer:(BXPrinter *)printer
                    withError:(NSError *)error;


- (void)didNotLookup:(BXPrinterController *)controller
              withError:(NSError *)error;
- (void)willLookupPrinters:(BXPrinterController *)controller;
- (void)didLookupPrinters:(BXPrinterController *)controller;

- (void)didStart;
- (void)didStop;

- (void)msrTerminated:(BXPrinterController *)controller;

- (void)message:(BXPrinterController *)controller
		   text:(NSString *)text;

@end
