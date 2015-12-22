//
//  CRNoteViewController.h
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRBasicViewController.h"

@interface CRNoteViewController : CRBasicViewController

@property( nonatomic, strong ) NSString *themeString;
@property( nonatomic, strong ) CRNote *crnote;

- (instancetype)initFromCRNote:(CRNote *)note themeColor:(UIColor *)themeColor;

- (void)updateThemeColor:(UIColor *)color string:(NSString *)string;
- (void)updateNoteFont:(NSString *)name size:(NSUInteger)size;
- (void)updateNoteCover:(nullable UIImage *)image path:(nullable NSString *)path;

- (void)parkSunset;
- (void)parkSunrise;

@end
