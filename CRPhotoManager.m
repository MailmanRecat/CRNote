//
//  CRPhotoManager.m
//  CRNote
//
//  Created by caine on 12/25/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define CGSize_iphone4_X( s )  CGSizeMake(320 * s, 148 * s);
#define CGSize_iphone5_X( s )  CGSizeMake(320 * s, 148 * s);
#define CGSize_iphone6_X( s )  CGSizeMake(375 * s, 148 * s);
#define CGSize_iphone6s_X( s ) CGSizeMake(414 * (s + 1), 148 * (s + 1));

#define k_PREVIEW_PHOTO_SCREEN_SCALE 2
#define k_PREVIEW_PHOTO_SCALE 0.6

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
    static CRPhotoManager *photoManager;
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

- (UIImage *)photoFromThumbnail:(NSString *)name{
    UIImage *thumbnail = [[CRPhotoManager defaultManager].thumbnailCache objectForKey:name];
    if( !thumbnail ){
        thumbnail = [UIImage imageWithContentsOfFile:[CRPhotoManager pathFromThumbnail:name]];
        if( thumbnail ){
            [[CRPhotoManager defaultManager].thumbnailCache setObject:thumbnail forKey:name];
        }
    }
    return thumbnail;
}

- (UIImage *)photoFromPhotoname:(NSString *)name{
    UIImage *photo = [[CRPhotoManager defaultManager].photoCache objectForKey:name];
    if( !photo ){
        photo = [UIImage imageWithContentsOfFile:[CRPhotoManager pathFromPhotoname:name]];
        if( photo ){
            [[CRPhotoManager defaultManager].photoCache setObject:photo forKey:name];
        }
    }
    return photo;
}

- (BOOL)clearPhotoCache{
    [[CRPhotoManager defaultManager].photoCache removeAllObjects];
    return YES;
}

- (BOOL)clearThumbnailCache{
    [[CRPhotoManager defaultManager].thumbnailCache removeAllObjects];
    return YES;
}

+ (BOOL)savePhoto:(NSData *)photo path:(NSString *)path{
    return [photo writeToFile:path atomically:YES];
}

+ (BOOL)saveThumbnail:(NSData *)thumbnail path:(NSString *)path{
    return [thumbnail writeToFile:path atomically:YES];
}

+ (NSString *)savePhoto:(PHAsset *)photoAsset{
    NSDictionary *ticket = [CRPhotoManager photoFileInfo];
    
    [CRPhotoManager defaultManager].photoSaved = NO;
    [CRPhotoManager defaultManager].thumbnailSaved = NO;
    
    PHImageRequestOptions *PHO = [[PHImageRequestOptions alloc] init];
    PHO.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    PHO.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    CGSize targetSize;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if( width == 320 )
        targetSize = CGSize_iphone4_X( k_PREVIEW_PHOTO_SCREEN_SCALE )
    else if( width == 375 )
        targetSize = CGSize_iphone6_X( k_PREVIEW_PHOTO_SCREEN_SCALE )
    else if( width == 414 )
        targetSize = CGSize_iphone6s_X( k_PREVIEW_PHOTO_SCREEN_SCALE )
    else
        targetSize = CGSize_iphone6_X( k_PREVIEW_PHOTO_SCREEN_SCALE )
    
    [[PHImageManager defaultManager] requestImageDataForAsset:photoAsset
                                                      options:nil
                                                resultHandler:
     ^(NSData *photo, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info){
         CGFloat size = photo.length / 1024 / 1024.0;
         if( size > 2.6 ){
             photo = UIImageJPEGRepresentation([UIImage imageWithData:photo], 2.6 / size);
         }
         
         if( [CRPhotoManager savePhoto:photo path:(NSString *)ticket[CR_PHOTO_PATH_KEY]] ){
             [CRPhotoManager defaultManager].photoSaved = YES;
         }
         
         if( [CRPhotoManager defaultManager].thumbnailSaved == YES ){
             [[NSNotificationCenter defaultCenter] postNotificationName:CR_PHOTO_MANAGER_SAVE_RESULT_NOTIFICATION object:nil];
         }
         
     }];

    [[PHImageManager defaultManager] requestImageForAsset:photoAsset
                                               targetSize:targetSize
                                              contentMode:PHImageContentModeAspectFill
                                                  options:PHO
                                            resultHandler:
     ^(UIImage *image, NSDictionary *info){
         if( [CRPhotoManager saveThumbnail:UIImageJPEGRepresentation(image, k_PREVIEW_PHOTO_SCALE) path:(NSString *)ticket[CR_THUMBNAIL_PATH_KEY]] ){
             [CRPhotoManager defaultManager].thumbnailSaved = YES;
         }
         
         if( [CRPhotoManager defaultManager].photoSaved == YES ){
             [[NSNotificationCenter defaultCenter] postNotificationName:CR_PHOTO_MANAGER_SAVE_RESULT_NOTIFICATION object:nil];
         }
     }];
    
    return (NSString *)ticket[CR_PHOTO_NAME_KEY];
}

+ (BOOL)deletePhoto:(NSString *)name{
    NSString *photo = [NSString stringWithFormat:@"%@/%@", [CRPhotoManager pathFromDir:CR_NOTE_PHOTO_DIRECTORY], name];
    NSString *thumbnail = [NSString stringWithFormat:@"%@/%@", [CRPhotoManager pathFromDir:CR_NOTE_THUMBNAIL_DIRECTORY], name];
    BOOL isDir;
    BOOL photoDelete = NO, thumbnailDelete = NO;
    if( [[NSFileManager defaultManager] fileExistsAtPath:photo isDirectory:&isDir] && !isDir )
        photoDelete = [[NSFileManager defaultManager] removeItemAtPath:photo error:nil];
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:thumbnail isDirectory:&isDir] && !isDir )
        thumbnailDelete = [[NSFileManager defaultManager] removeItemAtPath:thumbnail error:nil];
    
    [[CRPhotoManager defaultManager].photoCache removeObjectForKey:name];
    [[CRPhotoManager defaultManager].thumbnailCache removeObjectForKey:name];
    
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

+ (NSString *)pathFromPhotoname:(NSString *)name{
    return [NSString stringWithFormat:@"%@/%@/%@/%@", NSHomeDirectory(), CR_APP_DOCUMENTS, CR_NOTE_PHOTO_DIRECTORY, name];
}

+ (NSString *)pathFromThumbnail:(NSString *)name{
    return [NSString stringWithFormat:@"%@/%@/%@/%@", NSHomeDirectory(), CR_APP_DOCUMENTS, CR_NOTE_THUMBNAIL_DIRECTORY, name];
}

+ (NSDictionary *)photoFileInfo{
    return ({
        [CRPhotoManager checkPhotoDir];
        
        NSUInteger counter = ({
            NSUserDefaults *dfs = [NSUserDefaults standardUserDefaults];
            NSUInteger counter = [dfs integerForKey:CR_NOTE_DATABASE_FILE_REFERENCE_COUNTER];
            [dfs setInteger:++counter forKey:CR_NOTE_DATABASE_FILE_REFERENCE_COUNTER];
            [dfs synchronize];
            counter;
        });
        
        NSString *name = [NSString stringWithFormat:@"%@%ld.jpg", CR_NOTE_PHOTO_NAME_FIXFER, (unsigned long)counter];
        
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

+ (BOOL)checkPhotoDir{
    
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
