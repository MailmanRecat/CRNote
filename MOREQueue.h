//
//  MOREQueue.h
//  CDemo
//
//  Created by caine on 11/16/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOREQueue : NSObject

- (instancetype)initWithArray:(NSArray *)array;

- (id)popObj;
- (void)addObj:(id)obj;
- (NSUInteger)count;

@end
