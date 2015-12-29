//
//  CRPark.m
//  CRNote
//
//  Created by caine on 12/25/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRPark.h"
#import "UIView+CRView.h"
#import "CRNoteApp.h"
#import "UIFont+MaterialDesignIcons.h"
#import "GGAnimationSunrise.h"
#import "CRMutableQueue.h"

@interface CRPark()

@property( nonatomic, strong ) GGAnimationSunrise *sun;
@property( nonatomic, strong ) CRMutableQueue *queue;

@property( nonatomic, strong ) UIView *contentView;
@property( nonatomic, strong ) UIImageView *photowall;

@end

@implementation CRPark

- (instancetype)initFromColor:(UIColor *)color{
    self = [super init];
    if( self ){
        [self initClass];
        self.contentView.backgroundColor = color;
    }
    return self;
}

- (void)setColor:(UIColor *)color{
    _color = color;
    
    if( self.queue == nil )
        self.queue = [[CRMutableQueue alloc] initFromArray:nil];
    
    [self.queue addObject:color];
    [self.sun sunriseAtLand:self.contentView
                   location:CGPointMake(self.frame.size.width / 2.0, ([UIApplication sharedApplication].statusBarFrame.size.height + 128) / 2.0)
                 lightColor:color];
}

- (void)setImage:(UIImage *)image{
    _image = image;
    
    self.photowall.image = image;
}

- (void)setNameplateOpacity:(CGFloat)nameplateOpacity{
    if( nameplateOpacity < 0 || nameplateOpacity > 1 ) return;
    _nameplateOpacity = nameplateOpacity;
    
    self.nameplate.alpha = 1 - nameplateOpacity;
    self.layer.shadowOpacity = nameplateOpacity * 0.27;
}

- (void)initClass{
    
    CGFloat statusFrameHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    self.sun = [[GGAnimationSunrise alloc] initWithType:GGAnimationSunriseTypeConcurrent
                                      blockOnCompletion:^(GGAnimationSunriseType type){
                                          self.contentView.backgroundColor = (UIColor *)self.queue.dequeue;
                                      }];
    self.sun.duration = 0.6f;
    
    self.contentView = ({
        UIView *content = [[UIView alloc] init];
        [content setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:content];
        [content.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [content.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        [content.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
        [content.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        content;
    });
    
    self.photowall = ({
        UIImageView *wall = [[UIImageView alloc] init];
        wall.translatesAutoresizingMaskIntoConstraints = NO;
        wall.contentMode = UIViewContentModeScaleAspectFill;
        wall.clipsToBounds = YES;
        [self.contentView addSubview:wall];
        [wall.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
        [wall.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
        [wall.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
        [wall.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        wall;
    });
    
    self.nameplate = ({
        UILabel *plate = [[UILabel alloc] init];
        plate.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:plate];
        [plate.heightAnchor constraintGreaterThanOrEqualToConstant:72].active = YES;
        [plate.heightAnchor constraintLessThanOrEqualToConstant:112].active = YES;
        [plate.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8].active = YES;
        [plate.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-8].active = YES;
        [plate.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:64].active = YES;
        plate.textColor = [UIColor whiteColor];
        plate.font = [CRNoteApp appFontOfSize:38 weight:UIFontWeightRegular];
        plate.adjustsFontSizeToFitWidth = YES;
        plate.numberOfLines = 0;
        plate;
    });
    
    self.dismissBtn = ({
        UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(0, statusFrameHeight, 56, 56)];
        [self.contentView addSubview:dismiss];
        [dismiss.titleLabel setFont:[UIFont MaterialDesignIconsWithSize:24]];
        [dismiss setTitle:[UIFont mdiArrowLeft] forState:UIControlStateNormal];
        [dismiss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        dismiss;
    });
}

@end
