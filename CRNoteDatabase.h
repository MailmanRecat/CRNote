//
//  CRNoteDatabase.h
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRNote.h"

@interface CRNoteDatabase : NSObject

+ (NSArray *)selectNoteFromAll;
+ (NSArray *)selectFormatNoteFromAll;
+ (BOOL)insertNote:(CRNote *)note;
+ (BOOL)deleteNote:(CRNote *)note;
+ (BOOL)updateNote:(CRNote *)note;
+ (BOOL)removeAllNote:(BOOL)remove;

+ (void)runTest;

@end
