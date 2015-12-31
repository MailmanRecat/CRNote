//
//  CRTransitionAnimation.h
//  BC3DTouch
//
//  Created by caine on 12/6/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CRTransitionType){
    CRTransitionTypePresent = 0,
    CRTransitionTypeDismiss
};

typedef NS_ENUM(NSUInteger, CRTransitionAnimationStyle){
    CRTransitionAnimationStyleDefault = 0,
    CRTransitionAnimationStyleFolder
};

@interface CRTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property( nonatomic, assign ) CGFloat duration;
@property( nonatomic, assign ) CGFloat delay;
@property( nonatomic, assign ) UIViewAnimationOptions viewAnimationOptions;

@property( nonatomic, assign ) CGRect folderStyleInitialFrame;
@property( nonatomic, assign ) CGRect folderStyleFinalFrame;

- (instancetype)initFromCRTransitionType:(CRTransitionType)type animationStyle:(CRTransitionAnimationStyle)style;

@end
