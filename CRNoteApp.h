//
//  CRNoteApp.h
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+CRTheme.h"

@interface CRNoteApp : NSObject

+ (UIFont *)appFontOfSize:(CGFloat)size;
+ (UIFont *)appFontOfSize:(CGFloat)size weight:(CGFloat)weight;

@end
