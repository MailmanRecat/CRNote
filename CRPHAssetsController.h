//
//  CRPHAssetsController.h
//  CRNote
//
//  Created by caine on 12/22/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

//#import <Photos/Photos.h>
#import "CRPhotoManager.h"
#import "CRBasicViewController.h"

@interface CRPHAssetsController : CRBasicViewController

@property( nonatomic, strong ) void(^PHPreviewHandler)(UIImage *preview);
@property( nonatomic, strong ) void(^PHPhotoHandler)(NSData *photo, NSData *humbnail, BOOL canceled);

@end
