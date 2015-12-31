//
//  CRAlertView.h
//  CRNote
//
//  Created by caine on 12/31/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRAlertView : UIVisualEffectView

@property( nonatomic, strong ) UILabel *title;
@property( nonatomic, strong ) UILabel *content;
@property( nonatomic, strong ) UIButton *leftButton;
@property( nonatomic, strong ) UIButton *rightButton;

@end
