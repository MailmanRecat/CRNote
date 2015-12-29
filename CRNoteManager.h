//
//  CRNoteManager.h
//  CRNote
//
//  Created by caine on 12/26/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRNoteDatabase.h"

@interface CRNoteManager : NSObject

@property( nonatomic, strong ) CRNote *noteasset;
@property( nonatomic, assign ) BOOL save;

+ (instancetype)defaultManager;

+ (NSArray<CRNote *> *)fetchNotes;


@end
