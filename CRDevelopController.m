//
//  CRDevelopController.m
//  CRNote
//
//  Created by caine on 12/23/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRDevelopController.h"
#import "CRNoteDatabase.h"
#import "CRPhotoManager.h"

@interface CRDevelopController()

@property( nonatomic, strong ) UITextView *textView;

@end

@implementation CRDevelopController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20 + 56)];
    [dismiss addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    dismiss.backgroundColor = [UIColor randomColor];
    [self.view addSubview:dismiss];
    
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(0, 76, self.view.frame.size.width, self.view.frame.size.height - 76 - 56)];
    text.backgroundColor = [UIColor blackColor];
    text.textColor = [UIColor whiteColor];
    text.editable = NO;
    [self.view addSubview:text];
    
    self.textView = text;
    
    [self loadImageNUmber];
    
    UIButton *remove = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 56, self.view.frame.size.width, 56)];
    remove.backgroundColor = [UIColor randomColor];
    [remove addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:remove];
}

- (void)loadImageNUmber{
    
    NSString *basePath = [NSString stringWithFormat:@"%@/Documents/CRNotePhotos/", NSHomeDirectory()];
    NSString *basethum = [NSString stringWithFormat:@"%@/Documents/CRNoteThumbnails/", NSHomeDirectory()];
    
    NSString *testPath = [NSString stringWithFormat:@"%@/Documents/testFile", NSHomeDirectory()];
    
//    BOOL *isDir;
//    if( ![[NSFileManager defaultManager] fileExistsAtPath:testPath isDirectory:isDir] || !isDir ){
//        [[NSFileManager defaultManager] createDirectoryAtPath:testPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
    
    NSDirectoryEnumerator *enmu = [[NSFileManager defaultManager] enumeratorAtPath:basePath];
    NSDirectoryEnumerator *thum = [[NSFileManager defaultManager] enumeratorAtPath:basethum];
    
    NSString *once;
    __block NSMutableString *path = [[NSMutableString alloc] initWithString:@" "];
    
    NSArray *notedata = [CRNoteDatabase selectNoteFromAll];
    BOOL save = [notedata writeToFile:[NSString stringWithFormat:@"%@/notedata.txt", testPath] atomically:YES];
    CGFloat len = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/notedata.txt", testPath]].length / 1024.0;
//    NSLog(@"save array %d %.2lf KB", save, len);
    
    [path appendString:[NSString stringWithFormat:@"%.2lf KB", len]];
    [path appendFormat:@"\n "];
    [path appendFormat:@"\n "];
    
    NSUInteger counter = 0;
    while( (once = [enmu nextObject]) != nil ){
        counter++;
        [path appendFormat:@"%@", once];
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:[NSString stringWithFormat:@"%@%@", basePath, once]];
        
        CGFloat len = data.length / 1024 / 1024.0;
        
        [path appendFormat:@"   %.3f MB \n ", len];
    }
    
    [path appendFormat:@"%ld \n ", counter];
    [path appendFormat:@"\n "];
    
    NSString *thumS;
    counter = 0;
    while( (thumS = [thum nextObject]) != nil ){
        counter++;
        [path appendFormat:@"%@", thumS];
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:[NSString stringWithFormat:@"%@%@", basethum, thumS]];
        
        CGFloat len = data.length / 1024.0;
        
        [path appendFormat:@"   %.1f KB \n ", len];
    }
    
    [path appendFormat:@"%ld \n ", counter];
    [path appendFormat:@"\n "];
    
    [[CRPhotoManager defaultManager].photoCache enumerateKeysAndObjectsUsingBlock:^(NSString *key, UIImage *obj, BOOL *sS){
        [path appendFormat:@"%@ %@\n ", key, obj];
    }];
    
    [path appendFormat:@"%ld \n ", [[CRPhotoManager defaultManager].photoCache count]];
    [path appendFormat:@"\n "];
    
    [[CRPhotoManager defaultManager].thumbnailCache enumerateKeysAndObjectsUsingBlock:^(NSString *key, UIImage *obj, BOOL *sS){
        [path appendFormat:@"%@ %@\n ", key, obj];
    }];
    
    [path appendFormat:@"%ld \n ", [[CRPhotoManager defaultManager].thumbnailCache count]];
    [path appendFormat:@"\n "];
    
    NSArray *notes = [CRNoteDatabase selectNoteFromAll];
    [path appendFormat:@"%@\n", notes];
    
    self.textView.text = path;
}

- (void)remove{
    [CRNoteDatabase removeAllNote:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
