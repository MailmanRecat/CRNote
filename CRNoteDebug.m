//
//  CRNoteDebug.m
//  CRNote
//
//  Created by caine on 12/23/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRNoteDebug.h"

@interface CRNoteDebug()

@property( nonatomic, assign ) BOOL isDebug;

@end

@implementation CRNoteDebug

- (instancetype)init{
    self = [super init];
    if( self ){
        self.isDebug = CR_APP_DEBUG;
    }
    return self;
}

+ (instancetype)shareInstance{
    static CRNoteDebug *crnd = nil;
    
    static dispatch_once_t onceTaken;
    dispatch_once(&onceTaken, ^{
        crnd = [[CRNoteDebug alloc] init];
    });
    return crnd;
}

+ (BOOL)isDebug{
    return [[CRNoteDebug shareInstance] isDebug];
}

@end
