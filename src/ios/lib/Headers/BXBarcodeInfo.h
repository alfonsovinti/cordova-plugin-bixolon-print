//
//  BXBarcodeInfo.h
//  BXSDK
//
//  Created by bixolon on 3/20/12.
//  Copyright (c) 2012 BIXOLON. All rights reserved.
//


#import <Foundation/Foundation.h>
@interface BXBarcode:NSObject
{
    
}


@property (assign)  NSInteger       barNumber;
@property (assign)	NSString		*name;
@property (assign)	BOOL            support;


- (id)initWithBarNumber:(NSInteger)barNum
                   name:(NSString*)barName
                support:(BOOL)isSupport;


@end




@interface BXBarcodeInfo: NSObject
{
    NSMutableArray*                 _pBars;
    
	
}

- (NSMutableArray*) getSuppotList;

- (BOOL) clearObject;
- (BOOL) addObjectWithBarcode:(NSInteger)barNum
                         name:(NSString*)barName
                      support:(BOOL)isSupport;
@end
