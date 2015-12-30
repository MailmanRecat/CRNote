//
//  CRBtnNotification.m
//  CRNote
//
//  Created by caine on 12/30/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRBtnNotification.h"
#import "CRNoteApp.h"

@interface CRBtnNotification()

@property( nonatomic, strong ) UILabel *content;

@end

@implementation CRBtnNotification

- (instancetype)init{
    self = [super init];
    if( self ){
        [self initClass];
    }
    return self;
}

- (void)setNotification:(NSString *)notification{
    _notification = notification;
    self.content.text = notification;
}

- (void)initClass{
    self.backgroundColor = [UIColor colorWithWhite:50 / 255.0 alpha:1];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.heightAnchor constraintEqualToConstant:52].active = YES;
    
    self.content = ({
        UILabel *l = [[UILabel alloc] init];
        l.translatesAutoresizingMaskIntoConstraints = NO;
        l.font = [CRNoteApp appFontOfSize:17 weight:UIFontWeightMedium];
        l.textColor = [UIColor colorWithWhite:237 / 255.0 alpha:1];
        [self addSubview:l];
        [l.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:16].active = YES;
        [l.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-16].active = YES;
        [l.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [l.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        l;
    });
}

@end
