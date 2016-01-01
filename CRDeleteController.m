//
//  CRDeleteController.m
//  CRNote
//
//  Created by caine on 1/1/16.
//  Copyright © 2016 com.caine. All rights reserved.
//

#import "CRNoteManager.h"
#import "CRDeleteController.h"
#import "CRNoteApp.h"

@interface CRDeleteController()

@end

@implementation CRDeleteController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:43 / 255.0 alpha:1];
    
    UILabel *title = ({
        UILabel *ti = [[UILabel alloc] init];
        ti.font = [CRNoteApp appFontOfSize:32 weight:UIFontWeightRegular];
        ti.text = @"Delete";
        ti.textColor = [UIColor whiteColor];
        ti.adjustsFontSizeToFitWidth = YES;
        ti.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:ti];
        [ti.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:STATUS_BAR_HEIGHT + 128 + 28].active = YES;
        [ti.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:24].active = YES;
        [ti.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-24].active = YES;
        [ti.heightAnchor constraintEqualToConstant:72].active = YES;
        ti;
    });
    
    UILabel *infomation = ({
        UILabel *info = [[UILabel alloc] init];
        info.font = [CRNoteApp appFontOfSize:21 weight:UIFontWeightLight];
        info.text = @"Are you sure delete this note?";
        info.textColor = [UIColor whiteColor];
        info.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:info];
        [info.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:24].active = YES;
        [info.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-24].active = YES;
        [info.topAnchor constraintEqualToAnchor:title.bottomAnchor].active = YES;
        [info.heightAnchor constraintGreaterThanOrEqualToConstant:56].active = YES;
        [info.heightAnchor constraintLessThanOrEqualToConstant:280].active = YES;
        info;
    });
    
    UIButton *delete = ({
        UIButton *del = [[UIButton alloc] init];
        del.titleLabel.font = [CRNoteApp appFontOfSize:18 weight:UIFontWeightMedium];
        del.translatesAutoresizingMaskIntoConstraints = NO;
        del.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [del addTarget:self action:@selector(letDelete) forControlEvents:UIControlEventTouchUpInside];
        [del setTitle:@"Delete" forState:UIControlStateNormal];
        [del setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [del setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateHighlighted];
        [self.view addSubview:del];
        [del.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-24].active = YES;
        [del.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-16].active = YES;
        [del.widthAnchor constraintEqualToConstant:200].active = YES;
        [del.heightAnchor constraintEqualToConstant:32].active = YES;
        del;
    });
}

- (void)letDelete{
    [[CRNoteManager defaultManager] letDelete];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
