//
//  CRPark.h
//  CRNote
//
//  Created by caine on 12/25/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRPark : UIView

@property( nonatomic, strong ) UIButton *dismissBtn;

@property( nonatomic, strong ) UIColor *color;
@property( nonatomic, strong ) UIImage *image;
@property( nonatomic, strong ) UILabel *nameplate;
@property( nonatomic, assign ) CGFloat  nameplateOpacity;

- (instancetype)initFromColor:(UIColor *)color;

@end
