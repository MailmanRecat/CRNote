//
//  CRNoteViewController.h
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRBasicViewController.h"

@protocol CRNotePreviewActionHandler <NSObject>

- (void)notePreviewAction:(NSString *)actionType fromController:(UIViewController *)controller;

@end

@interface CRNoteViewController : CRBasicViewController

@property( nonatomic, strong ) id<CRNotePreviewActionHandler> previewActionHandler;
@property( nonatomic, strong ) NSString *themeString;
@property( nonatomic, strong ) NSString *themeColorString;
@property( nonatomic, strong ) CRNote *crnote;
@property( nonatomic, assign ) BOOL isPreview;

@property( nonatomic, strong ) void(^crnoteDeleteActionHandler)(NSString *action);

- (instancetype)initFromCRNote:(CRNote *)note themeColor:(UIColor *)themeColor;

- (void)parkSunset;
- (void)parkSunrise;

@end
