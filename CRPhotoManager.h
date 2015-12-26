//
//  CRPhotoManager.h
//  CRNote
//
//  Created by caine on 12/25/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

static NSString *const CR_PHOTO_MANAGER_SAVE_RESULT_NOTIFICATION = @"CR_PHOTO_MANAGER_SAVE_RESULT_NOTIFICATION";

@interface CRPhotoManager : NSObject

@property( nonatomic, assign ) BOOL photoSaved;
@property( nonatomic, assign ) BOOL thumbnailSaved;
@property( nonatomic, strong ) NSMutableDictionary *photoCache;
@property( nonatomic, strong ) NSMutableDictionary *thumbnailCache;

+ (instancetype)defaultManager;

+ (PHFetchResult *)photos;

+ (NSString *)savePhoto:(PHAsset *)photoAsset;
+ (BOOL)deletePhoto:(NSString *)name;
+ (BOOL)removeAllPhotos:(BOOL)remove;

+ (NSString *)pathFromPhotoname:(NSString *)name;
+ (NSString *)pathFromThumbnail:(NSString *)name;

- (UIImage *)photoFromPhotoname:(NSString *)name;
- (UIImage *)photoFromThumbnail:(NSString *)name;
- (BOOL)clearPhotoCache;
- (BOOL)clearThumbnailCache;

+ (void)runTest;

@end
