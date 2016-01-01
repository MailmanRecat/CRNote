//
//  CRNoteManager.h
//  CRNote
//
//  Created by caine on 12/26/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRNoteDatabase.h"

static NSString *const CR_NOTE_SAVE_NOTIFICATION = @"CR_NOTE_SAVE_NOTIFICATION";
static NSString *const CR_NOTE_DELETE_NOTIFICATION = @"CR_NOTE_DELETE_NOTIFICATION";
static NSString *const CR_NOTE_UPDATE_NOTIFICATION = @"CR_NOTE_UPDATE_NOTIFICATION";

@interface CRNoteManager : NSObject

//@property( nonatomic, strong ) CRNote *asset;

+ (instancetype)defaultManager;
+ (NSArray<CRNote *> *)fetchNotes;

- (void)letAsset:(CRNote *)note;
- (BOOL)letSave;
- (BOOL)letDelete;
- (BOOL)letUpdate;


@end
