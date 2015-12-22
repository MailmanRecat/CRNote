//
//  CRPhotoPreviewController.h
//  CRNote
//
//  Created by caine on 12/22/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRBasicViewController.h"

static NSString *const CRPhotoPreviewDidDeleteNotification = @"CR_PHOTO_PREVIEW_DID_DELETE_NOTIFICATION";

@interface CRPhotoPreviewController : CRBasicViewController

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

@end
