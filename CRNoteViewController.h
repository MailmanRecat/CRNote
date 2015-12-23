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

- (instancetype)initFromCRNote:(CRNote *)note themeColor:(UIColor *)themeColor;

- (void)updateThemeColor:(UIColor *)color string:(NSString *)string;
- (void)updateNoteFont:(NSString *)name size:(NSUInteger)size;
- (void)updateNoteCoverCanceled:(BOOL)canceled;
- (void)previewNoteCover:(NSData *)imageData;

- (void)parkSunset;
- (void)parkSunrise;

@end
