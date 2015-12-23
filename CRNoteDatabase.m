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

static NSString *const CRNoteDatabaseFileReferenceCounterKey = @"CR_NOTE_DATABASE_FILE_REFERENCE_COUNTER_";
static NSString *const CRNoteDatabaseFileReferenceImageType = @"IMAGE";
static NSString *const CRNoteDatabaseFileReferenceTxtType = @"TXT";

static NSString *const CR_NOTE_IMAGE_HOME_DIRECTORY = @"CRNoteImages";

@implementation CRNoteDatabase

+ (NSArray *)rowFromCRNote:(CRNote *)note{
    return @[
             note.noteID,
             note.title,
             note.content,
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
    if( [row count] != 12 ) return [CRNote defaultNote];
    
    return [[CRNote alloc] initFromDictionary:@{
                                                CRNoteIDString: row.firstObject,
                                                CRNoteTitleString: row[1],
                                                CRNoteContentString: row[2],
                                                CRNoteColorTypeString: row[3],
                                                CRNoteImageNameString: row[4],
                                                CRNoteTimeCreateString: row[5],
                                                CRNoteTimeUpdateString: row[6],
                                                CRNoteFontnameString: row[7],
                                                CRNoteFontsizeString: row[8],
                                                CRNoteEditableString: row[9],
                                                CRNoteTagString: row[10],
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
    BOOL saved = YES;
    if( note.imageData != nil ){
        NSDictionary *info = [CRNoteDatabase crFileInfoFromType:CRNoteDatabaseFileReferenceImageType];
        note.imageName = (NSString *)info[@"name"];
        NSLog(@"%@", note.imageName);
        saved = [CRNoteDatabase insertNoteImage:note.imageData path:(NSString *)info[@"path"]];
    }
    
    if( !saved ) return NO;
    
    NSMutableArray *notes = [[NSMutableArray alloc] initWithArray:[CRNoteDatabase selectNoteFromAll]];
    [notes insertObject:[CRNoteDatabase rowFromCRNote:note] atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:(NSArray *)notes forKey:CRNoteDatabaseKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

+ (BOOL)deleteNote:(CRNote *)note{
    return [CRNoteDatabase deleteNote:note synchronize:YES];
}

+ (BOOL)deleteNote:(CRNote *)note synchronize:(BOOL)sync{
    
    if( [note.noteID isEqualToString:CRNoteInvalidID] ) return NO;
    
    BOOL delete = YES;
    if( ![note.imageName isEqualToString:CRNoteInvalilImageName] ){
        delete = [CRNoteDatabase deleteNoteImageFromName:note.imageName];
    }
    
    if( delete == NO ) return delete;
    
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

+ (BOOL)removeAllNote:(BOOL)remove{
    if( !remove ) return remove;
    
    NSString *path = [NSString stringWithFormat:@"%@", [CRNoteDatabase dirPathFromType:CRNoteDatabaseFileReferenceImageType]];
    BOOL isDir;
    BOOL delete = NO;
    if( [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir ){
        delete = [[NSFileManager defaultManager] removeItemAtPath:path
                                                            error:nil];
    }
    
    if( delete == NO ) return NO;
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CRNoteDatabaseKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

//NOTE_IMAGE_FUNCTION_START

+ (BOOL)insertNoteImage:(NSData *)imageData path:(NSString *)path{
    
    if( [CRNoteDatabase makeDirCheck:CRNoteDatabaseFileReferenceImageType] ){
        NSLog(@"path %@", path);
        return [imageData writeToFile:path atomically:YES];
    }
    
    return NO;
}

+ (BOOL)deleteNoteImageFromName:(NSString *)name{
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [CRNoteDatabase dirPathFromType:CRNoteDatabaseFileReferenceImageType], name];
    BOOL isDir;
    BOOL delete = NO;
    if( [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && !isDir ){
        delete = [[NSFileManager defaultManager] removeItemAtPath:path
                                                            error:nil];
    }
    
    return delete;
}

+ (BOOL)makeDirCheck:(NSString *)type{
    
    BOOL isDir;
    BOOL pathExists;
    if( ![[NSFileManager defaultManager] fileExistsAtPath:[CRNoteDatabase dirPathFromType:type] isDirectory:&isDir] || !isDir ){
        pathExists = [[NSFileManager defaultManager] createDirectoryAtPath:[CRNoteDatabase dirPathFromType:type]
                                               withIntermediateDirectories:YES
                                                                attributes:nil
                                                                     error:nil];
    }else
        pathExists = YES;
    
    return pathExists;
}

+ (NSDictionary *)crFileInfoFromType:(NSString *)type{
    return ({
        NSString *KEY = [NSString stringWithFormat:@"%@%@", CRNoteDatabaseFileReferenceCounterKey, type];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
         NSUInteger counter = [defaults integerForKey:KEY];
        [defaults setInteger:++counter forKey:KEY];
        [defaults synchronize];
        
        @{
          @"path": [NSString stringWithFormat:@"%@/%@%ld.jpg", [CRNoteDatabase dirPathFromType:type], type, counter],
          @"name": [NSString stringWithFormat:@"%@%ld.jpg", type, counter]
          };
    });
}

+ (NSString *)dirPathFromType:(NSString *)type{
    
    if( type == CRNoteDatabaseFileReferenceImageType )
        return [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), CR_NOTE_IMAGE_HOME_DIRECTORY];
    
    return [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), type];
}

+ (void)runTest{
//    NSLog(@"%@", [self crFilePathFromType:CRNoteDatabaseFileReferenceImageType]);
//    NSLog(@"%@", [self crFilePathFromType:CRNoteDatabaseFileReferenceImageType]);
//    NSLog(@"%@", [self crFilePathFromType:CRNoteDatabaseFileReferenceImageType]);
//    NSLog(@"%@", [self crFilePathFromType:CRNoteDatabaseFileReferenceImageType]);
//    NSLog(@"%@", [self crFilePathFromType:CRNoteDatabaseFileReferenceImageType]);
//    NSLog(@"%@", [self crFilePathFromType:CRNoteDatabaseFileReferenceTxtType]);
//    
//    NSLog(@"path: %d", [self makeDirCheck:CRNoteDatabaseFileReferenceImageType]);
//    NSLog(@"path: %d", [self makeDirCheck:CRNoteDatabaseFileReferenceTxtType]);
    
//    [self insertNoteImage:nil];
}

@end
