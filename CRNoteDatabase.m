//
//  CRNoteDatabase.m
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRNoteDatabase.h"

static NSString *const CRNoteDatabaseIDCount = @"CR_NOTE_DATABASE_ID_COUNT";
static NSString *const CRNoteDatabaseIDPrefix = @"CR_NOTE_DATABASE_ID_PREFIX";
static NSString *const CRNoteDatabaseKey = @"CR_NOTE_DATABASE_KEY";

@implementation CRNoteDatabase

+ (NSArray *)rowFromCRNote:(CRNote *)note{
    return @[
             note.noteID,
             note.title,
             note.content,
             note.colorType,
             note.timeCreate,
             note.timeUpdate,
             note.fontname,
             note.fontsize,
             note.editable,
             note.tag,
             note.type
             ];
}

+ (CRNote *)crnoteFromRow:(NSArray *)row{
    if( [row count] != 11 ) return [CRNote defaultNote];
    
    return [[CRNote alloc] initFromDictionary:@{
                                                CRNoteIDString: row.firstObject,
                                                CRNoteTitleString: row[1],
                                                CRNoteContentString: row[2],
                                                CRNoteColorTypeString: row[3],
                                                CRNoteTimeCreateString: row[4],
                                                CRNoteTimeUpdateString: row[5],
                                                CRNoteFontnameString: row[6],
                                                CRNoteFontsizeString: row[7],
                                                CRNoteEditableString: row[8],
                                                CRNoteTagString: row[9],
                                                CRNoteTypeString: row.lastObject
                                                }];
}

+ (NSString *)makeCRNoteIDKey{
    
    NSUInteger scheduleID = [[NSUserDefaults standardUserDefaults] integerForKey:CRNoteDatabaseIDCount];
    [[NSUserDefaults standardUserDefaults] setInteger:++scheduleID forKey:CRNoteDatabaseIDCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return [NSString stringWithFormat:@"%@%ld", CRNoteDatabaseIDPrefix, (unsigned long)scheduleID];
}

+ (NSArray *)selectFormatNoteFromAll{
    __block NSMutableArray *notes = [[NSMutableArray alloc] initWithArray:[CRNoteDatabase selectNoteFromAll]];
    [notes enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger index, BOOL *sS){
        [notes replaceObjectAtIndex:index withObject:[CRNoteDatabase crnoteFromRow:obj]];
    }];
    
    return (NSArray *)notes;
}

+ (NSArray *)selectNoteFromAll{
    return [[NSUserDefaults standardUserDefaults] objectForKey:CRNoteDatabaseKey];
}

+ (BOOL)insertNote:(CRNote *)note{
    
    note.noteID = [CRNoteDatabase makeCRNoteIDKey];
    
    NSMutableArray *notes = [[NSMutableArray alloc] initWithArray:[CRNoteDatabase selectNoteFromAll]];
    [notes insertObject:[CRNoteDatabase rowFromCRNote:note] atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:(NSArray *)notes forKey:CRNoteDatabaseKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

+ (BOOL)deleteNote:(CRNote *)note{
    
    if( [note.noteID isEqualToString:CRNoteInvalidID] ) return NO;
    
    return [CRNoteDatabase deleteNote:note synchronize:YES];
}

+ (BOOL)deleteNote:(CRNote *)note synchronize:(BOOL)sync{
    
    __block NSMutableArray *notes = [[NSMutableArray alloc] initWithArray:[CRNoteDatabase selectNoteFromAll]];
    [notes enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger index, BOOL *sS){
        if( [obj.firstObject isEqualToString:note.noteID] ){
            [notes removeObjectAtIndex:index];
            *sS = YES;
        }
    }];
    
    if( sync ){
        [[NSUserDefaults standardUserDefaults] setObject:(NSArray *)notes forKey:CRNoteDatabaseKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return YES;
}

+ (BOOL)updateNote:(CRNote *)note{
    
    BOOL delete = [CRNoteDatabase deleteNote:note synchronize:NO];
    if( delete )
        [CRNoteDatabase insertNote:note];
    
    return YES;
}

@end
