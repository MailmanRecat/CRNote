//
//  CRNoteCurrent.h
//  CRNote
//
//  Created by caine on 12/23/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRNoteDatabase.h"

@interface CRNoteCurrent : NSObject

+ (nullable NSArray *)allCRNoteWithFormat:(BOOL)format;

@end
