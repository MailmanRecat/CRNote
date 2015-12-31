//
//  CRTransitionAnimation.m
//  BC3DTouch
//
//  Created by caine on 12/6/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRTransitionAnimation.h"

@interface CRTransitionAnimation()

@property( nonatomic, assign ) CRTransitionType type;
@property( nonatomic, assign ) CRTransitionAnimationStyle style;

@end

@implementation CRTransitionAnimation

- (instancetype)initFromCRTransitionType:(CRTransitionType)type animationStyle:(CRTransitionAnimationStyle)style{
    self = [super init];
    if( self ){
        self.type = type;
        self.style = style;
        self.duration = 0.25f;
        self.delay = 0.0f;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    if( self.type == CRTransitionTypePresent )
        [self presentTransition:transitionContext];
    
    else if( self.type == CRTransitionTypeDismiss )
        [self dismissTransition:transitionContext];
}

- (void)presentTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    if( self.style == CRTransitionAnimationStyleDefault ){
        
        toView.frame = CGRectMake(screenBounds.size.width, 0, screenBounds.size.width, screenBounds.size.height);
        
        [containerView addSubview:fromView];
        [containerView addSubview:toView];
        
        [UIView animateWithDuration:self.duration
                              delay:0.0f
                            options:( 7 << 16 )
                         animations:^{
                             
                             fromView.frame = CGRectMake(-screenBounds.size.width * 0.3, 0, screenBounds.size.width, screenBounds.size.height);
                             toView.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
                             
                         }completion:^( BOOL isFinished ){
                             if( isFinished ){
                                 [transitionContext completeTransition:YES];
                             }
                         }];
        
    }else if( self.style == CRTransitionAnimationStyleFolder ){
        
        BOOL oc = toView.clipsToBounds;
        toView.frame = self.folderStyleInitialFrame;
        toView.alpha = 0;
        if( !oc ) toView.clipsToBounds = YES;
        
        [containerView addSubview:fromView];
        [containerView addSubview:toView];
        
        [UIView animateWithDuration:self.duration
                              delay:self.delay
                            options:self.viewAnimationOptions
                         animations:^{
                             
                             toView.frame = self.folderStyleFinalFrame;
                             toView.alpha = 1;
                             
                         }completion:^( BOOL isFinished ){
                             if( isFinished ){
                                 toView.clipsToBounds = oc;
                                 [transitionContext completeTransition:YES];
                             }
                         }];
        
    }
    
}

- (void)dismissTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    if( self.style == CRTransitionAnimationStyleDefault ){
        
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
        
        [UIView animateWithDuration:self.duration
                              delay:0.0
                            options:( 7 << 16 )
                         animations:^{
                             
                             fromView.frame = CGRectMake(screenBounds.size.width, 0, screenBounds.size.width, screenBounds.size.height);
                             toView.frame = screenBounds;
                             
                         }completion:^( BOOL isFinished ){
                             if( isFinished ){
                                 [transitionContext completeTransition:YES];
                             }
                         }];
        
    }else if( self.style == CRTransitionAnimationStyleFolder ){
        
        BOOL oc = fromView.clipsToBounds;
        fromView.frame = self.folderStyleFinalFrame;
        fromView.alpha = 1;
        if( !oc ) fromView.clipsToBounds = YES;
        
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
        
        [UIView animateWithDuration:self.duration
                              delay:self.delay
                            options:self.viewAnimationOptions
                         animations:^{
                             
                             fromView.frame = self.folderStyleInitialFrame;
                             fromView.alpha = 0;
                             
                         }completion:^( BOOL isFinished ){
                             if( isFinished ){
                                 fromView.clipsToBounds = oc;
                                 [transitionContext completeTransition:YES];
                             }
                         }];
    
    }

}

@end
