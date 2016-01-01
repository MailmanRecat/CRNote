//
//  CRNoteManager.m
//  CRNote
//
//  Created by caine on 12/26/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRNoteManager.h"
#import "CRNoteDatabase.h"

@interface CRNoteManager()

@property( nonatomic, strong ) CRNote *asset;

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

- (void)letAsset:(CRNote *)note{
    self.asset = note;
}

- (BOOL)letSave{
    BOOL save = NO;
    if( self.asset && [self.asset.noteID isEqualToString:CRNoteInvalidID] ){
        save = [CRNoteDatabase insertNote:self.asset];
        self.asset = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:CR_NOTE_SAVE_NOTIFICATION object:nil];
    }
    
    return save;
}

- (BOOL)letDelete{
    BOOL delete = NO;
    if( self.asset ){
        delete = [CRNoteDatabase deleteNote:self.asset];
        self.asset = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:CR_NOTE_DELETE_NOTIFICATION object:nil];
    }
    
    return delete;
}

- (BOOL)letUpdate{
    BOOL update = NO;
    if( self.asset && [self.asset.noteID isEqualToString:CRNoteInvalidID] == NO ){
        update = [CRNoteDatabase updateNote:self.asset];
        self.asset = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:CR_NOTE_UPDATE_NOTIFICATION object:nil];
    }
    
    return update;
}

+ (NSArray<CRNote *> *)fetchNotes{
    return [CRNoteDatabase selectFormatNoteFromAll];
}

@end
