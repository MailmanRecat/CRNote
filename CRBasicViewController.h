//
//  CRBasicViewController.h
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#import <UIKit/UIKit.h>
#import "UIView+CRView.h"
#import "UIColor+CRTheme.h"
#import "CRNoteApp.h"
#import "CRNote.h"
#import "UIFont+MaterialDesignIcons.h"

@interface CRBasicViewController : UIViewController

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UIButton *dismissButton;
@property( nonatomic, strong ) UIColor *themeColor;

- (instancetype)initWithTitle:(NSString *)title;
- (void)dismissSelf;

@end
