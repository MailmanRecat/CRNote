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
    self.notetitle = ({
        label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.textColor = [UIColor whiteColor];
        label.font = [CRNoteApp appFontOfSize:17 weight:UIFontWeightMedium];
        label;
    });
    self.subtitle = ({
        label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.textColor = [UIColor whiteColor];
        label.font = [CRNoteApp appFontOfSize:14 weight:UIFontWeightRegular];
        label;
    });
    
    [self.contentView addSubview:self.wrapper];
    [self.wrapper addSubview:self.notetitle];
    [self.wrapper addSubview:self.subtitle];
    
    self.wrapper.layer.shouldRasterize = YES;
    self.wrapper.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)makeLayout{
    [CRLayout view:@[ self.wrapper, self.contentView ] type:CREdgeAround edge:UIEdgeInsetsMake(8, 16, -8, -16)];
    [CRLayout view:@[ self.notetitle, self.wrapper ] type:CREdgeTop | CREdgeLeft | CREdgeRight edge:UIEdgeInsetsMake(8, 8, 8, 8)];
    [CRLayout view:@[ self.subtitle, self.wrapper ] type:CREdgeLeft | CREdgeRight edge:UIEdgeInsetsMake(0, 8, 0, -8)];
    [self.notetitle.heightAnchor constraintEqualToConstant:20].active = YES;
    [self.subtitle.topAnchor constraintEqualToAnchor:self.notetitle.bottomAnchor].active = YES;
    [self.subtitle.bottomAnchor constraintEqualToAnchor:self.wrapper.bottomAnchor].active = YES;
}

@end
