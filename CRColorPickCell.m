//
//  CRColorPickCell.m
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRColorPickCell.h"
#import "UIFont+MaterialDesignIcons.h"

@implementation CRColorPickCell

- (instancetype)init{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRColorPickCellID];
    if( self ){
        UILabel *label;
        self.dotname = ({
            label = [[UILabel alloc] init];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label;
        });
        
        self.dot = ({
            label = [[UILabel alloc] init];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.font = [UIFont MaterialDesignIconsWithSize:24];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [UIFont mdiCheckboxBlankCircleOutline];
            label;
        });
        
        [self.contentView addSubview:self.dot];
        [self.contentView addSubview:self.dotname];
        [self makeLayout];
    }
    return self;
}

- (void)makeLayout{
    [self.dot.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.dot.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
    [self.dot.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [self.dot.widthAnchor constraintEqualToConstant:64].active = YES;
    
    [self.dotname.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.dotname.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
    [self.dotname.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [self.dotname.leftAnchor constraintEqualToAnchor:self.dot.rightAnchor].active = YES;
}

- (void)statusON{
    self.dot.text = [UIFont mdiCheckboxBlankCircle];
}

- (void)statusOFF{
    self.dot.text = [UIFont mdiCheckboxBlankCircleOutline];
}

@end
