//
//  CRNoteDatabase.m
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRNoteDatabase.h"

static NSString *const CR_APP_DOCUMENTS = @"Documents";

static NSString *const CRNoteDatabaseIDCount = @"CR_NOTE_DATABASE_ID_COUNT";
static NSString *const CRNoteDatabaseIDPrefix = @"CR_NOTE_DATABASE_ID_PREFIX";
static NSString *const CRNoteDatabaseKey = @"CR_NOTE_DATABASE_KEY";

static NSString *const CRNoteDatabaseFileReferenceCounterKey = @"CR_NOTE_DATABASE_FILE_REFERENCE_COUNTER_";
static NSString *const CRNoteDatabaseFileReferenceCounterImageKey = @"CR_NOTE_DATABASE_FILE_REFERENCE_COUNTER_IMAGE";
static NSString *const CRNoteDatabaseFileReferenceImageType = @"IMAGE";
static NSString *const CRNoteDatabaseFileReferenceTxtType = @"TXT";

static NSString *const CR_NOTE_IMAGE_HOME_DIRECTORY = @"CRNoteImages";
static NSString *const CR_NOTE_IMAGE_NOTE_THUMBNAIL_DIRECTORY = @"CRNoteThumbnailImages";
static NSString *const CR_NOTE_IMAGE_BASIC_NAME = @"crphoto";

static NSString *const CR_FILE_INFO_PHOTO_NAME_KEY = @"photoname";
static NSString *const CR_FILE_INFO_PHOTO_PATH_KEY = @"photoPath";
static NSString *const CR_FILE_INFO_THUMBNAIL_PATH_KEY = @"thumbnailPath";

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
    
    if( note.type == CRNoteTypeImage && note.imageData && note.thumbnailData ){
        NSDictionary *info = [CRNoteDatabase crImageFileInfo];
        note.imageName = (NSString *)info[CR_FILE_INFO_PHOTO_NAME_KEY];
        
        saved = [CRNoteDatabase insertNoteImage:note.imageData
                                      thumbnail:note.thumbnailData
                                           path:(NSString *)info[CR_FILE_INFO_PHOTO_PATH_KEY]
                                  thumbnailPath:(NSString *)info[CR_FILE_INFO_THUMBNAIL_PATH_KEY]];
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
    
    if( ![note.imageName isEqualToString:CRNoteInvalilImageName] )
        [CRNoteDatabase deleteNoteImageFromName:note.imageName];
    
    __block NSMutableArray *notes = [[NSMutableArray alloc] initWithArray:[CRNoteDatabase selectNoteFromAll]];
    [notes enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger index, BOOL *sS){
        if( [obj.firstObject isEqualToString:note.noteID] ){
            [notes removeObjectAtIndex:index];
            *sS = YES;
        }
    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:(NSArray *)notes forKey:CRNoteDatabaseKey];
    if( sync )
        [[NSUserDefaults standardUserDefaults] synchronize];
    
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
    
    BOOL isDir;
    NSString *photoPath = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), CR_APP_DOCUMENTS, CR_NOTE_IMAGE_HOME_DIRECTORY];
    if( [[NSFileManager defaultManager] fileExistsAtPath:photoPath isDirectory:&isDir] && isDir )
        [[NSFileManager defaultManager] removeItemAtPath:photoPath error:nil];
    
    photoPath = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), CR_APP_DOCUMENTS, CR_NOTE_IMAGE_NOTE_THUMBNAIL_DIRECTORY];
    if( [[NSFileManager defaultManager] fileExistsAtPath:photoPath isDirectory:&isDir] && isDir )
        [[NSFileManager defaultManager] removeItemAtPath:photoPath error:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CRNoteDatabaseKey];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:CRNoteDatabaseFileReferenceCounterImageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

//NOTE_IMAGE_FUNCTION_START

+ (BOOL)insertNoteImage:(NSData *)image thumbnail:(NSData *)thumbnail path:(NSString *)path thumbnailPath:(NSString *)thumbnailPath{
    
    if( [CRNoteDatabase makeDirCheck] )
        return [image writeToFile:path atomically:YES] && [thumbnail writeToFile:thumbnailPath atomically:YES];
    
    return NO;
}

+ (BOOL)deleteNoteImageFromName:(NSString *)name{
    
    NSString *photo = [NSString stringWithFormat:@"%@/%@", [CRNoteDatabase pathFromDir:CR_NOTE_IMAGE_HOME_DIRECTORY], name];
    NSString *thumbnail = [NSString stringWithFormat:@"%@/%@", [CRNoteDatabase pathFromDir:CR_NOTE_IMAGE_NOTE_THUMBNAIL_DIRECTORY], name];
    BOOL isDir;
    BOOL photoDelete = NO, thumbnailDelete = NO;
    if( [[NSFileManager defaultManager] fileExistsAtPath:photo isDirectory:&isDir] && !isDir )
        photoDelete = [[NSFileManager defaultManager] removeItemAtPath:photo error:nil];
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:thumbnail isDirectory:&isDir] && !isDir )
        thumbnailDelete = [[NSFileManager defaultManager] removeItemAtPath:thumbnail error:nil];
    
    return photoDelete && thumbnailDelete;
}

+ (NSString *)pathFromPhotoname:(NSString *)name{
    return [NSString stringWithFormat:@"%@/%@/%@/%@", NSHomeDirectory(), CR_APP_DOCUMENTS, CR_NOTE_IMAGE_HOME_DIRECTORY, name];
}

+ (NSString *)pathFromThumbnail:(NSString *)name{
    return [NSString stringWithFormat:@"%@/%@/%@/%@", NSHomeDirectory(), CR_APP_DOCUMENTS, CR_NOTE_IMAGE_NOTE_THUMBNAIL_DIRECTORY, name];
}

+ (UIImage *)photoFromPhotoname:(NSString *)name{
    NSString *path = [CRNoteDatabase pathFromPhotoname:name];
    if( [[NSFileManager defaultManager] fileExistsAtPath:path] )
        return [UIImage imageWithContentsOfFile:path];
    
    return nil;
}

+ (UIImage *)photoFromThumbnail:(NSString *)name{
    NSString *path = [CRNoteDatabase pathFromThumbnail:name];
    if( [[NSFileManager defaultManager] fileExistsAtPath:path] )
        return [UIImage imageWithContentsOfFile:path];
    
    return nil;
}

+ (BOOL)makeDirCheck{
    
    NSString *(^pathFromDir)(NSString *) = ^(NSString *dir){
        return [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), CR_APP_DOCUMENTS, dir];
    };
    
    BOOL (^checkPath)(NSString *path) = ^(NSString *path){
        BOOL isDir;
        if( [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] || !isDir ){
            return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:nil];
        }else
            return YES;
    };
    
    return checkPath(pathFromDir( CR_NOTE_IMAGE_HOME_DIRECTORY )) && checkPath(pathFromDir( CR_NOTE_IMAGE_NOTE_THUMBNAIL_DIRECTORY ));
}

+ (NSDictionary *)crImageFileInfo{
    return ({
        NSUInteger counter = ({
            NSUserDefaults *dfs = [NSUserDefaults standardUserDefaults];
            NSUInteger counter = [dfs integerForKey:CRNoteDatabaseFileReferenceCounterImageKey];
            [dfs setInteger:++counter forKey:CRNoteDatabaseFileReferenceCounterImageKey];
            [dfs synchronize];
            counter;
        });
        
        @{
          CR_FILE_INFO_PHOTO_PATH_KEY: [NSString stringWithFormat:@"%@/%@%ld.jpg", [CRNoteDatabase pathFromDir:CR_NOTE_IMAGE_HOME_DIRECTORY], CR_NOTE_IMAGE_BASIC_NAME, counter],
          CR_FILE_INFO_THUMBNAIL_PATH_KEY: [NSString stringWithFormat:@"%@/%@%ld.jpg", [CRNoteDatabase pathFromDir:CR_NOTE_IMAGE_NOTE_THUMBNAIL_DIRECTORY], CR_NOTE_IMAGE_BASIC_NAME, counter],
          CR_FILE_INFO_PHOTO_NAME_KEY: [NSString stringWithFormat:@"%@%ld.jpg", CR_NOTE_IMAGE_BASIC_NAME, counter]
          };
    });
}

+ (NSString *)pathFromDir:(NSString *)dir{
    return [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), CR_APP_DOCUMENTS, dir];
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
    
//    NSLog(@"%@", [self crImageFileInfo]);
}

@end
