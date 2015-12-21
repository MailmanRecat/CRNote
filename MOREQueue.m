//
//  MOREQueue.m
//  CDemo
//
//  Created by caine on 11/16/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "MOREQueue.h"

@interface MOREQueue()

@property( nonatomic, strong ) NSMutableArray *queue;

@end

@implementation MOREQueue

- (instancetype)init{
    self = [super init];
    if( self ){
        _queue = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithArray:(NSArray *)array{
    self = [super init];
    if( self ){
        
        _queue = [[NSMutableArray alloc] initWithArray:array];
        
    }
    return self;
}

- (id)popObj{
    if( [_queue count] == 0 ) return nil;
    
    id obj = [_queue firstObject];
    [_queue removeObjectAtIndex:0];
    
    return obj;
}

- (void)addObj:(id)obj{
    [_queue addObject:obj];
}

- (NSUInteger)count{
    return [_queue count];
}

@end
