//
//  CRPhotoPreviewController.h
//  CRNote
//
//  Created by caine on 12/22/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRBasicViewController.h"

@interface CRPhotoPreviewController : CRBasicViewController

@property( nonatomic, strong ) void(^photoDeletedHandler)(void);

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

@end
