//
//  CRNavigationViewController.m
//  CRTestingProject
//
//  Created by caine on 12/18/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define CR_SEGUE_DURATION 0.25

#import "CRNavigationController.h"
#import "UIView+MOREShadow.h"
#import "UIFont+MaterialDesignIcons.h"
#import "CRStack.h"
#import "CRQueue.h"
#import "CRNavigationLeadingLabel.h"
#import "CRBasicViewController.h"

#import "CRSettings.h"
#import "CRTheme.h"
#import "UIColor+CRColor.h"

static NSString *const CRNavigationControllerSeguePush = @"CR_NAVIGATION_CONTROLLER_SEGUE_PUSH";
static NSString *const CRNavigationControllerSeguePop  = @"CR_NAVIGATION_CONTROLLER_SEGUE_POP";

@interface CRNavigationController()

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UIButton *dismissButton;
@property( nonatomic, strong ) CRNavigationLeadingLabel *titleLabel;

@property( nonatomic, strong ) CRQueue *operationQueue;
@property( nonatomic, assign ) BOOL canOperation;
@property( nonatomic, assign ) NSUInteger level;

@property( nonatomic, strong ) CRStack *crviewControllerStack;
@property( nonatomic, strong ) UIViewController *crrootViewController;
@property( nonatomic, strong ) UIViewController *crvisualViewController;

@end

@implementation CRNavigationController

- (instancetype)initWithRootViewController:(CRBasicViewController *)rootViewController{
    self = [super init];
    if( self ){
        
        self.operationQueue = [[CRQueue alloc] init];
        self.canOperation = YES;
        self.crviewControllerStack = [[CRStack alloc] init];
        self.level = 0;
        
        self.level++;
        self.crrootViewController = rootViewController;
        self.crvisualViewController = rootViewController;
        [self addChildViewController:rootViewController];
        [self.crviewControllerStack push:rootViewController];
        
        rootViewController.crnavigationController = self;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.crvisualViewController.view];
    
    [self makePark];
}

- (void)dismissSelf{
    if( [self.crviewControllerStack count] > 1 ){
        [self crpopViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)crpushViewController:(CRBasicViewController *)controller animated:(BOOL)animated{
    [self.operationQueue push:@[ CRNavigationControllerSeguePush, controller ]];
    controller.crnavigationController = self;
    self.level++;
    
    if( self.canOperation == YES )
        [self check];
}

- (void)crpopViewControllerAnimated:(BOOL)animated{
    if( self.level > 1 ){
        [self.operationQueue push:@[ CRNavigationControllerSeguePop ]];
        self.level--;
        
        if( self.canOperation == YES )
            [self check];
    }
}

- (void)check{
    NSArray *segue = [self.operationQueue pop];
    
    if( segue ){
        if( [(NSString *)segue.firstObject isEqualToString:CRNavigationControllerSeguePush] ){
            [self crtransitionToViewController:(UIViewController *)segue.lastObject];
        }else if( [(NSString *)segue.firstObject isEqualToString:CRNavigationControllerSeguePop] ){
            [self crtransitionToViewController:nil];
        }
    }else{
        self.canOperation = YES;
    }
}

- (void)crtransitionToViewController:(UIViewController *)toViewController{
    self.canOperation = NO;
    [self parkSunrise];
    
    BOOL isPush;
    UIViewController *fromViewController;
    if( toViewController == nil ){
        isPush = NO;
        [self.crviewControllerStack pop];
        fromViewController = self.crvisualViewController;
        toViewController = (UIViewController *)[self.crviewControllerStack pop];
        
        fromViewController.view.frame = self.view.frame;
        toViewController.view.frame = CGRectMake(-(self.view.frame.size.width * 0.3), 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view insertSubview:toViewController.view belowSubview:fromViewController.view];
        
        [self.titleLabel push:CRNavigationLeadingLabelTypePop title:toViewController.title];
    }else{
        isPush = YES;
        fromViewController = self.crvisualViewController;
        
        toViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view insertSubview:toViewController.view belowSubview:self.park];
        
        [self.titleLabel push:CRNavigationLeadingLabelTypePush title:toViewController.title];
    }
    
    [UIView animateWithDuration:CR_SEGUE_DURATION
                          delay:0.0f
                        options:( 7 << 16 )
                     animations:^{
                         
                         if( isPush ){
                             fromViewController.view.frame = ({
                                 CGRect frame = self.view.frame;
                                 frame.origin.x = -(self.view.frame.size.width * 0.3);
                                 frame;
                             });
                             toViewController.view.frame = self.view.frame;
                         }else{
                             fromViewController.view.frame = ({
                                 CGRect frame = self.view.frame;
                                 frame.origin.x = self.view.frame.size.width;
                                 frame;
                             });
                             toViewController.view.frame = self.view.frame;
                         }
                         
                     }completion:^(BOOL f){
                         
                         [self.crvisualViewController.view removeFromSuperview];
                         [self.crviewControllerStack push:toViewController];
                         if( !isPush ){
                             [self.crvisualViewController removeFromParentViewController];
                         }
                         
                         self.crvisualViewController = toViewController;
                         
                         [self check];
                         
                     }];
}

- (void)parkSunset{
    self.park.layer.shadowOpacity = 0.27;
}

- (void)parkSunrise{
    self.park.layer.shadowOpacity = 0;
}

- (void)makePark{
    CGFloat parkHeight = 56.0f;
    self.park = ({
        UIView *park = [UIView new];
        park.translatesAutoresizingMaskIntoConstraints = NO;
        park.backgroundColor = [UIColor whiteColor];
        [park makeShadowWithSize:CGSizeMake(0, 1) opacity:0 radius:1.7];
        park;
    });
    
    self.dismissButton = ({
        UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, parkHeight, parkHeight)];
        dismiss.backgroundColor = [UIColor clearColor];
        dismiss.titleLabel.font = [UIFont MaterialDesignIconsWithSize:24];
        [dismiss setTitle:[UIFont mdiArrowLeft] forState:UIControlStateNormal];
        [dismiss setTitleColor:[UIColor colorWithWhite:102 / 255.0 alpha:1] forState:UIControlStateNormal];
        [dismiss addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        dismiss;
    });
    
    self.titleLabel = ({
        CRNavigationLeadingLabel *label = [[CRNavigationLeadingLabel alloc] initWithTitle:self.crrootViewController.title];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [label setFont:[CRSettings appFontOfSize:21 weight:UIFontWeightRegular] color:[UIColor colorWithWhite:57 / 255.0 alpha:1]];
        label.duration = CR_SEGUE_DURATION;
        label;
    });
    
    self.leftItemButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.titleLabel.font = [CRSettings appFontOfSize:17 weight:UIFontWeightRegular];
        [button setTitleColor:[UIColor colorWithWhite:157 / 255.0 alpha:1] forState:UIControlStateNormal];
        [button setTitle:@"Edit" forState:UIControlStateNormal];
        button;
    });
    
    [self.park addSubview:self.dismissButton];
    [self.park addSubview:self.titleLabel];
    [self.park addSubview:self.leftItemButton];
    [self.view addSubview:self.park];
    
    [self.park.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.park.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.park.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.park.heightAnchor constraintEqualToConstant:STATUS_BAR_HEIGHT + parkHeight].active = YES;
    
    [self.titleLabel.heightAnchor constraintEqualToConstant:parkHeight].active = YES;
    [self.titleLabel.widthAnchor constraintEqualToConstant:180.0f].active = YES;
    [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.park.bottomAnchor].active = YES;
    [self.titleLabel.leftAnchor constraintEqualToAnchor:self.park.leftAnchor constant:56].active = YES;
    
    [self.leftItemButton.widthAnchor constraintEqualToConstant:64].active = YES;
    [self.leftItemButton.topAnchor constraintEqualToAnchor:self.park.topAnchor constant:STATUS_BAR_HEIGHT].active = YES;
    [self.leftItemButton.rightAnchor constraintEqualToAnchor:self.park.rightAnchor].active = YES;
    [self.leftItemButton.bottomAnchor constraintEqualToAnchor:self.park.bottomAnchor].active = YES;

}

@end
