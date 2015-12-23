//
//  CRNoteCurrent.m
//  CRNote
//
//  Created by caine on 12/23/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRNoteCurrent.h"

@implementation CRNoteCurrent

+ (NSArray *)allCRNoteWithFormat:(BOOL)format{
    if( format )
        return [CRNoteDatabase selectFormatNoteFromAll];
    else
        return [CRNoteDatabase selectNoteFromAll];
}

@end
