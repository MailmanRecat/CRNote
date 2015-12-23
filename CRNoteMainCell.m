//
//  CRNoteMainCell.m
//  CRNote
//
//  Created by caine on 12/21/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRNoteMainCell.h"
#import "UIView+CRView.h"
#import "CRNoteApp.h"

@interface CRNoteMainCell()
@end

@implementation CRNoteMainCell

- (instancetype)initWithColorString:(NSString *)colorString{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:colorString];
    if( self ){
        [self initClass];
        [self makeLayout];
        
        self.wrapper.backgroundColor = [UIColor themeColorFromString:colorString];
        self.timeTag.textColor = self.wrapper.backgroundColor;
    }
    return self;
}

- (instancetype)initWithType:(NSString *)type{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:type];
    if( self ){
        [self initClass];
        
        if( type == CR_NOTE_IMAGE_CELL_REUSE_ID ){
            self.crimageview = ({
                UIImageView *iv = [[UIImageView alloc] init];
                iv.translatesAutoresizingMaskIntoConstraints = NO;
                iv.contentMode = UIViewContentModeScaleAspectFill;
                iv.layer.cornerRadius = 3.0f;
                iv.clipsToBounds = YES;
                iv;
            });
            
            [self.wrapper insertSubview:self.crimageview atIndex:0];
        }
        
        [self makeLayout];
    }
    return self;
}

- (void)initClass{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    
    [self.contentView addSubview:self.wrapper];
    [self.wrapper addSubview:self.timeTag];
    [self.wrapper addSubview:self.notetitle];
    [self.wrapper addSubview:self.subtitle];
    
    self.wrapper.layer.shouldRasterize = YES;
    self.wrapper.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)makeLayout{
    CGFloat classNameHeight = 20;
    
    [self.timeTag.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8].active = YES;
    [self.timeTag.heightAnchor constraintEqualToConstant:32].active = YES;
    [self.timeTag.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16].active = YES;
    [self.timeTag.widthAnchor constraintEqualToConstant:64].active = YES;
    [self.timeTag.rightAnchor constraintEqualToAnchor:self.wrapper.leftAnchor constant:-8].active = YES;
    [self.wrapper.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8].active = YES;
    [self.wrapper.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8].active = YES;
    [self.wrapper.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-16].active = YES;
    [self.notetitle.heightAnchor constraintEqualToConstant:classNameHeight].active = YES;
    [self.notetitle.bottomAnchor constraintEqualToAnchor:self.subtitle.topAnchor].active = YES;
    [self.subtitle.heightAnchor constraintEqualToConstant:classNameHeight].active = YES;
    
    [CRLayout view:@[ self.notetitle, self.wrapper ] type:CREdgeTop | CREdgeLeft | CREdgeRight edge:UIEdgeInsetsMake(8, 8, 0, -8)];
    [CRLayout view:@[ self.subtitle, self.wrapper ] type:CREdgeLeft | CREdgeRight edge:UIEdgeInsetsMake(0, 8, 0, -8)];
    
    if( self.crimageview ){
        [CRLayout view:@[ self.crimageview, self.wrapper ] type:CREdgeLeft | CREdgeRight | CREdgeTop | CREdgeBottom];
    }
}

@end
