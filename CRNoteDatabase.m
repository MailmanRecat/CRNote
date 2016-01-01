//
//  CRNoteDatabase.m
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRNoteDatabase.h"
#import "CRPhotoManager.h"

static NSString *const CRNoteDatabaseIDCount = @"CR_NOTE_DATABASE_ID_COUNT";
static NSString *const CRNoteDatabaseIDPrefix = @"CR_NOTE_DATABASE_ID_PREFIX";
static NSString *const CR_NOTE_DATABASE_KEY = @"CR_NOTE_DATABASE_KEY";

@implementation CRNoteDatabase

+ (NSArray *)rowFromCRNote:(CRNote *)note{
    return @[
             note.noteID,
             note.title,
             note.content,
             note.contentPreview,
             note.colorType,
             note.imageName,
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
    if( [row count] != 13 ) return [CRNote defaultNote];
    
    return [[CRNote alloc] initFromDictionary:@{
                                                CRNoteIDString: row.firstObject,
                                                CRNoteTitleString: row[1],
                                                CRNoteContentString: row[2],
                                                CRNoteContentPreviewString: row[3],
                                                CRNoteColorTypeString: row[4],
                                                CRNoteImageNameString: row[5],
                                                CRNoteTimeCreateString: row[6],
                                                CRNoteTimeUpdateString: row[7],
                                                CRNoteFontnameString: row[8],
                                                CRNoteFontsizeString: row[9],
                                                CRNoteEditableString: row[10],
                                                CRNoteTagString: row[11],
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
    return [[NSUserDefaults standardUserDefaults] objectForKey:CR_NOTE_DATABASE_KEY];
}

+ (BOOL)insertNote:(CRNote *)note{
    
    note.noteID = [CRNoteDatabase makeCRNoteIDKey];

    if( note.type == CRNoteTypePhoto && note.photoAsset ){
        note.imageName = [CRPhotoManager savePhoto:note.photoAsset];
        if( note.imageName == nil ){
            return NO;
        }
    }
    
    NSMutableArray *notes = [[NSMutableArray alloc] initWithArray:[CRNoteDatabase selectNoteFromAll]];
    [notes insertObject:[CRNoteDatabase rowFromCRNote:note] atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:(NSArray *)notes forKey:CR_NOTE_DATABASE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

+ (BOOL)deleteNote:(CRNote *)note{
    
    if( [note.imageName isEqualToString:CRNoteInvalilImageName] == NO ){
        [CRPhotoManager deletePhoto:note.imageName];
        note.imageName = CRNoteInvalilImageName;
    }
    
    return [CRNoteDatabase deleteNote:note synchronize:YES];
}

+ (BOOL)deleteNote:(CRNote *)note synchronize:(BOOL)sync{
    if( [note.noteID isEqualToString:CRNoteInvalidID] ) return NO;
    
    __block NSMutableArray *notes = [[NSMutableArray alloc] initWithArray:[CRNoteDatabase selectNoteFromAll]];
    [notes enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger index, BOOL *sS){
        if( [obj.firstObject isEqualToString:note.noteID] ){
            [notes removeObjectAtIndex:index];
            *sS = YES;
        }
    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:(NSArray *)notes forKey:CR_NOTE_DATABASE_KEY];
    if( sync )
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

+ (BOOL)updateNote:(CRNote *)note{
    
    if( ![note.imageName isEqualToString:CRNoteInvalilImageName] && note.photoAsset ){
        [CRPhotoManager deletePhoto:note.imageName];
        note.imageName = CRNoteInvalilImageName;
    }
    
    BOOL delete = [CRNoteDatabase deleteNote:note synchronize:NO];
    if( delete )
        [CRNoteDatabase insertNote:note];
    
    return YES;
}

+ (BOOL)removeAllNote:(BOOL)remove{
    if( !remove ) return remove;
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CR_NOTE_DATABASE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return [CRPhotoManager removeAllPhotos:YES];
}

+ (void)runTest{

}

@end
