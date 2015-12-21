//
//  GGAnimationSunrise.h
//  MOREAmazing
//
//  Created by caine on 11/16/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "GGAnimation.h"

typedef NS_ENUM(NSInteger, GGAnimationSunriseType){
    GGAnimationSunriseTypeSerial,
    GGAnimationSunriseTypeConcurrent
};

typedef void(^blockOnCompletion)(GGAnimationSunriseType);

@interface GGAnimationSunrise : GGAnimation

@property( nonatomic, assign ) CGFloat duration;
@property( nonatomic, assign ) CGFloat fromOpacity;
@property( nonatomic, assign ) CGFloat toOpacity;
@property( nonatomic, strong ) CAMediaTimingFunction *timingFunction;
@property( nonatomic, assign ) CGFloat animationSunriseOffset;
@property( nonatomic, strong ) blockOnCompletion onCompletion;

- (instancetype)initWithType:(GGAnimationSunriseType)type blockOnCompletion:(blockOnCompletion)completion;

- (void)sunriseAtLand:(UIView *)land
             location:(CGPoint)location
           lightColor:(UIColor *)lightColor;

@end
