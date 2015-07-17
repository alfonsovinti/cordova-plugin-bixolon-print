/*
 *
 * Copyright (C) 2013 Alfonso Vinti <me@alfonsovinti.it>
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 */

//
//  CDVBixolonPrint.h
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import "BXPrinterController.h"

#import "Common.h"

//  Add External Accessory
//  sample -> Build Phases -> Link Binary With Libraries ->
//  Add : [ExternalAccessory.framework]
//
//  Add Protocol
//  sample -> Info -> Add Row ->
//  Add : [supported external accessory protocols]
//  Value : com.custom.protocol

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
    
    NSDictionary            *MAX_COL;
    NSDictionary            *PRODUCT_IDS;
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
