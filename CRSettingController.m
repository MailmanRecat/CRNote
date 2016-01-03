//
//  CRSettingController.m
//  CRNote
//
//  Created by caine on 12/31/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRSettingController.h"
#import "CRTransitionAnimationObject.h"

@interface CRSettingController()

@property( nonatomic, strong ) UIVisualEffectView *stone;

@end

@implementation CRSettingController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self letStone];
//    self.transitioningDelegate = [CRTransitionAnimationObject defaultTransitionAnimationObject];
}

- (void)letStone{
    self.stone = ({
        UIVisualEffectView *sto = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        sto.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:sto];
        [sto.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
        [sto.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
        [sto.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
        [sto.heightAnchor constraintEqualToConstant:STATUS_BAR_HEIGHT + 56].active = YES;
        sto;
    });
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
