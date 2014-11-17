//
//  Common.h
//  Demo
//
//  Created by Beomjin Kim on 11. 3. 16..
//  Copyright 2011 BIXOLON. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Common : NSObject 
{

}

+ (NSString *)localIPAddress;
+ (void) dispatchSelector:(SEL)selector
				   target:(id)target
				  objects:(NSArray*)objects
			 onMainThread:(BOOL)onMainThread;

@end
