//
//  CRTestingFunction.m
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CRTestingFunction.h"
#import "CRNote.h"
#import "CRNoteDatabase.h"
#import "CRMutableQueue.h"

@implementation CRTestingFunction

+ (void)runTest{
    
    [CRNoteDatabase runTest];
//    [CRNoteDatabase removeAllNote:YES];
    
    NSDirectoryEnumerator *enmu = [[NSFileManager defaultManager] enumeratorAtPath:[NSString stringWithFormat:@"%@/Documents/CRNoteImages/", NSHomeDirectory()]];
    
    NSDirectoryEnumerator *enmi = [[NSFileManager defaultManager] enumeratorAtPath:[NSString stringWithFormat:@"%@/Documents/CRNoteThumbnailImages/", NSHomeDirectory()]];
    
    NSMutableString *mutableString = [[NSMutableString alloc] initWithFormat:@" \n "];
    NSString *path, *patc;
    while( (path = [enmu nextObject]) != nil || (patc = [enmi nextObject]) != nil ){
        NSLog(@"%@", path);
        NSLog(@"%@", patc);
        [mutableString appendString:[NSString stringWithFormat:@"p: %@   t: %@\n ", path, patc]];
    }
    
    NSLog(@"%@", mutableString);
}

@end
