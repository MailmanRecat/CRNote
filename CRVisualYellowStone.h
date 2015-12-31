//
//  CRVisualYellowStone.h
//  CRNote
//
//  Created by caine on 12/30/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleToggle.h"

@interface CRVisualYellowStone : UIVisualEffectView

@property( nonatomic, strong ) NSString *notification;
@property( nonatomic, assign ) BOOL     shadowEnable;
@property( nonatomic, strong ) UILabel *nameplate;
@property( nonatomic, strong ) UIButton *stone;
@property( nonatomic, strong ) UIButton *leftStone;
@property( nonatomic, strong ) GoogleToggle *toggle;

- (instancetype)initFromEffectStyle:(UIBlurEffectStyle)style;

@end
