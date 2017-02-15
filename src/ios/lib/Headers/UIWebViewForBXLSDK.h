//
//  UIWebView+BXLJavaScriptContext.h
//  testJSWebView
//
//  Created by bixolon on 02/01/15.
//  Copyright (c) 2015 bixolon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "BXPrinterController.h"


//////////////////////

@protocol BXPrinterControllerToJSExpoter<JSExport>//JSExporterForTestClass <JSExport>

-(void) printerLookup;

-(long) connectBTPrinter:(NSString*)macAddress;
-(long) connectWifiPrinter:(NSString*)ipAddress;

-(void) alignment:(NSInteger)align;
-(void) attribute:(NSInteger)attribute;
-(void) textSize:(NSInteger)size;
-(void) characterSet:(NSInteger)cs;
-(void) textEncoding:(NSInteger)encoding;
-(long) printText:(NSString*)string;
-(long) printBitmap:(id)imageInfo;  //[ image Name , width, brightness]
-(long) printBarcode:(id)barcodeInfo;   //  barcode Data, Symbologies, width, height
-(long) cutPaper;

// for Cash Drawer
-(void) drawerPin:(NSInteger)pin;   //  0: 2Pin,  1: 5Pin,    refer to manual ''2-1-14 Drawer kick-out connector pin'
-(void) drawerLevel:(NSInteger)level;   //  0: low detect,  1: high detect,    refer to manual ''2-1-15 Drawer open level'
-(long) openDrawer;


//  getStatus
-(long) isCoverOpen;   //  0: not open(closed),  1: opened,   etc: refer to stateCode at manual '2-1-18 Result Code'
-(long) isDrawerOpen;   //  0: not open(closed),  1: opened,   etc: refer to stateCode at manual '2-1-18 Result Code'
-(long) isPaperEmpty;   //  0: not empty(filled),  1: empty,   etc: refer to stateCode at manual '2-1-18 Result Code'

-(void) disconnect;
@end

@interface BXPrinterControllerToJS : UIViewController<BXPrinterControlDelegate> //<BXLWebViewDelegate, JSExporterForTestClass>
{
}
-(BOOL) testApi;


////////////////////////////////////////////////
//   print APIs
-(void) printerLookup;

-(void) printerClassOpen:(UIWebView*)webView;
-(void) printerClassClose;

-(long) connectBTPrinter:(NSString*)macAddress;
-(long) connectWifiPrinter:(NSString*)ipAddress;

-(void) alignment:(NSInteger)align;
-(void) attribute:(NSInteger)attribute;
-(void) textSize:(NSInteger)size;
-(void) characterSet:(NSInteger)cs;
-(void) textEncoding:(NSInteger)encoding;

-(long) printText:(NSString*)string;
-(long) printBitmap:(id)imageInfo;
-(long) printBarcode:(id)barcodeInfo;
-(long) cutPaper;

// for Cash Drawer
-(void) drawerPin:(NSInteger)pin;
-(void) drawerLevel:(NSInteger)level;
-(long) openDrawer;


//  getStatus
-(long) isCoverOpen;   //  0: not open(closed),  1: opened,   etc: refer to stateCode at manual '2-1-18 Result Code'
-(long) isDrawerOpen;   //  0: not open(closed),  1: opened,   etc: refer to stateCode at manual '2-1-18 Result Code'
-(long) isPaperEmpty;   //  0: not empty(filled),  1: empty,   etc: refer to stateCode at manual '2-1-18 Result Code'

-(void) disconnect;

@end