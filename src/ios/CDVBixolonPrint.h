//
//  CDVBixolonPrint.h
//
//  Created by Alfonso Vinti on 03/06/13.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import "BXPrinterController.h"

#import "Common.h"

@interface CDVBixolonPrint : CDVPlugin <BXPrinterControlDelegate>
{
    NSLock                  *_lock;
	NSMutableArray          *_printersArrayWifi;
	NSMutableArray          *_printersArrayEthernet;
	NSMutableArray          *_printersArrayBt;
    
    int                     _printerCount;
    int                     _refreshPrinterCount;
    
    BOOL                    _isInit;
    BOOL                    _isReady;
    
    NSString                *_lastCommandName;
}

@property(nonatomic, retain) BXPrinterController    *printerController;

@property(nonatomic, retain) BXPrinter              *selectPrinter;

@property(nonatomic, retain) CDVInvokedUrlCommand   *lastCommand;

// Gestione memoria
- (void) initAllObject;
- (void) releseAllObject;
- (void) initTableObject;
- (void) releseTableObject;

- (void) initPrinterController;
- (void) releasePrinterController;

// Metodi di classe
- (BXPrinterController*) getPrinterController;

- (void) refreshPrinterList;
- (void) addPrinterList:(BXPrinter *)printer;
- (void) clearPrinterList;

- (void) setAlign:(NSString *)align;

- (long) msrReadStart;
- (void) msrReadEnd;

// Metodi del plugin
//- (void) connect:(CDVInvokedUrlCommand *)command;
- (void) connect;
//- (void) disconnect:(CDVInvokedUrlCommand *)command;
- (void) disconnect;
- (void) printText:(CDVInvokedUrlCommand *)command;
- (void) _printText;
- (void) cutPaper:(CDVInvokedUrlCommand *)command;
- (void) _cutPaper;
- (void) getStatus:(CDVInvokedUrlCommand *)command;
- (void) _getStatus;

@end
