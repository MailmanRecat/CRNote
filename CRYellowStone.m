//
//  CRYellowStone.m
//  CRNote
//
//  Created by caine on 12/29/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRYellowStone.h"
#import "UIView+CRView.h"
#import "UIFont+MaterialDesignIcons.h"
#import "CRNoteApp.h"

@interface CRYellowStone()

@property( nonatomic, strong ) UIView *contentView;
@property( nonatomic, strong ) UILabel *notificationLabel;

@end

@implementation CRYellowStone

- (instancetype)init{
    self = [super init];
    [self initClass];
    return self;
}

- (void)setTheme:(UIColor *)theme{
    _theme = theme;
    self.backgroundColor = theme;
    self.toggle.tipTheme = theme;
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

- (void)initClass{
    
    [self makeShadowWithSize:CGSizeMake(0, 1) opacity:0 radius:1.7];
    
    self.contentView = ({
        UIView *content = [[UIView alloc] init];
        content.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:content];
        [content.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [content.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        [content.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
        [content.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        content;
    });
    
    self.notificationLabel = ({
        UILabel *noti = [[UILabel alloc] init];
        noti.translatesAutoresizingMaskIntoConstraints = NO;
        noti.adjustsFontSizeToFitWidth = YES;
        noti.font = [CRNoteApp appFontOfSize:20 weight:UIFontWeightRegular];
        noti.textColor = [UIColor whiteColor];
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
        plate.font = [CRNoteApp appFontOfSize:25 weight:UIFontWeightRegular];
        plate.text = @"Notes";
        plate.textColor = [UIColor whiteColor];
        [self.contentView addSubview:plate];
        [plate.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16].active = YES;
        [plate.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier:0.6].active = YES;
        [plate.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        [plate.heightAnchor constraintEqualToConstant:56.0].active = YES;
        plate;
    });
    
    self.stone = ({
        UIButton *sto = [[UIButton alloc] init];
        sto.translatesAutoresizingMaskIntoConstraints = NO;
        [sto.titleLabel setFont:[UIFont MaterialDesignIconsWithSize:24]];
        [sto setTitle:[UIFont mdiSettings] forState:UIControlStateNormal];
        [sto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sto setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
        [self.contentView addSubview:sto];
        [sto.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
        [sto.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        [sto.widthAnchor constraintEqualToConstant:56.0].active = YES;
        [sto.heightAnchor constraintEqualToConstant:56.0].active = YES;
        sto;
    });
    
    self.toggle = ({
        GoogleToggle *tog = [[GoogleToggle alloc] init];
        [self.contentView addSubview:tog];
        [tog.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-56].active = YES;
        [tog.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-16].active = YES;
        tog;
    });
    
}

@end
