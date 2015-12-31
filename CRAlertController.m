//
//  CRAlertController.m
//  CRNote
//
//  Created by caine on 12/31/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRAlertController.h"
#import "CRAlertView.h"

@interface CRAlertController()

@property( nonatomic, strong ) CRAlertView *alert;

@end

@implementation CRAlertController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    
    self.alert = ({
        CRAlertView *al = [[CRAlertView alloc] init];
        al.layer.cornerRadius = 3.0;
        al.clipsToBounds = YES;
        [self.view addSubview:al];
        [al.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.7].active = YES;
        [al.heightAnchor constraintEqualToConstant:120].active = YES;
        [al.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
        [al.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
        al;
    });
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = @[
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)],
                         ];
    animation.duration = 1.0;
    animation.removedOnCompletion = YES;
    
    self.alert.transform = CGAffineTransformMakeScale(1.618, 1.618);
    self.alert.alpha = 0;
    [UIView animateWithDuration:0.6
                          delay:0.0f
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alert.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         self.alert.alpha = 1;
                     }completion:nil];
    
//    [self.alert.layer addAnimation:animation forKey:@"dasdsada"];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touched");
    [UIView animateWithDuration:0.6
                          delay:0.0f
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alert.transform = CGAffineTransformMakeScale(1.618, 1.618);
                         self.view.alpha = 0;
                     }completion:^(BOOL f){
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}

@end
