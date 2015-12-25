//
//  CRPhotoManager.h
//  CRNote
//
//  Created by caine on 12/25/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface CRPhotoManager : NSObject

@property( nonatomic, strong ) NSMutableDictionary *photoCache;
@property( nonatomic, strong ) NSMutableDictionary *thumbnailCache;

+ (instancetype)defaultManager;

+ (PHFetchResult *)photos;

+ (NSString *)savePhoto:(NSData *)photo thumbnail:(NSData *)thumbnail;
+ (NSString *)savePhoto:(PHAsset *)photoAsset;
+ (BOOL)deletePhotoFromName:(NSString *)name;
+ (BOOL)removeAllPhotos:(BOOL)remove;

+ (NSString *)pathFromPhotoname:(NSString *)name;
+ (NSString *)pathFromThumbnail:(NSString *)name;
- (UIImage *)photoFromPhotoname:(NSString *)name;
- (UIImage *)photoFromThumbnail:(NSString *)name;

+ (void)runTest;

@end
