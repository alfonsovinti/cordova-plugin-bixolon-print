//
//  CDVBixolonPrint.m
//
//  Created by Alfonso Vinti on 03/06/13.
//
//

#define __lock      [_lock lock]
#define __unlock    [_lock unlock]

#import "CDVBixolonPrint.h"

@implementation CDVBixolonPrint

@synthesize printerController, selectPrinter, lastCommand;

- (void) logStatus
{
    NSString *r = @"NO";
    NSString *i = @"NO";
    
    if(_isInit == YES)
        i = @"YES";
    if(_isReady == YES)
        r = @"YES";
    
    NSLog(@"[CDVBixolonPrint logStatus]");
    NSLog(@"============== Status Printing Start  =============\r\n");
    NSLog(@"---- [CDVBixolonPrint] isReady:             %@", r);
    NSLog(@"---- [CDVBixolonPrint] isInit:              %@", i);
    NSLog(@"---- [CDVBixolonPrint] printerCount:        %i", _printerCount);
    NSLog(@"---- [CDVBixolonPrint] refreshPrinterCount: %i", _refreshPrinterCount);
    NSLog(@"---- [CDVBixolonPrint] lastCommandName:     %@", _lastCommandName);
    NSLog(@"============== Status Printing Finish =============\r\n");
}


//////////////////////////////////////////////////////
// Metodi Del Plugin
//////////////////////////////////////////////////////
- (void) connect
{
    NSLog(@"[CDVBixolonPrint connect] ");
    NSMutableArray* printersArray = nil;
    CDVPluginResult* pluginResult = nil;
    //self.lastCommand = command;
    @try
	{
		__lock;
        /* Disconnect to Connected printer */
        if(printerController.target) {
            [printerController disconnectWithTimeout:3];
        }
        
        if([_printersArrayBt count] > 0){
            printersArray = _printersArrayBt;
        }else if ([_printersArrayWifi count] > 0){
            printersArray = _printersArrayWifi;
        }else if ([_printersArrayEthernet count] > 0){
            printersArray = _printersArrayEthernet;
        }
        
        /* Printer Select */
        if ( printersArray != nil ) {
            printerController.target = [printersArray objectAtIndex:0];
            //self.selectPrinter   = [printersArray objectAtIndex:0];
            //printerController.target = self.selectPrinter;
        } else {
            NSLog(@"[CDVBixolonPrint] _connect: Error! no printers found.");
            if( _refreshPrinterCount < 3 ){
                [self refreshPrinterList];
            }else{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"no printers found."];
                _refreshPrinterCount = 0;
                [self.commandDelegate sendPluginResult:pluginResult callbackId:self.lastCommand.callbackId];
            }
            return;
        }
        
		if(BXL_SUCCESS != [printerController selectTarget]) {
            NSLog(@"[CDVBixolonPrint] _connect: There is a problem with selected printer. You might need to refresh this list.");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"There is a problem with selected printer. You might need to refresh this list."];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.lastCommand.callbackId];
            return;
		}
        
        /* Connection Mode Check */
        NSLog(@"[CDVBixolonPrint] _connect: Auto Connect NO");
        printerController.AutoConnection = BXL_CONNECTIONMODE_NOAUTO;
        [self performSelectorInBackground:@selector(printerConnect:) withObject:printerController];
	}
	@finally
	{
		//[self refresh];
		__unlock;
	}
}
// ---------------------------------------------------
// disconnect
// ---------------------------------------------------
- (void) disconnect
{
    NSLog(@"[CDVBixolonPrint disconnect] ");
    [printerController disconnect];
}

// ---------------------------------------------------
// printText
// ---------------------------------------------------
- (void) printText:(CDVInvokedUrlCommand *)command
{
    NSLog(@"[CDVBixolonPrint printText] init!");
    if(_isInit != YES){
        [self initAllObject];
    }
    self.lastCommand = command;
    _lastCommandName = @"printText";
    [self connect];
}
- (void) _printText
{
    NSLog(@"[CDVBixolonPrint _printText] start!");
    
    CDVPluginResult* pluginResult = nil;
    
    NSArray *textLines = [self.lastCommand.arguments objectAtIndex:0];
    NSDictionary *printConfig = [self.lastCommand.arguments objectAtIndex:1];
    
    NSString *hrBCode = @"[hr]";
    int paperWidth    = 0;
    BOOL formFeed     = [[printConfig objectForKey:@"formFeed"] boolValue];
    int lineFeed      = [[printConfig objectForKey:@"lineFeed"] intValue];
    int codePage      = [[printConfig objectForKey:@"codePage"] intValue];
    
    [printerController initializePrinter];
    
    //printerController.textEncoding = BXL_TEXTENCODING_SINGLEBYTEFONT;
    printerController.textEncoding = 0x0C;     //Español Encoding
    printerController.characterSet = codePage;
    
    if (textLines != nil) {
        [printerController checkPrinter:BXL_MASK_ALL];
        
        paperWidth = [[MAX_COL objectForKey:printerController.target.name] intValue];
        
        for (NSUInteger i = 0, count = [textLines count]; i < count; i++) {
            id arg = [textLines objectAtIndex:i];
            
            if (![arg isKindOfClass:[NSDictionary class]]) {
                NSLog(@"[CDVBixolonPrint _printText] arg = %@", arg);
                continue;
            }
            
            NSDictionary *textLine  = arg;
            NSString *text          = [textLine objectForKey:@"text"];
            NSString *align         = [textLine objectForKey:@"textAlign"];
            NSNumber *width         = [textLine objectForKey:@"textWidth"];
            NSNumber *height        = [textLine objectForKey:@"textHeight"];
            NSString *fontType      = [textLine objectForKey:@"fontType"];
            NSString *fontStyle     = [textLine objectForKey:@"fontStyle"];
            
            [self setAlign:align];
            [self setSize:[width intValue] :[height intValue]];
            [self setFontType:fontType];
            [self setFontStyle:fontStyle];
            
            if( text ) {
                if ( [text length] >= 5 ) {
                    if( [[text substringToIndex:4] isEqualToString:hrBCode] && BXL_SUCCESS==[printerController checkPrinter:BXL_MASK_ALL] ) {
                        NSString *hrStr     = [text substringWithRange:NSMakeRange(4,1)];
                        text                = @"";
                        for (int j = 0; j < paperWidth; j++) {
                            text = [text stringByAppendingString:hrStr];
                        }
                    }
                }
                
                if( BXL_SUCCESS != [printerController printText:[text stringByAppendingFormat:@"\r\n"]]) {
                    NSLog(@"[CDVBixolonPrint _printText] Fail!");
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Fail print text!"];
                    break;
                } else {
                    NSLog(@"[CDVBixolonPrint _printText] Success! text = %@", text);
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                }
            }
        } // end for
        
        if(formFeed) {
            [printerController nextPrintPos];
        } else {
            [printerController lineFeed:lineFeed];
        }
        
        [printerController cutPaper];
        [printerController openDrawer];
    } else {
        NSLog(@"[CDVBixolonPrint _printText] Error! Arg was null.");
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    }
    
    //[self disconnect];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.lastCommand.callbackId];
}

// ---------------------------------------------------
// cutPaper
// ---------------------------------------------------
- (void) cutPaper:(CDVInvokedUrlCommand *)command
{
    NSLog(@"[CDVBixolonPrint cutPaper] ");
    if(_isInit != YES){
        [self initAllObject];
    }
    self.lastCommand = command;
    _lastCommandName = @"cutPaper";
    [self connect];
}
- (void) _cutPaper
{
    NSLog(@"[CDVBixolonPrint _cutPaper] ");
    
    CDVPluginResult* pluginResult = nil;
    NSDictionary *printConfig = [self.lastCommand.arguments objectAtIndex:0];
    
    if (printConfig != nil) {
        NSLog(@"[CDVBixolonPrint _cutPaper] Success!");
        
        BOOL formFeed = [[printConfig objectForKey:@"formFeed"] boolValue];
        int lineFeed = [[printConfig objectForKey:@"lineFeed"] intValue];

        [printerController initializePrinter];
    
        if (formFeed) {
            [printerController nextPrintPos];
        } else {
            [printerController lineFeed:lineFeed];
        }
    
        [printerController cutPaper];
        [printerController openDrawer];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        NSLog(@"[CDVBixolonPrint _cutPaper] Error! Arg was null.");
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    }
    
    //[self disconnect];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.lastCommand.callbackId];
}

// ---------------------------------------------------
// cutPaper
// ---------------------------------------------------
- (void) getStatus:(CDVInvokedUrlCommand *)command
{
    NSLog(@"[CDVBixolonPrint getStatus] ");
    if(_isInit != YES){
        [self initAllObject];
    }
    self.lastCommand = command;
    _lastCommandName = @"getStatus";
    [self connect];
}
- (void) _getStatus
{
    
    NSLog(@"[CDVBixolonPrint _getStatus] ");
    
    CDVPluginResult* pluginResult = nil;
    BOOL printStatus = [[self.lastCommand.arguments objectAtIndex:0] boolValue];
    [printerController initializePrinter];
    
    if(BXL_SUCCESS==[printerController checkPrinter:BXL_MASK_ALL])
    {
        NSLog(@"[CDVBixolonPrint _getStatus] Success!");
        NSString *modelStr   = printerController.target.modelStr;
        NSString *nameStr    = printerController.target.name;
        NSString *versionStr = printerController.target.versionStr;
        NSString *macAddress = printerController.target.macAddress;
        
        NSString *stateCOVER = (printerController.state&BXL_STS_COVEROPEN)?@"OPENED": @"CLOSED";
        NSString *statePAPER = (printerController.state&BXL_STS_PAPEREMPTY)?@"EMPTY": @"FILL";
        
        //NSString *bluetoothDeviceName = printerController.target.bluetoothDeviceName;
        
        NSString *powerStatus;
        switch(printerController.power)
        {
            case BXL_PWR_HIGH:
                powerStatus = @"FULL";
                break;
            case BXL_PWR_MIDDLE:
                powerStatus = @"HIGH";
                break;
            case BXL_PWR_LOW:
                powerStatus = @"MIDDLE";
                break;
            case BXL_PWR_SMALL:
                powerStatus = @"LOW";
                break;
            case BXL_PWR_NOT:
                powerStatus = @"LOW";
                break;
        }
        
        
        NSDictionary *jsonObj = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 stateCOVER,  @"cover",
                                 statePAPER,  @"paper",
                                 powerStatus, @"battery",
                                 versionStr,  @"firmwareVersion",
                                 @"BIXOLON",  @"manufacturer",
                                 modelStr,    @"printerModel",
                                 nameStr,     @"printerName",
                                 macAddress,  @"printerAddress"
                                 , nil];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsonObj];
        
        if ( printStatus ) {
            NSString* strPrintText = [NSString stringWithFormat:@"Cover: %@\r\nPaper: %@\r\nBattery: %@\r\nFirmware Version: %@\r\nManufacturer: %@\r\nPrinter Model: %@\r\nPrinter Name: %@\r\nPrinter Address: %@\r\n", stateCOVER, statePAPER, powerStatus, versionStr, @"BIXOLON", modelStr, nameStr, macAddress];
            
            [printerController printText:strPrintText];
            [printerController lineFeed:3];
            [printerController cutPaper];
        }
    } else {
        NSLog(@"[CDVBixolonPrint _getStatus] Error! Not status avaleable.");
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    }
    
    //[self disconnect];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.lastCommand.callbackId];
}
//////////////////////////////////////////////////////
// END Metodi Del Plugin
//////////////////////////////////////////////////////


// ---------------------------------------------------
// printerConnect
// ---------------------------------------------------
- (void)printerConnect:(id)object
{
    NSLog(@"[CDVBixolonPrint] _printerConnect:");
    //[self logStatus];
    BXPrinterController *inPrinterController = (BXPrinterController*)object;
    if([inPrinterController connect] == NO ){
        NSLog(@"[CDVBixolonPrint] _printerConnect: Failed to connect.");
        CDVPluginResult* pluginResult = nil;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Failed to connect."];
        [self releseAllObject];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.lastCommand.callbackId];
        return;
    }
}


//////////////////////////////////////////////////////
// Gestione Memoria
//////////////////////////////////////////////////////
// ---------------------------------------------------
// initAllObject
// ---------------------------------------------------
- (void)initAllObject
{
    NSLog(@"[CDVBixolonPrint initAllObject] ");
    [self initPrinterController];
    [self initTableObject];
    _lock = [NSLock new];
    
    _printerCount        = 0;
    _refreshPrinterCount = 0;
    _lastCommandName     = nil;
    
    MAX_COL = @{
                @"SPP-R200"      : @0,
                @"SPP-100"       : @0,
                @"SPP-F310"      : @0,
                @"SPP-350II"     : @0,
                @"SPP-350plusII" : @0,
                @"SPP-F312"      : @0,
                @"SPP-350IIK"    : @0,
                @"SPP-R200II"    : @0,
                @"SPP-R300"      : @48,
                @"SPP-R400"      : @69,
            };
    
    PRODUCT_IDS = @{
                    @"10" : @"SPP-R200",
                    @"18" : @"SPP-100",
                    @"22" : @"SRP-F310",
                    @"31" : @"SRP-350II",
                    @"29" : @"SRP-350plusII",
                    @"35" : @"SRP-F312",
                    @"36" : @"SRP-350IIK",
                    @"40" : @"SPP-R200II",
                    @"33" : @"SPP-R300",
                    @"41" : @"SPP-R400",
                };
    
    _isInit = YES;
}
// ---------------------------------------------------
// releseAllObject
// ---------------------------------------------------
- (void)releseAllObject
{
    NSLog(@"[CDVBixolonPrint releseAllObject] ");
    [self releasePrinterController];
    [self releseTableObject];
    _lock = nil;
    
    _printerCount        = 0;
    _refreshPrinterCount = 0;
    _lastCommandName     = nil;
    
    selectPrinter = nil;
    lastCommand   = nil;
    
    _isInit  = NO;
    _isReady = NO;
}
// ---------------------------------------------------
// initTableObject
// ---------------------------------------------------
- (void)initTableObject
{
    NSLog(@"[CDVBixolonPrint initTableObject] ");
    _printersArrayWifi      = [NSMutableArray new];
    _printersArrayEthernet  = [NSMutableArray new];
    _printersArrayBt        = [NSMutableArray new];
}
// ---------------------------------------------------
// releseTableObject
// ---------------------------------------------------
- (void)releseTableObject
{
    NSLog(@"[CDVBixolonPrint releseTableObject] ");
	[_printersArrayWifi removeAllObjects];
	[_printersArrayEthernet removeAllObjects];
	[_printersArrayBt removeAllObjects];
}

// ---------------------------------------------------
// initPrinterController
// ---------------------------------------------------
- (void)initPrinterController
{
    NSLog(@"[CDVBixolonPrint initPrinterController] ");
    printerController                = [BXPrinterController getInstance];
    printerController.delegate       = self;
    printerController.lookupCount	 = 5;
    printerController.AutoConnection = BXL_CONNECTIONMODE_AUTO;
	[printerController open];
    //NSLog(@"[CDVBixolonPrint] _initPrinterController: BXPrinterController version: %@", printerController.version);
}

// ---------------------------------------------------
// releasePrinterController
// ---------------------------------------------------
- (void)releasePrinterController
{
    NSLog(@"[CDVBixolonPrint releasePrinterController] ");
	[printerController close];
}

// ---------------------------------------------------
// dealloc
// ---------------------------------------------------
- (void) dealloc
{
    [self releseAllObject];
}


//////////////////////////////////////////////////////
// Metodi di classe
//////////////////////////////////////////////////////
// ---------------------------------------------------
// getPrinterController
// ---------------------------------------------------
- (BXPrinterController *) getPrinterController
{
    NSLog(@"[CDVBixolonPrint getPrinterController] ");
    return printerController;
}
// ---------------------------------------------------
// refreshPrinterList
// ---------------------------------------------------
- (void)refreshPrinterList
{
    NSLog(@"[CDVBixolonPrint refreshPrinterList] ");
    [printerController lookup];
}

// ---------------------------------------------------
// addPrinterList
// ---------------------------------------------------
- (void)addPrinterList:(BXPrinter *)printer
{
    NSLog(@"[CDVBixolonPrint addPrinterList] ");
    NSMutableArray* printersArray = nil;
    switch(printer.connectionClass)
    {
        case BXL_CONNECTIONCLASS_WIFI:
            printersArray = _printersArrayWifi;
            break;
            
        case BXL_CONNECTIONCLASS_ETHERNET:
            printersArray = _printersArrayEthernet;
            break;
            
        case BXL_CONNECTIONCLASS_BT:
            printersArray = _printersArrayBt;
            break;
    }
    if(printersArray == nil)
        return;
    
	BOOL bRefresh = YES;
	
    [_lock lock];
	
	for( BXPrinter *p in printersArray )
	{
		if( [p.address isEqualToString:printer.address] )
		{
			bRefresh = NO;
			break;
		}
	}
	if( bRefresh )
	{
		[printersArray addObject:printer];
        _printerCount = _printerCount + 1;
	}
    [_lock unlock];
}
// ---------------------------------------------------
// clearPrinterList
// ---------------------------------------------------
- (void) clearPrinterList
{
    NSLog(@"[CDVBixolonPrint] _clearPrinterList:");
	__lock;
	[_printersArrayBt removeAllObjects];
	[_printersArrayWifi removeAllObjects];
	[_printersArrayEthernet removeAllObjects];
    _printerCount = 0;
	__unlock;
}
// ---------------------------------------------------
// setAlign
// ---------------------------------------------------
- (void) setAlign:(NSString *)align
{
    if([align isEqualToString:@"left"]){
        [printerController setAlignment:BXL_ALIGNMENT_LEFT];
    }else if ([align isEqualToString:@"center"]){
        [printerController setAlignment:BXL_ALIGNMENT_CENTER];
    }else if ([align isEqualToString:@"right"]){
        [printerController setAlignment:BXL_ALIGNMENT_RIGHT];
    }else{
        [printerController setAlignment:BXL_ALIGNMENT_LEFT];
    }
}
// ---------------------------------------------------
// setFontType
// ---------------------------------------------------
- (void) setFontType:(NSString *)fontType
{
    //TODO
}
// ---------------------------------------------------
// setFontStyle
// ---------------------------------------------------
- (void) setFontStyle:(NSString *)fontStyle
{
    if([fontStyle isEqualToString:@"bold"]){
        printerController.attribute = BXL_FT_BOLD;
    }else if ([fontStyle isEqualToString:@"reversed"]){
        printerController.attribute = BXL_FT_REVERSE;
    }else if ([fontStyle isEqualToString:@"underlined"]){
        printerController.attribute = BXL_FT_UNDERLINE;
    }else{
        printerController.attribute = BXL_FT_DEFAULT;
    }
}
// ---------------------------------------------------
// setAlign
// ---------------------------------------------------
- (void) setSize:(int)width :(int)height
{
    int tw;
    int th;
    switch (width) {
        case 1:
            tw = BXL_TS_1WIDTH;
            break;
        case 2:
            tw = BXL_TS_2WIDTH;
            break;
        case 3:
            tw = BXL_TS_3WIDTH;
            break;
        case 4:
            tw = BXL_TS_4WIDTH;
            break;
        case 5:
            tw = BXL_TS_5WIDTH;
            break;
        case 6:
            tw = BXL_TS_6WIDTH;
            break;
        case 7:
            tw = BXL_TS_7WIDTH;
            break;
        default:
            tw = BXL_TS_0WIDTH;
            break;
    }
    switch (height) {
        case 1:
            th = BXL_TS_1HEIGHT;
            break;
        case 2:
            th = BXL_TS_2HEIGHT;
            break;
        case 3:
            th = BXL_TS_3HEIGHT;
            break;
        case 4:
            th = BXL_TS_4HEIGHT;
            break;
        case 5:
            th = BXL_TS_5HEIGHT;
            break;
        case 6:
            th = BXL_TS_6HEIGHT;
            break;
        case 7:
            th = BXL_TS_7HEIGHT;
            break;
        default:
            th = BXL_TS_0HEIGHT;
            break;
    }
    printerController.textSize = tw|th;
}


//////////////////////////////////////////////////////
// MSR
//////////////////////////////////////////////////////
// ---------------------------------------------------
// msrReadStart
// ---------------------------------------------------
- (long)msrReadStart
{
    NSLog(@"[CDVBixolonPrint] _msrReadStart:");
    //_msrDelegate = delegate;
    return [printerController msrReadReady];
}
// ---------------------------------------------------
// msrReadEnd
// ---------------------------------------------------
- (void)msrReadEnd
{
    NSLog(@"[CDVBixolonPrint] _msrReadEnd:");
    if([printerController msrIsReady])
        [printerController msrReadCancelEx];
    /************************************************************************************************
     * description
     *  1. msrReadCancelEx
     *     - The 'msrTerminated' protocol method is called after the 'msrReadCancelEx' completed.
     *  2. msrReadCancelEx
     *     - The 'msrTerminated' protocol method is not called after the 'msrReadCancelEx' completed.
     *    [example]
     *    if([printerController msrIsReady])
     *        [printerController msrReadCancel];
     ***********************************************************************************************/
}
//////////////////////////////////////////////////////
// END MSR
//////////////////////////////////////////////////////





//////////////////////////////////////////////////////
//  BIXOLON EVENTS
//////////////////////////////////////////////////////
// ---------------------------------------------------
// message
// ---------------------------------------------------
- (void)message:(BXPrinterController *)controller
           text:(NSString *)text
{
    NSLog(@"[CDVBixolonPrint message] %@", text);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"sample" message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
// ---------------------------------------------------
// didUpdateStatus
// ---------------------------------------------------

-(void)didUpdateStatus:(BXPrinterController*) controller
                status:(NSNumber*) status
{
    NSLog(@"[CDVBixolonPrint didUpdateStatus] ");
}
// ---------------------------------------------------
// msrArrived
// ---------------------------------------------------
- (void)msrArrived:(BXPrinterController *)controller
             track:(NSNumber *)track
{
    NSString *text = @"Error, no message found!";
    NSData	*data = nil;
    if( [track intValue] & BXL_MSG_TRACK1 )
    {
        if( BXL_SUCCESS == [controller msrGetTrack:BXL_MSG_TRACK1 response:&data] )
        {
            text = [NSString stringWithFormat:@"%s", data.bytes];
        }
    }
    if( [track intValue] & BXL_MSG_TRACK2 )
    {
        if( BXL_SUCCESS == [controller msrGetTrack:BXL_MSG_TRACK2 response:&data] )
        {
            text = [NSString stringWithFormat:@"%s", data.bytes];
        }
    }
    if( [track intValue] & BXL_MSG_TRACK3 )
    {
        if( BXL_SUCCESS == [controller msrGetTrack:BXL_MSG_TRACK3 response:&data] )
        {
            text = [NSString stringWithFormat:@"%s", data.bytes];
        }
    }
    
    NSLog(@"[CDVBixolonPrint msrArrived] %@", text);
}
// ---------------------------------------------------
// msrTerminated
// ---------------------------------------------------
- (void) msrTerminated:(BXPrinterController *)controller
{
    NSLog(@"[CDVBixolonPrint msrTerminated] ");
}
// ---------------------------------------------------
// willLookupPrinters
// ---------------------------------------------------
- (void) willLookupPrinters:(BXPrinterController *)controller
{
    NSLog(@"[willLookupPrinters]");
    [self clearPrinterList];
}
// ---------------------------------------------------
// didLookupPrinters
// ---------------------------------------------------
- (void)didLookupPrinters:(BXPrinterController *)controller
{
    NSLog(@"[CDVBixolonPrint didLookupPrinters] ");
    _refreshPrinterCount = _refreshPrinterCount + 1;
    [self connect];
}
// ---------------------------------------------------
// didFindPrinter
// ---------------------------------------------------
- (void) didFindPrinter:(BXPrinterController *)controller
                printer:(BXPrinter *)printer
{
    if(printer.connectionClass == BXL_CONNECTIONCLASS_BT)
        NSLog(@"[CDVBixolonPrint didFindPrinter] %@", [NSString stringWithFormat:@"%@ (%@)", printer.name, printer.macAddress ]);
    else
        NSLog(@"[CDVBixolonPrint didFindPrinter] %@", [NSString stringWithFormat:@"%@ (%@)", printer.address, printer.macAddress ]);
    
    [self addPrinterList:printer];
}

// ---------------------------------------------------
// willConnect
// ---------------------------------------------------
- (void)willConnect:(BXPrinterController *)controller
            printer:(BXPrinter *)printer
{
    NSLog(@"[CDVBixolonPrint willConnect] ");
}

// ---------------------------------------------------
// didConnect
// ---------------------------------------------------
- (void)didConnect:(BXPrinterController *)controller
           printer:(BXPrinter *)printer
{
    NSLog(@"[CDVBixolonPrint didConnect]");
    NSLog(@"=========== Information Printing Start  ===========\r\n");
    NSLog(@" * printer name       : %@ \r\n", printer.name);
    NSLog(@" * printer modelStr   : %@ \r\n", printer.modelStr);
    NSLog(@" * printer address    : %@ \r\n", printer.address);
    NSLog(@" * printer macAddress : %@ \r\n", printer.macAddress);
    NSLog(@"=========== Information Printing Finish ===========\r\n");
    
    _isReady = YES;
    
    if ( [_lastCommandName isEqualToString:@"printText"] ) {
        [self _printText];
    } else if ( [_lastCommandName isEqualToString:@"cutPaper"] ) {
        [self _cutPaper];
    } else if ( [_lastCommandName isEqualToString:@"getStatus"] ) {
        [self _getStatus];
    } else {
        
    }
}
// ---------------------------------------------------
// didNotConnect
// ---------------------------------------------------
- (void)didNotConnect:(BXPrinterController *)controller
              printer:(BXPrinter *)printer
            withError:(NSError *)error
{
    NSLog(@"[CDVBixolonPrint didNotConnect] ");
}
// ---------------------------------------------------
// didDisconnect
// ---------------------------------------------------
- (void) didDisconnect:(BXPrinterController *)controller
               printer:(BXPrinter *)printer
{
    NSLog(@"[CDVBixolonPrint didDisconnect]");
}
// ---------------------------------------------------
// didBeBrokenConnection
// ---------------------------------------------------
- (void) didBeBrokenConnection:(BXPrinterController *)controller
                       printer:(BXPrinter *)printer
                     withError:(NSError *)error
{
    NSLog(@"[CDVBixolonPrint didBeBrokenConnection]");
}

// ---------------------------------------------------
// didDisconnect
// ---------------------------------------------------
- (void) didStart
{
    NSLog(@"[CDVBixolonPrint didStart]");
    [self logStatus];
}
// ---------------------------------------------------
// didDisconnect
// ---------------------------------------------------
- (void) didStop
{
    NSLog(@"[CDVBixolonPrint didStop]");
    [self logStatus];
}

//////////////////////////////////////////////////////
// END BIXOLON EVENTS
//////////////////////////////////////////////////////

@end
