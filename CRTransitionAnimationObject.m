//
//  CRTransitionAnimationObject.m
//  BC3DTouch
//
//  Created by caine on 12/6/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRTransitionAnimationObject.h"
#import "CRTransitionAnimation.h"

@interface CRTransitionAnimationObject()

@property( nonatomic, strong ) CRTransitionAnimation *presentAnimation;
@property( nonatomic, strong ) CRTransitionAnimation *dismissAnimation;
@property( nonatomic, assign ) CRTransitionAnimationStyle animationStyle;

@end

@implementation CRTransitionAnimationObject

+ (instancetype)defaultCRTransitionAnimation{
    return [[CRTransitionAnimationObject alloc] initFromCRTransitionAnimationStyle:CRTransitionAnimationStyleDefault];
}
+ (instancetype)folderCRTransitionAnimation{
    CRTransitionAnimationObject *object = [[CRTransitionAnimationObject alloc] initFromCRTransitionAnimationStyle:CRTransitionAnimationStyleFolder];
    
    object.presentAnimation.duration = object.dismissAnimation.duration = 0.37f;
    object.presentAnimation.viewAnimationOptions = object.dismissAnimation.viewAnimationOptions = UIViewAnimationCurveEaseIn;
    
    return object;
}

+ (instancetype)defaultTransitionAnimationObject{
    static CRTransitionAnimationObject *objectSelf;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objectSelf = [CRTransitionAnimationObject defaultTransitionAnimationObject];
    });
    return objectSelf;
}

- (instancetype)initFromCRTransitionAnimationStyle:(CRTransitionAnimationStyle)style{
    self = [super init];
    if( self ){
        self.animationStyle = style;
        self.presentAnimation = [[CRTransitionAnimation alloc] initFromCRTransitionType:CRTransitionTypePresent
                                                                         animationStyle:style];
        
        self.dismissAnimation = [[CRTransitionAnimation alloc] initFromCRTransitionType:CRTransitionTypeDismiss
                                                                         animationStyle:style];
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    if( self.animationStyle == CRTransitionAnimationStyleFolder ){
        [self makeFolderStyleFrame];
    }
    
    return self.presentAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    return self.dismissAnimation;
}

- (void)makeFolderStyleFrame{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    if( self.dataSource && [self.dataSource respondsToSelector:@selector(CRTransitionAnimationFolderInitialFrame)] ){
        self.presentAnimation.folderStyleInitialFrame = self.dismissAnimation.folderStyleInitialFrame = [self.dataSource CRTransitionAnimationFolderInitialFrame];
    }else{
        self.presentAnimation.folderStyleInitialFrame = self.dismissAnimation.folderStyleInitialFrame = CGRectMake(0, screenBounds.size.height / 2, screenBounds.size.width, 0);
    }
    
    if( self.dataSource && [self.dataSource respondsToSelector:@selector(CRTransitionAnimationFolderFinalFrame)] ){
        self.presentAnimation.folderStyleFinalFrame = self.dismissAnimation.folderStyleFinalFrame = [self.dataSource CRTransitionAnimationFolderFinalFrame];
    }else{
        self.presentAnimation.folderStyleFinalFrame = self.dismissAnimation.folderStyleFinalFrame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
    }

}

@end
