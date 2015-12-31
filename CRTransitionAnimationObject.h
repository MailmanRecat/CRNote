//
//  CRTransitionAnimationObject.h
//  BC3DTouch
//
//  Created by caine on 12/6/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CRTransitionAnimationDataSource <NSObject>

- (CGRect)CRTransitionAnimationFolderInitialFrame;
- (CGRect)CRTransitionAnimationFolderFinalFrame;

@end

@interface CRTransitionAnimationObject : NSObject<UIViewControllerTransitioningDelegate>

@property( nonatomic, weak ) id<CRTransitionAnimationDataSource> dataSource;

+ (instancetype)defaultCRTransitionAnimation;
+ (instancetype)folderCRTransitionAnimation;

+ (instancetype)defaultTransitionAnimationObject;

@end
