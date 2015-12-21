//
//  CRNoteApp.m
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRNoteApp.h"

@implementation CRNoteApp

+ (UIFont *)appFontOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"Roboto-Light" size:size];
}

+ (UIFont *)appFontOfSize:(CGFloat)size weight:(CGFloat)weight{
    
    NSString *name;
    if( weight == UIFontWeightBlack )
        name = @"Roboto-Black";
    else if( weight == UIFontWeightHeavy || weight == UIFontWeightBold || weight == UIFontWeightSemibold )
        name = @"Roboto-Bold";
    else if( weight == UIFontWeightRegular )
        name = @"Roboto-Regular";
    else if( weight == UIFontWeightMedium )
        name = @"Roboto-Medium";
    else if( weight == UIFontWeightLight )
        name = @"Roboto-Light";
    else if( weight == UIFontWeightThin || weight == UIFontWeightUltraLight )
        name = @"Roboto-Thin";
    else
        name = @"Roboto";
    
    return [UIFont fontWithName:name size:size];
}

@end
