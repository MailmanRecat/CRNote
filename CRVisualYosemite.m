//
//  CRVisualYosemite.m
//  CRNote
//
//  Created by caine on 12/30/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRVisualYosemite.h"
#import "UIView+CRView.h"
#import "CRNoteApp.h"
#import "UIFont+MaterialDesignIcons.h"

@interface CRVisualYosemite()

@property( nonatomic, strong ) UIImageView *photowall;

@end

@implementation CRVisualYosemite

- (instancetype)initFromEffectStyle:(UIBlurEffectStyle)style{
    self = [super initWithEffect:[UIBlurEffect effectWithStyle:style]];
    
    [self initClass:style];
    
    return self;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    
    self.photowall.image = image;
}

- (void)setContentOpacity:(CGFloat)contentOpacity{
    if( contentOpacity < 0 || contentOpacity > 1 ) return;
    _contentOpacity = contentOpacity;
    
    self.contentView.alpha = 1 - contentOpacity;
    self.layer.shadowOpacity = contentOpacity * 0.27;
}

- (void)initClass:(UIBlurEffectStyle)style{
    
    CGFloat statusFrameHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.heightAnchor constraintEqualToConstant:statusFrameHeight + 128].active = YES;
    [self letShadowWithSize:CGSizeMake(0, 1) opacity:0 radius:1.7];
    
    self.photowall = ({
        UIImageView *wall = [[UIImageView alloc] init];
        wall.translatesAutoresizingMaskIntoConstraints = NO;
        wall.contentMode = UIViewContentModeScaleAspectFill;
        wall.clipsToBounds = YES;
        [self.contentView addSubview:wall];
        [wall.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
        [wall.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
        [wall.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
        [wall.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        wall;
    });
    
    self.nameplate = ({
        UILabel *plate = [[UILabel alloc] init];
        plate.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:plate];
        [plate.heightAnchor constraintGreaterThanOrEqualToConstant:72].active = YES;
        [plate.heightAnchor constraintLessThanOrEqualToConstant:112].active = YES;
        [plate.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8].active = YES;
        [plate.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-8].active = YES;
        [plate.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:64].active = YES;
        plate.textColor = [UIColor whiteColor];
        plate.font = [CRNoteApp appFontOfSize:38 weight:UIFontWeightRegular];
        plate.adjustsFontSizeToFitWidth = YES;
        plate.numberOfLines = 0;
        plate;
    });
    
    self.dismissBtn = ({
        UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(0, statusFrameHeight, 56, 56)];
        [self.contentView addSubview:dismiss];
        [dismiss.titleLabel setFont:[UIFont MaterialDesignIconsWithSize:24]];
        [dismiss setTitle:[UIFont mdiArrowLeft] forState:UIControlStateNormal];
        [dismiss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        dismiss;
    });
}

@end
