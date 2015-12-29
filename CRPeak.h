//
//  CRPeak.h
//  CRNote
//
//  Created by caine on 12/29/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define CR_PEAK_BUTTON_BASIC_TAG 1007
#define CR_PEAK_HEIGHT 52

#import <UIKit/UIKit.h>

@interface CRPeak : UIView

@property( nonatomic, strong ) UIButton *remove;
@property( nonatomic, strong ) UIButton *lock;
@property( nonatomic, strong ) UIButton *font;
@property( nonatomic, strong ) UIButton *photo;
@property( nonatomic, strong ) UIButton *palette;
@property( nonatomic, strong ) UIButton *save;
@property( nonatomic, strong ) UIButton *paste;
@property( nonatomic, strong ) UIButton *copying;
@property( nonatomic, strong ) UIButton *keyboard;
@property( nonatomic, strong ) UIButton *message;

@property( nonatomic, strong ) NSString *notification;
@property( nonatomic, assign ) BOOL      enbleSubbtn;

- (NSArray<UIButton *> *)btns;

@end
