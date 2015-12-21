//
//  CRLayout.m
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRLayout.h"

@implementation CRLayout

+ (void)view:(NSArray<UIView *> *)views type:(CRLayoutType)type{
    
    if( type & CRCenterX || type & CRCenterY )
        [CRLayout view:views type:type point:CGPointMake(0, 0)];
    else
        [CRLayout view:views type:type edge:UIEdgeInsetsZero];
    
}

+ (void)view:(NSArray<UIView *> *)views type:(CRLayoutType)type point:(CGPoint)point{
    
    if( type & CRCenterX )
        [views[0].centerXAnchor constraintEqualToAnchor:views[1].centerXAnchor constant:point.x];
    
    if( type & CRCenterY )
        [views[0].centerYAnchor constraintEqualToAnchor:views[1].centerYAnchor constant:point.y];
    
}

+ (void)view:(NSArray<UIView *> *)views type:(CRLayoutType)type edge:(UIEdgeInsets)edge{
    
    if( type & CREdgeTop )
        [views[0].topAnchor constraintEqualToAnchor:views[1].topAnchor constant:edge.top].active = YES;
    
    if( type & CREdgeLeft )
        [views[0].leftAnchor constraintEqualToAnchor:views[1].leftAnchor constant:edge.left].active = YES;
    
    if( type & CREdgeBottom )
        [views[0].bottomAnchor constraintEqualToAnchor:views[1].bottomAnchor constant:edge.bottom].active = YES;
    
    if( type & CREdgeRight )
        [views[0].rightAnchor constraintEqualToAnchor:views[1].rightAnchor constant:edge.right].active = YES;
    
    if( type & CREdgeAround ){
        [views[0].topAnchor constraintEqualToAnchor:views[1].topAnchor constant:edge.top].active = YES;
        [views[0].leftAnchor constraintEqualToAnchor:views[1].leftAnchor constant:edge.left].active = YES;
        [views[0].bottomAnchor constraintEqualToAnchor:views[1].bottomAnchor constant:edge.bottom].active = YES;
        [views[0].rightAnchor constraintEqualToAnchor:views[1].rightAnchor constant:edge.right].active = YES;
    }
    
}

@end
