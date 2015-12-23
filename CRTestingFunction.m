//
//  CRTestingFunction.m
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRTestingFunction.h"
#import "CRNote.h"
#import "CRNoteDatabase.h"

@implementation CRTestingFunction

+ (void)runTest{
    
    [CRNoteDatabase runTest];
    
//    NSLog(@"%d", [CRNoteDatabase removeAllNote:YES]);
    
    NSDirectoryEnumerator *enmu = [[NSFileManager defaultManager] enumeratorAtPath:[NSString stringWithFormat:@"%@/Documents/CRNoteImages/", NSHomeDirectory()]];
    
    NSString *path;
    while( (path = [enmu nextObject]) != nil ){
        
        NSLog(@"%@", path);
        
    }
}

@end
