//
//  CRNoteDatabase.h
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRNote.h"

@interface CRNoteDatabase : NSObject

+ (NSArray *)selectNoteFromAll;
+ (NSArray *)selectFormatNoteFromAll;
+ (BOOL)insertNote:(CRNote *)note;
+ (BOOL)deleteNote:(CRNote *)note;
+ (BOOL)updateNote:(CRNote *)note;
+ (BOOL)removeAllNote:(BOOL)remove;

//+ (NSString *)pathFromPhotoname:(NSString *)name;
//+ (NSString *)pathFromThumbnail:(NSString *)name;
//+ (UIImage *)photoFromPhotoname:(NSString *)name;
//+ (UIImage *)photoFromThumbnail:(NSString *)name;

+ (void)runTest;

@end
