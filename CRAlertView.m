//
//  CRAlertView.m
//  CRNote
//
//  Created by caine on 12/31/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRAlertView.h"

@interface CRAlertView()

@end

@implementation CRAlertView

- (instancetype)init{
    self = [super initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    
    [self initClass:UIBlurEffectStyleDark];
    
    return self;
}

- (void)initClass:(UIBlurEffectStyle)style{
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

@end
