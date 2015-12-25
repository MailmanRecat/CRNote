//
//  CRDevelopController.m
//  CRNote
//
//  Created by caine on 12/23/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRDevelopController.h"
#import "CRNoteDatabase.h"
#import "CRNoteCurrent.h"

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
    
    NSString *basePath = [NSString stringWithFormat:@"%@/Documents/CRNoteImages/", NSHomeDirectory()];
    
    NSDirectoryEnumerator *enmu = [[NSFileManager defaultManager] enumeratorAtPath:basePath];
    
    NSString *once;
    __block NSMutableString *path = [[NSMutableString alloc] initWithString:@" "];
    NSUInteger counter = 0;
    while( (once = [enmu nextObject]) != nil ){
        counter++;
        [path appendFormat:@"%@", once];
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:[NSString stringWithFormat:@"%@%@", basePath, once]];
        
        CGFloat len = data.length / 1024 / 1024.0;
        
        [path appendFormat:@"   %.2f MB \n ", len];
    }
    
    [path appendFormat:@"%ld \n ", counter];
    [path appendFormat:@"\n "];
    
    if( self.imageCache ){
        [self.imageCache enumerateKeysAndObjectsUsingBlock:^(NSString *key, UIImage *obj, BOOL *sS){
            [path appendFormat:@"%@ %@\n ", key, obj];
        }];
    }
    
    [path appendFormat:@"%ld \n ", [self.imageCache count]];
    [path appendFormat:@"\n"];
    
    NSArray *notes = [CRNoteCurrent allCRNoteWithFormat:NO];
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
