//
//  CRVisualYosemite.h
//  CRNote
//
//  Created by caine on 12/30/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRVisualYosemite : UIVisualEffectView

@property( nonatomic, strong ) UIButton *dismissBtn;

@property( nonatomic, strong ) UIImage *image;
@property( nonatomic, strong ) UILabel *nameplate;
@property( nonatomic, assign ) CGFloat  contentOpacity;

- (instancetype)initFromEffectStyle:(UIBlurEffectStyle)style;

@end
