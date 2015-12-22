//
//  CRPHAssetsCell.m
//  CRNote
//
//  Created by caine on 12/22/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRPHAssetsCell.h"
#import "UIFont+MaterialDesignIcons.h"

@interface CRPHAssetsCell()

@end

@implementation CRPHAssetsCell

- (instancetype)init{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CR_PH_ASSETS_CELL_ID];
    if( self ){
        [self initClass];
        [self makeLayout];
    }
    return self;
}

- (void)initClass{
    self.crimagev = ({
        UIImageView *imv = [[UIImageView alloc] init];
        imv.translatesAutoresizingMaskIntoConstraints = NO;
        imv.contentMode = UIViewContentModeScaleAspectFill;
        imv;
    });
    self.dot = ({
        UILabel *dot = [[UILabel alloc] init];
        dot.translatesAutoresizingMaskIntoConstraints = NO;
        dot.font = [UIFont MaterialDesignIconsWithSize:24];
        dot.text = [UIFont mdiCheckboxBlankCircleOutline];
        dot.textAlignment = NSTextAlignmentCenter;
        dot;
    });
    
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.crimagev];
    [self.contentView addSubview:self.dot];
}

- (void)makeLayout{
    [self.crimagev.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.crimagev.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
    [self.crimagev.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [self.crimagev.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
    
    [self.dot.widthAnchor constraintEqualToConstant:40].active = YES;
    [self.dot.heightAnchor constraintEqualToConstant:40].active = YES;
    [self.dot.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
    [self.dot.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
}

- (void)statusON{
    self.dot.text = [UIFont mdiCheckboxMarkedCircle];
}

- (void)statusOFF{
    self.dot.text = [UIFont mdiCheckboxBlankCircleOutline];
}

@end
