//
//  CRMutableStack.m
//  CRNote
//
//  Created by caine on 1/6/16.
//  Copyright © 2016 com.caine. All rights reserved.
//

#import "CRMutableStack.h"

@interface CRMutableStack()

@property( nonatomic, strong ) NSMutableArray *crStack;

@end

@implementation CRMutableStack

- (instancetype)init{
    return [self initFromArray:nil];
}

- (instancetype)initFromArray:(NSArray *)array{
    self = [super init];
    if( self ){
        self.crStack = [[NSMutableArray alloc] initWithArray:array];
    }
    return self;
}

- (void)push:(id)object{
    [self.crStack addObject:object];
}

- (id)pop{
    return ({
        id obj = self.crStack.lastObject;
        obj ? ({ [self.crStack removeLastObject]; obj; }) : nil;
    });
}

- (NSUInteger)count{
    return [self.crStack count];
}

@end
