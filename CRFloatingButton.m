//
//  CRFloatingButton.m
//  CRNote
//
//  Created by caine on 12/30/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRFloatingButton.h"
#import "UIView+CRView.h"

@implementation CRFloatingButton

- (instancetype)initFromFont:(UIFont *)font title:(NSString *)title{
    self = [super init];
    if( self ){
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self.widthAnchor constraintEqualToConstant:56].active = YES;
        [self.heightAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
        
        self.layer.cornerRadius = 56 / 2.0f;
        self.titleLabel.font = font;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
        [self makeShadowWithSize:CGSizeMake(0, 1.7) opacity:0.3f radius:1.7];
        [self.titleLabel makeShadowWithSize:CGSizeMake(0, 1) opacity:0.3 radius:0.3];
        
    }
    return self;
}

@end
