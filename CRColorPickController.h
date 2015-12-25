//
//  CRColorPickController.h
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRBasicViewController.h"

@interface CRColorPickController : CRBasicViewController

@property( nonatomic, strong ) NSDictionary *colors;
@property( nonatomic, strong ) NSString *currentColorString;

@property( nonatomic, strong ) UIColor *selectedColor;
@property( nonatomic, strong ) NSString *selectedColorname;

@property( nonatomic, strong ) void(^colorSelectedHandler)(UIColor *, NSString *);

@end
