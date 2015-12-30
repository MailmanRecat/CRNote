//
//  CRAdBoard.m
//  CRNote
//
//  Created by caine on 12/30/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRAdBoard.h"
#import "CRNoteApp.h"

@interface CRAdBoard()

@property( nonatomic, strong ) NSLayoutConstraint *wallLayoutGuide;

@property( nonatomic, strong ) UIImageView *photoWall;
@property( nonatomic, strong ) UILabel *message;

@end

@implementation CRAdBoard

- (instancetype)init{
    self = [super init];
    if( self ){
        [self initClass];
    }
    return self;
}

- (void)initClass{
    self.photoWall = ({
        UIImageView *wall = [[UIImageView alloc] init];
        wall.translatesAutoresizingMaskIntoConstraints = NO;
        wall.contentMode = UIViewContentModeScaleAspectFit;
        wall.image = [UIImage imageNamed:@"crnoteiconopacity.png"];
        [self addSubview:wall];
        [wall.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.618].active = YES;
        [wall.heightAnchor constraintEqualToAnchor:wall.widthAnchor].active = YES;
        [wall.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        self.wallLayoutGuide = [wall.centerYAnchor constraintEqualToAnchor:self.topAnchor];
        self.wallLayoutGuide.active = YES;
        wall;
    });
    
    self.message = ({
        UILabel *msg = [[UILabel alloc] init];
        msg.translatesAutoresizingMaskIntoConstraints = NO;
        msg.adjustsFontSizeToFitWidth = YES;
        msg.text = @"Notes you add appear here";
        msg.textColor = [UIColor colorWithWhite:117 / 255.0 alpha:1];
        msg.textAlignment = NSTextAlignmentCenter;
        msg.font = [CRNoteApp appFontOfSize:20 weight:UIFontWeightRegular];
        [self addSubview:msg];
        [msg.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:-32].active = YES;
        [msg.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [msg.topAnchor constraintEqualToAnchor:self.photoWall.bottomAnchor].active = YES;
        [msg.heightAnchor constraintEqualToConstant:56.0].active = YES;
        msg;
    });
}

- (void)layoutSubviews{
    self.wallLayoutGuide.constant = self.frame.size.height * 0.382;
    
    [self.photoWall layoutIfNeeded];
}

@end
