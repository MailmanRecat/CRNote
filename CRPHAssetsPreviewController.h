//
//  CRPHAssetsPreviewController.h
//  CRNote
//
//  Created by caine on 12/22/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRBasicViewController.h"

@interface CRPHAssetsPreviewController : CRBasicViewController

@property( nonatomic, strong ) UIImage *crimage;

- (instancetype)initWithImage:(UIImage *)image;

@end
