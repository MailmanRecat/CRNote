//
//  CRPhotoManager.m
//  CRNote
//
//  Created by caine on 12/25/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRPhotoManager.h"

static NSString *const CR_APP_DOCUMENTS = @"Documents";

static NSString *const CR_NOTE_DATABASE_FILE_REFERENCE_COUNTER = @"CRNoteDatabaseFileReferenceCounter";

static NSString *const CR_PHOTO_NAME_KEY = @"name";
static NSString *const CR_PHOTO_PATH_KEY = @"photoPath";
static NSString *const CR_THUMBNAIL_PATH_KEY = @"thumbnailPath";

static NSString *const CR_NOTE_PHOTO_DIRECTORY = @"CRNotePhotos";
static NSString *const CR_NOTE_THUMBNAIL_DIRECTORY = @"CRNoteThumbnails";
static NSString *const CR_NOTE_PHOTO_NAME_FIXFER = @"crnotephoto";

static NSString *const CR_FILE_INFO_PHOTO_NAME_KEY = @"photoname";
static NSString *const CR_FILE_INFO_PHOTO_PATH_KEY = @"photoPath";
static NSString *const CR_FILE_INFO_THUMBNAIL_PATH_KEY = @"thumbnailPath";

@interface CRPhotoManager()

//@property( nonatomic, strong ) NSMutableDictionary *photoCache;
//@property( nonatomic, strong ) NSMutableDictionary *thumbnailCache;

@end

@implementation CRPhotoManager

+ (instancetype)defaultManager{
    static CRPhotoManager *photoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photoManager = [[CRPhotoManager alloc] init];
    });
    return photoManager;
}

- (instancetype)init{
    self = [super init];
    if( self ){
        self.photoCache = [[NSMutableDictionary alloc] init];
        self.thumbnailCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (NSString *)pathFromPhotoname:(NSString *)name{
    return [NSString stringWithFormat:@"%@/%@/%@/%@", NSHomeDirectory(), CR_APP_DOCUMENTS, CR_NOTE_PHOTO_DIRECTORY, name];
}

+ (NSString *)pathFromThumbnail:(NSString *)name{
    return [NSString stringWithFormat:@"%@/%@/%@/%@", NSHomeDirectory(), CR_APP_DOCUMENTS, CR_NOTE_THUMBNAIL_DIRECTORY, name];
}

- (UIImage *)photoFromThumbnail:(NSString *)name{
    UIImage *photo = [[CRPhotoManager defaultManager].photoCache objectForKey:name];
    if( !photo ){
        photo = [UIImage imageWithContentsOfFile:[CRPhotoManager pathFromPhotoname:name]];
        [[CRPhotoManager defaultManager].photoCache setObject:photo forKey:name];
    }
    return photo;
}

- (UIImage *)photoFromPhotoname:(NSString *)name{
    UIImage *thumbnail = [[CRPhotoManager defaultManager].thumbnailCache objectForKey:name];
    if( !thumbnail ){
        thumbnail = [UIImage imageWithContentsOfFile:[CRPhotoManager pathFromThumbnail:name]];
        [[CRPhotoManager defaultManager].thumbnailCache setObject:thumbnail forKey:name];
    }
    return thumbnail;
}

+ (NSString *)savePhoto:(NSData *)photo thumbnail:(NSData *)thumbnail{
    NSDictionary *info = [CRPhotoManager photoFileInfo];
    if( [photo writeToFile:(NSString *)info[CR_PHOTO_PATH_KEY] atomically:YES] &&
        [thumbnail writeToFile:(NSString *)info[CR_THUMBNAIL_PATH_KEY] atomically:YES] )
    {
        return (NSString *)info[CR_PHOTO_NAME_KEY];
    }
    
    return nil;
}

+ (NSString *)savePhoto:(PHAsset *)photoAsset{
    NSDictionary *info = [CRPhotoManager photoFileInfo];
    
    
    
    return (NSString *)info[CR_PHOTO_NAME_KEY];
}

+ (BOOL)deletePhotoFromName:(NSString *)name{
    NSString *photo = [NSString stringWithFormat:@"%@/%@", [CRPhotoManager pathFromDir:CR_NOTE_PHOTO_DIRECTORY], name];
    NSString *thumbnail = [NSString stringWithFormat:@"%@/%@", [CRPhotoManager pathFromDir:CR_NOTE_THUMBNAIL_DIRECTORY], name];
    BOOL isDir;
    BOOL photoDelete = NO, thumbnailDelete = NO;
    if( [[NSFileManager defaultManager] fileExistsAtPath:photo isDirectory:&isDir] && !isDir )
        photoDelete = [[NSFileManager defaultManager] removeItemAtPath:photo error:nil];
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:thumbnail isDirectory:&isDir] && !isDir )
        thumbnailDelete = [[NSFileManager defaultManager] removeItemAtPath:thumbnail error:nil];
    
    return photoDelete && thumbnailDelete;
}

+ (BOOL)removeAllPhotos:(BOOL)remove{
    if( remove == NO ) return YES;
    
    BOOL isDir;
    NSString *photoPath = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), CR_APP_DOCUMENTS, CR_NOTE_PHOTO_DIRECTORY];
    if( [[NSFileManager defaultManager] fileExistsAtPath:photoPath isDirectory:&isDir] && isDir )
        [[NSFileManager defaultManager] removeItemAtPath:photoPath error:nil];
    
    photoPath = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), CR_APP_DOCUMENTS, CR_NOTE_THUMBNAIL_DIRECTORY];
    if( [[NSFileManager defaultManager] fileExistsAtPath:photoPath isDirectory:&isDir] && isDir )
        [[NSFileManager defaultManager] removeItemAtPath:photoPath error:nil];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:CR_NOTE_DATABASE_FILE_REFERENCE_COUNTER];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

+ (NSDictionary *)photoFileInfo{
    return ({
        NSUInteger counter = ({
            NSUserDefaults *dfs = [NSUserDefaults standardUserDefaults];
            NSUInteger counter = [dfs integerForKey:CR_NOTE_DATABASE_FILE_REFERENCE_COUNTER];
            [dfs setInteger:++counter forKey:CR_NOTE_DATABASE_FILE_REFERENCE_COUNTER];
            [dfs synchronize];
            counter;
        });
        
        NSString *name = [NSString stringWithFormat:@"%@%ld.jpg", CR_NOTE_PHOTO_NAME_FIXFER, counter];
        
        @{
          CR_PHOTO_PATH_KEY: [CRPhotoManager pathFromPhotoname:name],
          CR_THUMBNAIL_PATH_KEY: [CRPhotoManager pathFromThumbnail:name],
          CR_PHOTO_NAME_KEY: name
          };
    });
}

+ (NSString *)pathFromDir:(NSString *)dir{
    return [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), CR_APP_DOCUMENTS, dir];
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
    
    return checkPath(pathFromDir( CR_NOTE_PHOTO_DIRECTORY )) && checkPath(pathFromDir( CR_NOTE_THUMBNAIL_DIRECTORY ));
}

+ (PHFetchResult *)photos{
    PHFetchOptions *PHO = [[PHFetchOptions alloc] init];
    PHO.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    return [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:PHO];
}

+ (void)runTest{
//    NSLog(@"%@", [CRPhotoManager photoFileInfo]);
}

@end
