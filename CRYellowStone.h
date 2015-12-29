//
//  CRYellowStone.h
//  CRNote
//
//  Created by caine on 12/29/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define CR_YELLOW_STONE_HEIGHT 56

#import <UIKit/UIKit.h>

@interface CRYellowStone : UIView

@property( nonatomic, strong ) UILabel *nameplate;
@property( nonatomic, strong ) UIButton *stone;

@end
