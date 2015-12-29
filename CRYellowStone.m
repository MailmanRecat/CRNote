//
//  CRYellowStone.m
//  CRNote
//
//  Created by caine on 12/29/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRYellowStone.h"

@interface CRYellowStone()

@end

@implementation CRYellowStone

- (instancetype)init{
    self = [super init];
    [self initClass];
    return self;
}

- (void)initClass{
    self.nameplate = ({
        UILabel *plate = [[UILabel alloc] init];
        plate.translatesAutoresizingMaskIntoConstraints = NO;
        plate.text = @"Notes";
        [self addSubview:plate];
        [plate.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:16].active = YES;
        plate;
    });
}

@end
