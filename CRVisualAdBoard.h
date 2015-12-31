//
//  CRVisualAdBoard.h
//  CRNote
//
//  Created by caine on 12/31/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRVisualAdBoard : UIVisualEffectView

@property( nonatomic, strong ) UILabel *message;

- (instancetype)initFromEffectStyle:(UIBlurEffectStyle)style;

@end
