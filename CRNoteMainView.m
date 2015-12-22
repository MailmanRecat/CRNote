//
//  CRNoteMainView.m
//  CRNote
//
//  Created by caine on 12/22/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRNoteMainView.h"
#import "UIView+CRView.h"
#import "CRNoteApp.h"

@interface CRNoteMainView()



@end

@implementation CRNoteMainView

- (instancetype)init{
    self = [super init];
    if( self ){
        [self initClass];
        [self makeLayout];
    }
    return self;
}

- (void)initClass{
    UILabel *label;
    self.wrapper = ({
        UIView *wrapper = [[UIView alloc] init];
        wrapper.translatesAutoresizingMaskIntoConstraints = NO;
        wrapper.layer.cornerRadius = 3.0f;
        wrapper;
    });
    self.timeTag = ({
        label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.font = [CRNoteApp appFontOfSize:21 weight:UIFontWeightMedium];
        label;
    });
    self.notetitle = ({
        label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [CRNoteApp appFontOfSize:17 weight:UIFontWeightMedium];
        label;
    });
    self.subtitle = ({
        label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [CRNoteApp appFontOfSize:14 weight:UIFontWeightRegular];
        label;
    });
    
    self.crimageview = ({
        UIImageView *iv = [[UIImageView alloc] init];
        iv.translatesAutoresizingMaskIntoConstraints = NO;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.layer.cornerRadius = 3.0f;
        iv.clipsToBounds = YES;
        iv;
    });
    
    [self addSubview:self.wrapper];
    [self.wrapper addSubview:self.timeTag];
    [self.wrapper addSubview:self.notetitle];
    [self.wrapper addSubview:self.subtitle];
    [self.wrapper insertSubview:self.crimageview atIndex:0];
    
    self.wrapper.layer.shouldRasterize = YES;
    self.wrapper.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)makeLayout{
    CGFloat classNameHeight = 20;
    
    [self.timeTag.topAnchor constraintEqualToAnchor:self.topAnchor constant:10].active = YES;
    [self.timeTag.heightAnchor constraintEqualToConstant:32].active = YES;
    [self.timeTag.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:16].active = YES;
    [self.timeTag.widthAnchor constraintEqualToConstant:72].active = YES;
    [self.timeTag.rightAnchor constraintEqualToAnchor:self.wrapper.leftAnchor constant:-8].active = YES;
    [self.wrapper.topAnchor constraintEqualToAnchor:self.topAnchor constant:10].active = YES;
    [self.wrapper.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10].active = YES;
    [self.wrapper.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-16].active = YES;
    [self.notetitle.heightAnchor constraintEqualToConstant:classNameHeight].active = YES;
    [self.notetitle.bottomAnchor constraintEqualToAnchor:self.subtitle.topAnchor].active = YES;
    [self.subtitle.heightAnchor constraintEqualToConstant:classNameHeight].active = YES;
    
    [CRLayout view:@[ self.notetitle, self.wrapper ] type:CREdgeTop | CREdgeLeft | CREdgeRight edge:UIEdgeInsetsMake(8, 8, 0, -8)];
    [CRLayout view:@[ self.subtitle, self.wrapper ] type:CREdgeLeft | CREdgeRight edge:UIEdgeInsetsMake(0, 8, 0, -8)];
    
    if( self.crimageview ){
        [CRLayout view:@[ self.crimageview, self.wrapper ] type:CREdgeAround];
    }
}

@end
