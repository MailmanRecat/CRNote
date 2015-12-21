//
//  GGAnimationSunrise.m
//  MOREAmazing
//
//  Created by caine on 11/16/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "GGAnimationSunrise.h"

@interface GGAnimationSunrise()

@property( nonatomic, strong ) MOREQueue *animationQueue;
@property( nonatomic, assign ) GGAnimationSunriseType type;

@property( nonatomic, assign ) BOOL fucking;
@property( nonatomic, assign ) NSUInteger times;

@end

@implementation GGAnimationSunrise

- (instancetype)init{
    self = [super init];
    if( self ){
        
        _fucking = NO;
        _times = 0;
        _animationSunriseOffset = 0;
        _duration = 1.0f;
        _fromOpacity = 1;
        _toOpacity = 1;
        _timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        _animationQueue = [MOREQueue new];
        _type = GGAnimationSunriseTypeConcurrent;
    }
    return self;
}

- (instancetype)initWithType:(GGAnimationSunriseType)type blockOnCompletion:(blockOnCompletion)completion{
    self = [self init];
    if( self ){
        _type = type;
        _onCompletion = completion;
    }
    return self;
}

- (void)sunriseAtLand:(UIView *)land location:(CGPoint)location lightColor:(UIColor *)lightColor{
    
    CGRect rect = land.frame;
    CGRect frame = CGRectMake(location.x, location.y, rect.size.width, rect.size.height);
    
    CAShapeLayer *sun = [self sunWithFrame:frame];
    sun.backgroundColor = [UIColor clearColor].CGColor;
    sun.fillColor = lightColor.CGColor;
    sun.opacity = _fromOpacity;
    
    land.layer.masksToBounds = YES;
    
    CGFloat width = 1.0 / sun.frame.size.width;
    CAAnimationGroup *light = [self gettingDaylight:width];
    sun.transform = [((CABasicAnimation *)[light animations][0]).toValue CATransform3DValue];
    
    [land.layer insertSublayer:sun atIndex:(int)_times];
    if( _type == GGAnimationSunriseTypeConcurrent ){
        
        _times++;
        [self doConcurrentFuckWithLayer:sun animation:light];
    }else if( _type == GGAnimationSunriseTypeSerial ){
        
        _times++;
        NSArray *obj = @[ sun, light ];
        [_animationQueue addObj:obj];
        
        if( _fucking ) return;
        [self doSerialFuck:[_animationQueue popObj]];
    }
}

- (void)doConcurrentFuckWithLayer:(CAShapeLayer *)sun animation:(CAAnimationGroup *)animation{
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if( _onCompletion ) _onCompletion(GGAnimationSunriseTypeConcurrent);
        _times--;
        [sun removeFromSuperlayer];
    }];
    [sun addAnimation:animation forKey:@"GGAnimation.sunrise.transaction.concurrent"];
    [CATransaction commit];
}

- (void)doSerialFuck:(NSArray *)obj{
    _fucking = YES;

    CAShapeLayer *sun = (CAShapeLayer *)obj[0];
    CAAnimationGroup *light = (CAAnimationGroup *)obj[1];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{

        _times--;
        [sun removeFromSuperlayer];
        
        NSArray *nex = [_animationQueue popObj];
        nex ? [self doSerialFuck:nex] : ( _fucking = NO );
        
        if( _onCompletion ) _onCompletion(GGAnimationSunriseTypeSerial);
    }];
    [sun addAnimation:light forKey:@"CGAnimation.sunrise.transaction.serial"];
    [CATransaction commit];
}

- (CAAnimationGroup *)gettingDaylight:(CGFloat)lightSize{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.timingFunction = _timingFunction;
    group.duration = _duration;
    
    CABasicAnimation *brightness = [CABasicAnimation animationWithKeyPath:@"opacity"];
    brightness.fromValue = [NSNumber numberWithFloat:_fromOpacity];
    brightness.toValue   = [NSNumber numberWithFloat:_toOpacity];
    brightness.removedOnCompletion = YES;
    
    CABasicAnimation *light = [CABasicAnimation animationWithKeyPath:@"transform"];
    light.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(lightSize, lightSize, 1.0)];
    light.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    light.removedOnCompletion = YES;
    
    group.animations = @[ light, brightness ];
    
    return group;
}

- (CGFloat)diameterWithRect:(CGRect)rect{
    CGPoint lightEdge[] = {
        { 0, 0 },
        { 0, rect.size.height },
        { rect.size.width, 0 },
        { rect.size.width, rect.size.height }
    };
    CGFloat radius = 0; int turtel;
    CGPoint edge;
    CGFloat dist;
    for( turtel = 0 ; turtel < 4; turtel++ ){
        edge = lightEdge[ turtel ];
        dist = sqrt(pow( rect.origin.x - edge.x, 2.0 ) + pow( rect.origin.y - edge.y, 2.0 ));
        radius = dist > radius ? dist : radius;
    }
    
    return radius * 2 + _animationSunriseOffset;
}

- (CAShapeLayer *)sunWithFrame:(CGRect)frame{
    CAShapeLayer *sun = [CAShapeLayer layer];
    CGFloat      diameter = [self diameterWithRect:frame];
    
    sun.frame = CGRectMake(floor( frame.origin.x - diameter * 0.5 ), floor( frame.origin.y - diameter * 0.5 ), diameter, diameter);
    sun.path  = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, diameter, diameter)].CGPath;
    
    return sun;
}

@end
