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

@property( nonatomic, strong ) CALayer *borderTop;
@property( nonatomic, strong ) CALayer *borderBottom;

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
        dot.font = [UIFont MaterialDesignIconsWithSize:28];
        dot.text = [UIFont mdiCheckboxBlankCircleOutline];
        dot.textAlignment = NSTextAlignmentCenter;
        dot;
    });
    
    self.borderTop = [CALayer layer];
    self.borderBottom = [CALayer layer];
    
    self.borderTop.backgroundColor = self.borderBottom.backgroundColor = [UIColor colorWithWhite:89 / 255.0 alpha:1].CGColor;
    
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.crimagev];
    [self.contentView addSubview:self.dot];
    
    [self.contentView.layer addSublayer:self.borderTop];
    [self.contentView.layer addSublayer:self.borderBottom];
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

- (void)layoutSubviews{
    CGRect frame = self.frame;
    
    self.borderTop.frame = CGRectMake(0, 0, frame.size.width, 2);
    self.borderBottom.frame = CGRectMake(0, frame.size.height - 2, frame.size.width, 2);
}

- (void)setChecked:(BOOL)checked{
    if( _checked == checked ) return;
    
    _checked = checked;
    if( checked )
        self.dot.text = [UIFont mdiCheckboxMarkedCircle];
    else
        self.dot.text = [UIFont mdiCheckboxBlankCircleOutline];
}

@end
