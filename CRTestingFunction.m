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
#import "CRNoteDebug.h"
#import "CRNoteDatabase.h"
#import "CRMutableQueue.h"
#import "CRPhotoManager.h"

@implementation CRTestingFunction

+ (void)runTest{
    
    if( [CRNoteDebug isDebug] == NO ) return;
    
    [CRNoteDatabase runTest];
    [CRPhotoManager runTest];
//    [CRNoteDatabase removeAllNote:YES];
    
    NSLog(@"path exists: %d", [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Documents/CRNotePhotos", NSHomeDirectory()]]);
    
    NSDirectoryEnumerator *enmu = [[NSFileManager defaultManager] enumeratorAtPath:[NSString stringWithFormat:@"%@/Documents/CRNotePhotos/", NSHomeDirectory()]];
    
    NSDirectoryEnumerator *enmi = [[NSFileManager defaultManager] enumeratorAtPath:[NSString stringWithFormat:@"%@/Documents/CRNoteThumbnails/", NSHomeDirectory()]];
    
    NSMutableString *mutableString = [[NSMutableString alloc] initWithFormat:@" \n "];
    NSString *path, *patc;
    NSLog(@"saved photos %@ %@", enmu, enmi);
    while( (path = [enmu nextObject]) != nil || (patc = [enmi nextObject]) != nil ){
//        NSLog(@"%@", path);
//        NSLog(@"%@", patc);
        [mutableString appendString:[NSString stringWithFormat:@"p: %@   t: %@\n ", path, patc]];
    }
    
//    NSLog(@"%@", mutableString);
}

@end
