//
//  CRInfoTableviewCell.m
//  CRClassSchedule
//
//  Created by caine on 12/17/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRInfoTableviewCell.h"
#import "CRNoteApp.h"

@interface CRInfoTableviewCell()

@property( nonatomic, strong ) UIView *border;

@end

@implementation CRInfoTableviewCell

- (instancetype)init{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRInfoTableViewCellID];
    if( self ){
        
        UILabel *label;
        self.subLabel = ({
            label = [UILabel new];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.textColor = [UIColor colorWithWhite:117 / 255.0 alpha:1];
            label.font = [CRNoteApp appFontOfSize:15 weight:UIFontWeightRegular];
            label;
        });
        
        self.maiLabel = ({
            label = [UILabel new];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.adjustsFontSizeToFitWidth = YES;
            label.textColor = [UIColor colorWithWhite:59 / 255.0 alpha:1];
            label.font = [CRNoteApp appFontOfSize:19 weight:UIFontWeightRegular];
            label;
        });
        
        [self.contentView addSubview:self.subLabel];
        [self.contentView addSubview:self.maiLabel];
        [self layoutClass];
        
        UIView *borderBottom = [UIView new];
        borderBottom.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:borderBottom];
        borderBottom.hidden = YES;
        borderBottom.backgroundColor = [UIColor colorWithWhite:200 / 255.0 alpha:1];
        
        [borderBottom.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor].active = YES;
        [borderBottom.heightAnchor constraintEqualToConstant:1].active = YES;
        [borderBottom.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        [borderBottom.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
        
        self.border = borderBottom;
    }
    return self;
}

- (void)layoutClass{
    [self.subLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8].active = YES;
    [self.subLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:32].active = YES;
    [self.subLabel.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-16].active = YES;
    [self.subLabel.heightAnchor constraintEqualToConstant:20].active = YES;
    
    [self.maiLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:28].active = YES;
    [self.maiLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:32].active = YES;
    [self.maiLabel.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-16].active = YES;
    [self.maiLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8].active = YES;
}

- (void)makeBorder:(BOOL)hidden{
    self.border.hidden = !hidden;
}

@end
