//
//  CRVisualFloatingButton.h
//  CRNote
//
//  Created by caine on 12/30/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRVisualFloatingButton : UIControl

@property( nonatomic, strong ) NSString *title;

- (instancetype)initFromFont:(UIFont *)font title:(NSString *)title blurEffectStyle:(UIBlurEffectStyle)effectStyle;

@end
