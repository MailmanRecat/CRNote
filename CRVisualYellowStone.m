//
//  CRVisualYellowStone.m
//  CRNote
//
//  Created by caine on 12/30/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRVisualYellowStone.h"
#import "UIFont+MaterialDesignIcons.h"
#import "UIView+CRView.h"
#import "CRNoteApp.h"

@interface CRVisualYellowStone()

@property( nonatomic, strong ) UILabel *notificationLabel;

@end

@implementation CRVisualYellowStone

- (instancetype)initFromEffectStyle:(UIBlurEffectStyle)style{
    self = [super initWithEffect:[UIBlurEffect effectWithStyle:style]];
    [self initClass:style];
    return self;
}

- (void)setNotification:(NSString *)notification{
    if( notification && self.notificationLabel.hidden == NO ) return;
    if( !notification && self.notificationLabel.hidden ) return;
    
    _notification = notification;
    
    self.notificationLabel.hidden = notification ? NO : YES;
    
    if( notification )
        self.notificationLabel.text = notification;
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.notificationLabel.alpha = notification ? 1 : 0;
                     }completion:^(BOOL f){
                         if( notification == nil )
                             self.notificationLabel.hidden = YES;
                     }];
}

- (void)setShadowEnable:(BOOL)shadowEnable{
    if( _shadowEnable == shadowEnable ) return;
    _shadowEnable = shadowEnable;
    
    self.layer.shadowOpacity = shadowEnable ? 0.27 : 0;
}

- (void)initClass:(UIBlurEffectStyle)style{
    [self letShadowWithSize:CGSizeMake(0, 1) opacity:0 radius:1.7];
    
    self.notificationLabel = ({
        UILabel *noti = [[UILabel alloc] init];
        noti.translatesAutoresizingMaskIntoConstraints = NO;
        noti.adjustsFontSizeToFitWidth = YES;
        noti.font = [CRNoteApp appFontOfSize:20 weight:UIFontWeightRegular];
        noti.textColor = style == UIBlurEffectStyleDark ? [UIColor whiteColor] : [UIColor blackColor];
        noti.textAlignment = NSTextAlignmentCenter;
        noti.hidden = YES;
        [self.contentView addSubview:noti];
        [noti.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16].active = YES;
        [noti.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-16].active = YES;
        [noti.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-56 - [UIApplication sharedApplication].statusBarFrame.size.height].active = YES;
        [noti.heightAnchor constraintEqualToConstant:36.0].active = YES;
        noti;
    });
    
    self.nameplate = ({
        UILabel *plate = [[UILabel alloc] init];
        plate.translatesAutoresizingMaskIntoConstraints = NO;
        plate.font = [CRNoteApp appFontOfSize:21 weight:UIFontWeightLight];
        plate.text = @"Notes";
        plate.textColor = style == UIBlurEffectStyleDark ? [UIColor whiteColor] : [UIColor blackColor];
        [self.contentView addSubview:plate];
        [plate.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:76].active = YES;
        [plate.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier:0.6].active = YES;
        [plate.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        [plate.heightAnchor constraintEqualToConstant:56.0].active = YES;
        plate;
    });
    
    self.leftStone = ({
        UIButton *sto = [[UIButton alloc] init];
        sto.translatesAutoresizingMaskIntoConstraints = NO;
        [sto.titleLabel setFont:[UIFont MaterialDesignIconsWithSize:24]];
        [sto setTitle:[UIFont mdiMenu] forState:UIControlStateNormal];
        [sto setTitleColor:style == UIBlurEffectStyleDark ? [UIColor whiteColor] : [UIColor blackColor] forState:UIControlStateNormal];
        [sto setTitleColor:style == UIBlurEffectStyleDark ? [UIColor colorWithWhite:1 alpha:0.5] : [UIColor colorWithWhite:0 alpha:0.5]
                  forState:UIControlStateHighlighted];
        [self.contentView addSubview:sto];
        [sto.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
        [sto.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        [sto.widthAnchor constraintEqualToConstant:56.0].active = YES;
        [sto.heightAnchor constraintEqualToConstant:56.0].active = YES;
        sto;
    });
    
    self.stone = ({
        UIButton *sto = [[UIButton alloc] init];
        sto.translatesAutoresizingMaskIntoConstraints = NO;
        [sto.titleLabel setFont:[UIFont MaterialDesignIconsWithSize:24]];
        [sto setTitle:[UIFont mdiMagnify] forState:UIControlStateNormal];
        [sto setTitleColor:style == UIBlurEffectStyleDark ? [UIColor whiteColor] : [UIColor blackColor] forState:UIControlStateNormal];
        [sto setTitleColor:style == UIBlurEffectStyleDark ? [UIColor colorWithWhite:1 alpha:0.5] : [UIColor colorWithWhite:0 alpha:0.5]
                  forState:UIControlStateHighlighted];
        [self.contentView addSubview:sto];
        [sto.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:56].active = YES;
        [sto.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        [sto.widthAnchor constraintEqualToConstant:56.0].active = YES;
        [sto.heightAnchor constraintEqualToConstant:56.0].active = YES;
        sto;
    });
    
    self.toggle = ({
        GoogleToggle *tog = [[GoogleToggle alloc] init];
        tog.tipTheme = [UIColor colorWithWhite:89 / 255 alpha:1];
        [self.contentView addSubview:tog];
        [tog.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-8].active = YES;
        [tog.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        tog;
    });
    
}

@end
