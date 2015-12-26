//
//  CRNoteManager.m
//  CRNote
//
//  Created by caine on 12/26/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRNoteManager.h"

@interface CRNoteManager()

@end

@implementation CRNoteManager

+ (instancetype)defaultManager{
    static CRNoteManager *noteManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        noteManager = [[CRNoteManager alloc] init];
    });
    return noteManager;
}

+ (NSArray<CRNote *> *)fetchNotes{
    return [CRNoteDatabase selectFormatNoteFromAll];
}

@end
