//
//  CRPhotoPreviewController.m
//  CRNote
//
//  Created by caine on 12/22/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRPhotoPreviewController.h"

@interface CRPhotoPreviewController()

@property( nonatomic, strong ) UILabel *titleLabel;
@property( nonatomic, strong ) UIButton *buttonDelete;

@property( nonatomic, strong ) UIImageView *crimageview;
@property( nonatomic, strong ) UIImage *crimage;

@end

@implementation CRPhotoPreviewController

- (instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if( self ){
        self.crimage = image;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self makePark];
    [self makeCrimage];
}

- (void)makePark{
    self.park = ({
        UIView *park = [[UIView alloc] init];
        park.translatesAutoresizingMaskIntoConstraints = NO;
        park.backgroundColor = [UIColor clearColor];
        park;
    });
    
    UIButton *(^makeButton)(NSString *, NSUInteger) = ^(NSString *title, NSUInteger tag){
        UIButton *button = [[UIButton alloc] init];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.tag = tag + 1000;
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont MaterialDesignIconsWithSize:24];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(parkAction:) forControlEvents:UIControlEventTouchUpInside];
        return button;
    };
    
    self.dismissButton = makeButton([UIFont mdiArrowLeft], 0);
    self.buttonDelete = makeButton([UIFont mdiDelete], 1);
    
    [self.view addSubview:self.park];
    [self.park addSubview:self.dismissButton];
    [self.park addSubview:self.buttonDelete];
    
    [self.park.heightAnchor constraintEqualToConstant:STATUS_BAR_HEIGHT + 56.0f].active = YES;
    [self.dismissButton.widthAnchor constraintEqualToConstant:56].active = YES;
    [self.buttonDelete.widthAnchor constraintEqualToConstant:56].active = YES;
    
    [CRLayout view:@[self.park, self.view] type:CREdgeTop | CREdgeLeft | CREdgeRight];
    [CRLayout view:@[self.dismissButton, self.park] type:CREdgeTop | CREdgeLeft | CREdgeBottom edge:UIEdgeInsetsMake(STATUS_BAR_HEIGHT, 0, 0, 0)];
    [CRLayout view:@[self.buttonDelete, self.park] type:CREdgeRight | CREdgeTop | CREdgeBottom edge:UIEdgeInsetsMake(STATUS_BAR_HEIGHT, 0, 0, 0)];
}

- (void)makeCrimage{
    self.crimageview = ({
        UIImageView *im = [[UIImageView alloc] initWithImage:self.crimage];
        im.translatesAutoresizingMaskIntoConstraints = NO;
        im.contentMode = UIViewContentModeScaleAspectFit;
        im;
    });
    
    [self.view addSubview:self.crimageview];
    
    [self.crimageview.topAnchor constraintEqualToAnchor:self.park.bottomAnchor].active = YES;
    [CRLayout view:@[self.crimageview, self.view] type:CREdgeBottom | CREdgeLeft | CREdgeRight];
}

- (void)parkAction:(UIButton *)sender{
    NSUInteger tag = sender.tag - 1000;
    if( tag == 0 ){
        [self dismissSelf];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
