//
//  CRVisualAdBoard.m
//  CRNote
//
//  Created by caine on 12/31/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRVisualAdBoard.h"
#import "CRNoteApp.h"

@interface CRVisualAdBoard()

@property( nonatomic, strong ) NSLayoutConstraint *wallLayoutGuide;

@property( nonatomic, strong ) UIImageView *photoWall;

@end

@implementation CRVisualAdBoard

- (instancetype)initFromEffectStyle:(UIBlurEffectStyle)style{
    self = [super initWithEffect:[UIBlurEffect effectWithStyle:style]];
    
    [self initClass:style];
    
    return self;
}

- (instancetype)init{
    self = [super init];
    
    [self initClass:UIBlurEffectStyleDark];
    
    return self;
}

- (void)setEffect:(UIVisualEffect *)effect{
    [super setEffect:effect];
}

- (void)initClass:(UIBlurEffectStyle)style{
    self.message = ({
        UILabel *msg = [[UILabel alloc] init];
        msg.translatesAutoresizingMaskIntoConstraints = NO;
        msg.adjustsFontSizeToFitWidth = YES;
        msg.text = @"Notes you add appear here";
        msg.textColor = style == UIBlurEffectStyleDark ? [UIColor colorWithWhite:1 alpha:1] : [UIColor colorWithWhite:0 alpha:1];
        msg.textAlignment = NSTextAlignmentCenter;
        msg.font = [CRNoteApp appFontOfSize:20 weight:UIFontWeightRegular];
        [self.contentView addSubview:msg];
        [msg.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor constant:-32].active = YES;
        [msg.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
        [msg.heightAnchor constraintEqualToConstant:56.0].active = YES;
        self.wallLayoutGuide = [msg.centerYAnchor constraintEqualToAnchor:self.contentView.topAnchor];
        self.wallLayoutGuide.active = YES;
        msg;
    });
}

- (void)layoutSubviews{
    self.wallLayoutGuide.constant = (self.frame.size.height + 76) * 0.382;
    
    [self.message layoutIfNeeded];
}

@end
