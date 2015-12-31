//
//  CRVisualButton.m
//  CRNote
//
//  Created by caine on 12/31/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRVisualButton.h"
#import "UIView+CRView.h"

@interface CRVisualButton()

@property( nonatomic, strong ) UILabel *titleLabel;
@property( nonatomic, assign ) UIBlurEffectStyle effectStyle;

@end

@implementation CRVisualButton

- (instancetype)initFromFont:(UIFont *)font title:(NSString *)title blurEffectStyle:(UIBlurEffectStyle)effectStyle{
    self = [super init];
    
    [self initClass:effectStyle];
    [self.titleLabel setFont:font];
    [self.titleLabel setText:title];
    
    return self;
}

- (void)initClass:(UIBlurEffectStyle)style{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.widthAnchor constraintEqualToConstant:56].active = YES;
    [self.heightAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    [self letShadowWithSize:CGSizeMake(0, 1.7f) opacity:0.3f radius:1.7f];
    
    UIVisualEffectView *visualEffect = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:style]];
    visualEffect.translatesAutoresizingMaskIntoConstraints = NO;
    visualEffect.userInteractionEnabled = NO;
    visualEffect.layer.cornerRadius = 56 / 2;
    visualEffect.clipsToBounds = YES;
    [self addSubview:visualEffect];
    [visualEffect.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [visualEffect.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [visualEffect.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [visualEffect.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
    self.titleLabel = ({
        UILabel *tl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
        tl.userInteractionEnabled = NO;
        tl.textAlignment = NSTextAlignmentCenter;
        tl.textColor = style == UIBlurEffectStyleDark ? [UIColor whiteColor] : [UIColor blackColor];
        tl;
    });
    
    [visualEffect.contentView addSubview:self.titleLabel];
}

@end
