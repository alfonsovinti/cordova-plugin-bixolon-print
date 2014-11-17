//
//  CDVBixolonPrint.m
//
//  Created by Alfonso Vinti on 03/06/13.
//
//

#define __lock      [_lock lock]
#define __unlock    [_lock unlock]
#define COMMAND_LIST [NSArray arrayWithObjects: @"printText",@"cutPaper",@"getStatus"]

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
        if(printerController.target)
            [printerController disconnectWithTimeout:3];
        
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
    NSLog(@"[CDVBixolonPrint printText] ");
    if(_isInit != YES){
        [self initAllObject];
    }
    self.lastCommand = command;
    _lastCommandName = @"printText";
    [self connect];
}
- (void) _printText
{
    NSLog(@"[CDVBixolonPrint _printText] print start!");
    
    CDVPluginResult* pluginResult = nil;
    NSArray *obj = [self.lastCommand.arguments objectAtIndex:0];
    int cutLines = 5;//[[self.lastCommand.arguments objectAtIndex:1] intValue];
    [printerController initializePrinter];
    
    if (obj != nil) {
        for (NSUInteger i = 0, count = [obj count]; i < count; i++) {
            id arg = [obj objectAtIndex:i];
            NSLog(@"[CDVBixolonPrint _printText] arg = %@", arg);
            
            if (![arg isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            NSDictionary *dict      = arg;
            NSString *text          = [dict objectForKey:@"text"];
            NSString *align         = [dict objectForKey:@"textAlign"];
            NSNumber *width         = [dict objectForKey:@"textWidth"];
            NSNumber *height        = [dict objectForKey:@"textHeight"];
            NSString *fontType      = [dict objectForKey:@"fontType"];
            NSString *fontStyle     = [dict objectForKey:@"fontStyle"];
            
            [self setAlign:align];
            [self setSize:[width intValue] :[height intValue]];
            [self setFontType:fontType];
            [self setFontStyle:fontStyle];
            
            if( text ) {
                if ( [text length] >= 5 ) {
                    if( [[text substringToIndex:4] isEqualToString:@"[hr]"] && BXL_SUCCESS==[printerController checkPrinter:BXL_MASK_ALL] ) {
                        int paperWidth      = 69;
                        NSString *modelStr  = printerController.target.modelStr;
                        NSString *hrStr     = [text substringWithRange:NSMakeRange(4,1)];
                        text                = @"";
                        
                        if( [modelStr isEqualToString:@"_SPP-R300"] ) {
                            paperWidth = 48;
                        }
                        
                        for (int j = 0; j < paperWidth; j++) {
                            text = [text stringByAppendingString:hrStr];
                        }
                    }
                }
                
                if( BXL_SUCCESS != [printerController printText:[text stringByAppendingFormat:@"\r\n"]]) {
                    NSLog(@"[CDVBixolonPrint _printText] Fail!");
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Fail print text!"];
                    break;
                }else{
                    NSLog(@"[CDVBixolonPrint _printText] Success! text = %@", text);
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                }
            }
        } // end for
        
        NSString *cutStr = @"";
        for (int i = 0; i < cutLines; i++) {
            cutStr = [cutStr stringByAppendingString:@"\r\n"];
        }
        [printerController printText:cutStr];
        [printerController cutPaper];
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
    int cutLines = [[self.lastCommand.arguments objectAtIndex:0] intValue];
    [printerController initializePrinter];
    
    if ( cutLines > 0 ) {
        NSLog(@"[CDVBixolonPrint _cutPaper] Success!");
        NSString *cutStr = @"";
        for (int i = 0; i < cutLines; i++) {
            cutStr = [cutStr stringByAppendingString:@"\r\n"];
        }
        [printerController printText:cutStr];
        [printerController cutPaper];
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
        NSString *versionStr = printerController.target.versionStr;
        NSString *macAddress = printerController.target.macAddress;
        NSString *stateCOVER = (printerController.state&BXL_STS_COVEROPEN)?@"OPENED": @"CLOSED";
        NSString *statePAPER = (printerController.state&BXL_STS_PAPEREMPTY)?@"EMPTY": @"FILL";
        
        NSString *bluetoothDeviceName = printerController.target.bluetoothDeviceName;
        
        NSString *powerStatus;
        switch(printerController.power)
        {
            case BXL_PWR_HIGH:
                powerStatus = @"HIGH";
                break;
            case BXL_PWR_MIDDLE:
                powerStatus = @"MIDDLE";
                break;
            case BXL_PWR_LOW:
                powerStatus = @"LOW";
                break;
            case BXL_PWR_SMALL:
                powerStatus = @"SMALL";
                break;
            case BXL_PWR_NOT:
                powerStatus = @"NOT";
                break;
        }
        
        
        NSDictionary *jsonObj = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 modelStr,    @"printerName",
                                 versionStr,  @"sdkVersion",
                                 macAddress,  @"macAddress",
                                 powerStatus, @"powerStatus",
                                 stateCOVER,  @"coverStatus",
                                 statePAPER,  @"paperStatus"
                                 , nil];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsonObj];
        
        if ( printStatus ) {
            NSString* strPrintText = [NSString stringWithFormat:@" Printer Name : %@\r\n FWVersion:%@\r\n MacAddress : %@\r\n CoverStatus : %@\r\n PaperStatus : %@\r\n PowerStatus : %@\r\n", modelStr, versionStr, macAddress, stateCOVER, statePAPER, powerStatus];
            
            [printerController printText:strPrintText];
            [printerController printText:@"\r\n\r\n\r\n\r\n\r\n"];
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
    
    //int commanIndex = [COMMAND_LIST indexOfObject:_lastCommandName];
    /*switch ( commanIndex ) {
        case 0:
            [self _printText];
            break;
        case 1:
            [self _cutPaper];
            break;
        case 2:
            [self _getStatus];
            break;
            
        default:
            break;
    }*/
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
