//
//  CRLayout.h
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, CRLayoutType){
    CREdgeTop = 1 << 0,
    CREdgeRight = 1 << 1,
    CREdgeBottom = 1 << 2,
    CREdgeLeft = 1 << 3,
    
    CREdgeAround = 1 << 4,
    
    CRCenterX = 1 << 5,
    CRCenterY = 1 << 6,
};

@interface CRLayout : NSObject

+ (void)view:(NSArray<UIView *> *)views type:(CRLayoutType)type;

+ (void)view:(NSArray<UIView *> *)views
        type:(CRLayoutType)type
        edge:(UIEdgeInsets)edge;

+ (void)view:(NSArray<UIView *> *)views
        type:(CRLayoutType)type
       point:(CGPoint)point;

@end
