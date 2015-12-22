//
//  CRPHAssetsPreviewController.m
//  CRNote
//
//  Created by caine on 12/22/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRPHAssetsPreviewController.h"

@interface CRPHAssetsPreviewController()

@property( nonatomic, strong ) UIImageView *crimagev;

@end

@implementation CRPHAssetsPreviewController

- (instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if( self ){
        self.crimage = image;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.crimagev = ({
        UIImageView *imv = [[UIImageView alloc] init];
        imv.translatesAutoresizingMaskIntoConstraints = NO;
        imv.contentMode = UIViewContentModeScaleAspectFit;
        imv.image = self.crimage;
        imv;
    });
    [self.view addSubview:self.crimagev];
    [self.crimagev.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.crimagev.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.crimagev.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.crimagev.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
}

@end
