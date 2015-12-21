//
//  CRNoteViewController.m
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define CR_PEAK_HEIGHT 52.0f

#import "CRNoteViewController.h"
#import "CRColorPickController.h"
#import "GGAnimationSunrise.h"
#import "CRFontController.h"

@interface CRNoteViewController()<UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>

@property( nonatomic, strong ) GGAnimationSunrise *sun;

@property( nonatomic, strong ) UIView *parkGround;
@property( nonatomic, strong ) UIImageView *parkBear;
@property( nonatomic, strong ) UILabel *parkTitle;
@property( nonatomic, strong ) NSLayoutConstraint *parkGuide;

@property( nonatomic, strong ) UIView *peak;

@property( nonatomic, strong ) UIButton *peakButtonCopy;
@property( nonatomic, strong ) UIButton *peakButtonColor;
@property( nonatomic, strong ) UIButton *peakButtonFont;
@property( nonatomic, strong ) UIButton *peakButtonLock;
@property( nonatomic, strong ) UIButton *peakButtonSave;
@property( nonatomic, strong ) UIButton *peakButtonMessage;

@property( nonatomic, strong ) NSLayoutConstraint *peakGuide;
@property( nonatomic, strong ) UIButton *dismissKeyboard;
@property( nonatomic, strong ) NSLayoutConstraint *dismissKeyboarGuide;

@property( nonatomic, strong ) UIButton *floatingActionCheck;

@property( nonatomic, strong ) UITextView *textBoard;
@property( nonatomic, strong ) UITextField *titleBoard;
@property( nonatomic, assign ) CGFloat lastPointMark;

@property( nonatomic, strong ) CRColorPickController *colorPicker;
@property( nonatomic, strong ) NSMutableArray<UIColor *> *colorQueue;

@property( nonatomic, assign ) BOOL canAdjust;
@property( nonatomic, assign ) BOOL isFirstTimeViewAppear;

@end

@implementation CRNoteViewController

- (instancetype)initFromCRNote:(CRNote *)note themeColor:(UIColor *)themeColor{
    self = [super init];
    if( self ){
        self.crnote = note;
        self.themeColor = themeColor;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if( !self.themeColor ){
        self.themeColor = [UIColor themeColorFromString:CRThemeColorDefault];
        self.themeString = CRThemeColorDefault;
    }
    self.canAdjust = YES;
    self.isFirstTimeViewAppear = YES;
    
    [self makeTextBoard];
    [self makePark];
    [self makePeak];
    
//    if( 1 == 1 )
    [self makeBear];
    
    [self addNotificationObserver];
    [self viewLastLoad];
}

- (void)viewLastLoad{
    [self.floatingActionCheck.topAnchor constraintEqualToAnchor:self.park.bottomAnchor constant:-28].active = YES;
    [self.textBoard.topAnchor constraintEqualToAnchor:self.park.bottomAnchor].active = YES;
    [self.textBoard.bottomAnchor constraintEqualToAnchor:self.peak.bottomAnchor constant:-CR_PEAK_HEIGHT].active = YES;
    self.sun = [[GGAnimationSunrise alloc] initWithType:GGAnimationSunriseTypeConcurrent blockOnCompletion:^(GGAnimationSunriseType type){
        UIColor *color = self.colorQueue.firstObject;
        [self.colorQueue removeObjectAtIndex:0];
        self.park.backgroundColor = color;
    }];
    self.sun.duration = 0.6f;
}

- (void)viewWillAppear:(BOOL)animated{
    if( self.isFirstTimeViewAppear )
        [self viewWillFristTimeAppear];
}

- (void)viewWillFristTimeAppear{
    self.textBoard.textColor =
    ([self.textBoard.text isEqualToString:@""] || [self.textBoard.text isEqualToString:CRNoteInvalilContent]) ?
    [UIColor colorWithWhite:109 alpha:255.0] : [UIColor colorWithWhite:17 / 255.0 alpha:1];
    
    if( self.crnote.editable == CRNoteEditableNO )
        [self.peakButtonLock setTitle:[UIFont mdiLock] forState:UIControlStateNormal];
    
    self.textBoard.font = self.titleBoard.font = [UIFont fontWithName:self.crnote.fontname size:[self.crnote.fontsize integerValue]];
    
    if( ![self.crnote.content isEqualToString:CRNoteInvalilContent] )
        self.textBoard.text = self.crnote.content;
    if( ![self.crnote.title isEqualToString:CRNoteInvalilTitle] )
        self.parkTitle.text = self.titleBoard.text = self.crnote.title;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isFirstTimeViewAppear = NO;
}

- (void)addNotificationObserver{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(willKeyBoardChangeFrame:)
                   name:UIKeyboardWillChangeFrameNotification
                 object:nil];
}

- (void)willKeyBoardChangeFrame:(NSNotification *)keyboardInfo{
    NSDictionary *info = [keyboardInfo userInfo];
    CGFloat constant = self.view.frame.size.height - [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions option = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    if( constant != 0 )
        self.dismissKeyboarGuide.constant = 0.0f;
    else
        self.dismissKeyboarGuide.constant = CR_PEAK_HEIGHT;
    
    self.peakGuide.constant = -constant > 0 ? 0 : -constant + CR_PEAK_HEIGHT;
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:option
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)viewEndEdit{
    [self.view endEditing:YES];
}

- (void)makeFontPicker{
    [self push:[CRFontController new]];
}

- (void)makeColorPicker{
    if( self.themeString )
        self.colorPicker.currentColorString = self.themeString;
    
    CRColorPickController *picker = [[CRColorPickController alloc] init];
    if( self.themeString )
        self.colorPicker.currentColorString = self.themeString;
    
    [self push:picker];
}

- (void)push:(UIViewController *)viewController{
    self.canAdjust = NO;
    
    [self addChildViewController:viewController];
    
    viewController.view.frame = ({
        CGRect frame = self.view.frame;
        frame.origin.y = frame.size.height;
        frame;
    });
    
    BOOL shouldLayoutPark = NO;
    if( self.parkGuide.constant != 0 ){
        self.parkGuide.constant = 0;
        shouldLayoutPark = YES;
    }
    
    [self peakLayout:YES autoLayout:NO];
    
    self.floatingActionCheck.enabled = YES;
    self.floatingActionCheck.hidden = NO;
    self.floatingActionCheck.transform = CGAffineTransformMakeScale(0, 0);
    [self.view insertSubview:viewController.view belowSubview:self.park];
    [UIView animateWithDuration:0.4f
                          delay:0.0f options:( 7 << 16 )
                     animations:^{
                         self.floatingActionCheck.transform = CGAffineTransformMakeScale(1, 1);
                         viewController.view.frame = self.view.frame;
                         
                         if( shouldLayoutPark ){
                             [self adjustSunlight];
                             [self.park layoutIfNeeded];
                         }
                         
                         [self.peak layoutIfNeeded];
                     }completion:^(BOOL f){
                         self.textBoard.hidden = YES;
                     }];
}

- (void)pop{
    self.canAdjust = YES;
    
    UIViewController *target = self.childViewControllers.firstObject;
    [self peakLayout:NO autoLayout:NO];
    self.textBoard.hidden = NO;
    [UIView animateWithDuration:0.4f
                          delay:0.0f options:( 7 << 16 )
                     animations:^{
                         self.floatingActionCheck.transform = CGAffineTransformMakeScale(0.3, 0.3);
                         self.floatingActionCheck.alpha = 0;
                         
                         target.view.frame = ({
                             CGRect frame = self.view.frame;
                             frame.origin.y = frame.size.height;
                             frame;
                         });
                         [self.peak layoutIfNeeded];
                     }completion:^(BOOL f){
                         self.floatingActionCheck.enabled = NO;
                         self.floatingActionCheck.alpha = 1;
                         self.floatingActionCheck.hidden = YES;
                         [target.view removeFromSuperview];
                         [target removeFromParentViewController];
                     }];
}

- (void)updateThemeColor:(UIColor *)color string:(NSString *)string{
    if( !self.colorQueue ) self.colorQueue = [NSMutableArray new];
    
    [self.colorQueue addObject:color];
    self.themeString = string;
    self.themeColor = color;
    [self.floatingActionCheck setTitleColor:color forState:UIControlStateNormal];
    [self.sun sunriseAtLand:self.parkGround
                   location:CGPointMake(self.view.frame.size.width / 2, (STATUS_BAR_HEIGHT + 128) / 2)
                 lightColor:color];
}

- (void)updateNoteFont:(NSString *)name size:(NSUInteger)size{
    self.textBoard.font = [UIFont fontWithName:name size:size];
}

- (void)parkSunset{
    self.park.layer.shadowOpacity = 0.27;
}

- (void)parkSunrise{
    self.park.layer.shadowOpacity = 0;
}

- (void)adjustSunlight{
    CGFloat labelAlpha = (fabs(self.parkGuide.constant) / 128.0);
    
    if( self.parkBear )
        self.parkBear.alpha = 1 - labelAlpha;
    self.parkTitle.alpha = 1 - labelAlpha;
    self.park.layer.shadowOpacity = labelAlpha * 0.27;
}

- (void)foldPark:(BOOL)fold{
    if( fold )
        [self foldParkDistants:-128];
    else
        [self foldParkDistants:0];
}

- (void)foldParkDistants:(CGFloat)distants{
    self.parkGuide.constant = distants;
    
    CGFloat alpha = 1 - (fabs(distants) / 128.0);
    
    if( distants == -128 )
        [self parkSunset];
    else
        [self parkSunrise];
    
    [UIView animateWithDuration:0.25f
                          delay:0.0f options:(7 << 16)
                     animations:^{
                         
                         self.parkTitle.alpha = alpha;
                         if( self.parkBear )
                             self.parkBear.alpha = alpha;
                         [self.view layoutIfNeeded];
                         
                     }completion:nil];
}

- (void)makePark{
    self.park = ({
        UIView *park = [[UIView alloc] init];
        park.translatesAutoresizingMaskIntoConstraints = NO;
        park.backgroundColor = self.themeColor;
        [park makeShadowWithSize:CGSizeMake(0, 1) opacity:0.0 radius:1.7];
        park;
    });
    
    self.parkTitle = ({
        UILabel *title = [[UILabel alloc] init];
        title.translatesAutoresizingMaskIntoConstraints = NO;
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor whiteColor];
        title.font = [CRNoteApp appFontOfSize:37 weight:UIFontWeightRegular];
        title.adjustsFontSizeToFitWidth = YES;
        title.numberOfLines = 0;
        title.text = CRNoteInvalilTitle;
        title;
    });
    
    self.parkGround = ({
        UIView *ground = [[UIView alloc] init];
        ground.translatesAutoresizingMaskIntoConstraints = NO;
        ground;
    });
    
    UIButton *button;
    self.dismissButton = ({
        button = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, 56, 56)];
        button.titleLabel.font = [UIFont MaterialDesignIcons];
        [button setTitleColor:[UIColor colorWithWhite:255 / 255.0 alpha:1] forState:UIControlStateNormal];
        [button setTitle:[UIFont mdiArrowLeft] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    self.floatingActionCheck = ({
        button = [[UIButton alloc] init];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.layer.cornerRadius = 56 / 2.0f;
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont MaterialDesignIconsWithSize:24];
        [button makeShadowWithSize:CGSizeMake(0.0f, 1.7f) opacity:0.3f radius:1.7f];
        [button setTitleColor:self.themeColor forState:UIControlStateNormal];
        [button setTitle:[UIFont mdiCheck] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    self.floatingActionCheck.hidden = YES;
    
    [self.park addAutolayoutSubviews:@[ self.parkGround, self.parkTitle ]];
    [self.park addSubview:self.dismissButton];
    [self.view addSubview:self.park];
    [self.view addSubview:self.floatingActionCheck];
    
    [CRLayout view:@[ self.parkGround, self.park ] type:CREdgeAround];
    [CRLayout view:@[ self.parkTitle, self.park ] type:CREdgeRight | CREdgeBottom | CREdgeLeft edge:UIEdgeInsetsMake(0, 64, -8, -24)];
    [self.parkTitle.heightAnchor constraintGreaterThanOrEqualToConstant:72].active = YES;
    [self.parkTitle.heightAnchor constraintLessThanOrEqualToConstant:56 + 72 - 16].active = YES;
    
    [self.floatingActionCheck.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-16].active = YES;
    [self.floatingActionCheck.heightAnchor constraintEqualToConstant:56].active = YES;
    [self.floatingActionCheck.widthAnchor constraintEqualToConstant:56].active = YES;
    
    [CRLayout view:@[ self.park, self.view ] type:CREdgeLeft | CREdgeRight];
    [self.park.heightAnchor constraintEqualToConstant:STATUS_BAR_HEIGHT + 56 + 72].active = YES;
    self.parkGuide = [self.park.topAnchor constraintEqualToAnchor:self.view.topAnchor];
    self.parkGuide.active = YES;
}

- (void)makeBear{
    self.parkBear = ({
        UIImageView *iv = [[UIImageView alloc] init];
        iv.translatesAutoresizingMaskIntoConstraints = NO;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.clipsToBounds = YES;
        iv.image = [UIImage imageNamed:@"bear.jpg"];
        iv;
    });
    [self.park insertSubview:self.parkBear atIndex:0];
    [CRLayout view:@[self.parkBear, self.park] type:CREdgeAround];
}

- (void)makePeak{
    UIButton *(^makeButton)(NSString *, NSUInteger) = ^(NSString *title, NSUInteger tag){
        UIButton *button = [[UIButton alloc] init];
        button.tag = 1000 + tag;
        button.titleLabel.font = [UIFont MaterialDesignIconsWithSize:24];
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:[UIColor colorWithWhite:59 / 255.0 alpha:1] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(peakAction:) forControlEvents:UIControlEventTouchUpInside];
        return button;
    };
    
    self.peak = ({
        UIView *peak = [[UIView alloc] init];
        peak.translatesAutoresizingMaskIntoConstraints = NO;
        peak.backgroundColor = [UIColor whiteColor];
        [peak makeShadowWithSize:CGSizeMake(0, -1) opacity:0.17 radius:3];
        peak;
    });
    
    self.peakButtonCopy = makeButton([UIFont mdiContentCopy], 0);
    self.peakButtonLock = makeButton([UIFont mdiLockOpen], 1);
    self.peakButtonColor = makeButton([UIFont mdiPalette], 2);
    self.peakButtonSave = makeButton([UIFont mdiPackageDown], 3);
    self.peakButtonFont = makeButton([UIFont mdiParking], 4);
    
    UIButton *button;
    self.dismissKeyboard = ({
        button = [[UIButton alloc] init];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.titleLabel.font = [UIFont MaterialDesignIconsWithSize:24];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:[UIFont mdiKeyboardClose] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:102 / 255.0 alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(viewEndEdit) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    self.peakButtonMessage = ({
        button = [[UIButton alloc] init];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.titleLabel.font = [CRNoteApp appFontOfSize:19 weight:UIFontWeightMedium];
        button.backgroundColor = [UIColor colorWithWhite:50 / 255.0 alpha:1];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, -16);
        [button setTitleColor:[UIColor colorWithWhite:237 / 255.0 alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(peakMessageDisappear) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    __block NSLayoutAnchor *anchor = self.peak.leftAnchor;
    [@[ self.peakButtonCopy, self.peakButtonFont, self.peakButtonLock, self.peakButtonColor, self.peakButtonSave ]
     enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger index, BOOL *sS){
         obj.translatesAutoresizingMaskIntoConstraints = NO;
         [self.peak addSubview:obj];
         
         [obj.heightAnchor constraintEqualToAnchor:self.peak.heightAnchor multiplier:0.5].active = YES;
         [obj.widthAnchor constraintEqualToAnchor:self.peak.widthAnchor multiplier:( 1 / 5.0 )].active = YES;
         [obj.topAnchor constraintEqualToAnchor:self.peak.topAnchor].active = YES;
         [obj.leftAnchor constraintEqualToAnchor:anchor].active = YES;
         anchor = obj.rightAnchor;
    }];
    
    [self.peak addSubview:self.dismissKeyboard];
    [self.peak addSubview:self.peakButtonMessage];
    [self.view addSubview:self.peak];
    
    [@[ self.dismissKeyboard, self.peakButtonMessage ] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger index, BOOL *sS){
        [obj.heightAnchor constraintEqualToConstant:52].active = YES;
        [obj.centerXAnchor constraintEqualToAnchor:self.peak.centerXAnchor].active = YES;
         [obj.widthAnchor constraintEqualToAnchor:self.peak.widthAnchor].active = YES;
        if( index == 0 ){
            self.dismissKeyboarGuide = [obj.topAnchor constraintEqualToAnchor:self.peak.topAnchor constant:52];
            self.dismissKeyboarGuide.active = YES;
        }else{
            [obj.bottomAnchor constraintEqualToAnchor:self.peak.bottomAnchor].active = YES;
        }
    }];
    
    self.peakGuide = [self.peak.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:52];
    self.peakGuide.active = YES;
    [self.peak.heightAnchor constraintEqualToConstant:104].active = YES;
    [CRLayout view:@[ self.peak, self.view ] type:CREdgeLeft | CREdgeRight];
}

- (void)peakLayout:(BOOL)hide autoLayout:(BOOL)layout{
    if( hide )
        self.peakGuide.constant = CR_PEAK_HEIGHT * 2;
    else
        self.peakGuide.constant = CR_PEAK_HEIGHT;
    
    if( layout )
        [UIView animateWithDuration:0.25f
                              delay:0.0f options:(7 << 16)
                         animations:^{
                             [self.peak layoutIfNeeded];
                         }completion:nil];
}

- (void)peakMessage:(NSString *)message{
    [self.peakButtonMessage setTitle:message forState:UIControlStateNormal];
    
    self.peakGuide.constant = 0;
    [UIView animateWithDuration:0.25f
                          delay:0.0f options:(7 << 16)
                     animations:^{
                         [self.peak layoutIfNeeded];
                     }completion:nil];
}

- (void)peakMessageDisappear{
    [self peakLayout:NO autoLayout:YES];
}

- (void)peakAction:(UIButton *)sender{
    NSUInteger tag = sender.tag - 1000;
    NSLog(@"%ld", tag);
    if( tag == 1 ){
        if( self.crnote.editable == CRNoteEditableYes ){
            [self contentLock:YES];
            [self peakMessage:@"Note Locked"];
        }else{
            [self contentLock:NO];
            [self peakMessage:@"Note Unlocked"];
        }
    }else if( tag == 2 ){
        [self makeColorPicker];
        
    }else if( tag == 4 ){
        [self makeFontPicker];
        
    }
}

- (void)makeTextBoard{
    self.textBoard = ({
        UITextView *board = [[UITextView alloc] init];
        board.translatesAutoresizingMaskIntoConstraints = NO;
        board.contentInset = UIEdgeInsetsMake(0, 0, 108, 0);
        board.textContainerInset = UIEdgeInsetsMake(60, 24, 0, 24);
        board.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 52, 0);
        board.textContainer.lineFragmentPadding = 0;
        board.tintColor = [UIColor CRColor:97 :125 :138 :1];
//        board.font = [CRNoteApp appFontOfSize:21 weight:UIFontWeightRegular]
        board.textColor = [UIColor colorWithWhite:109 / 255.0 alpha:1];
        board.text = CRNoteInvalilContent;
        board.delegate = self;
        board;
    });
    
    self.lastPointMark = 0;
    
    self.textBoard.text = @"controller you choose for each tab should reflect the needs of that particular mode of operation. If you need to present a relatively rich set of data, you could install a navigation controller to manage the navigation through that data. If the data being presented is simpler, you could install a content view controller with a single view.Figure 2-4 shows several screens from the Clock app. The World Clock tab uses a navigation controller primarily so that it can present the buttons it needs to edit the list of clocks. The Stopwatch tab requires only a single screen for its entire interface and therefore uses a single view controller. The Timer tab uses a custom view controller for the main screen and presents an additional view controller modally when the When Timer Ends button is tapped.    The tab bar controller handles all of the interactions associated with presenting the content view controllers, so there is very little you have to do with regard to managing tabs or the view controllers in them. Once displayed, your content view controllers should simply focus on presenting their content.For general information and guidance on defining custom view controllers, see Creating Custom Content View Controllers inListing 2-1 shows the basic code needed to create and install a tab bar controller interface in the main window of your app. This example creates only two tabs, but you could create as many tabs as needed by creating more view controller objects and adding them to the controllers array. You need to replace the custom view controller names MyViewController and MyOtherViewController with classes from your own app";
    
    self.titleBoard = ({
        UITextField *board = [[UITextField alloc] init];
        board.translatesAutoresizingMaskIntoConstraints = NO;
        board.placeholder = CRNoteInvalilTitle;
//        board.font = [CRNoteApp appFontOfSize:23 weight:UIFontWeightMedium];
        board.textColor = [UIColor colorWithWhite:27 / 255 alpha:1];
        board.tintColor = [UIColor CRColor:97 :125 :138 :1];
        board.delegate = self;
        [board addTarget:self action:@selector(updateTitle) forControlEvents:UIControlEventAllEditingEvents];
        board;
    });
    
    [self.textBoard addSubview:self.titleBoard];
    [self.view addSubview:self.textBoard];
    
    [self.titleBoard.centerXAnchor constraintEqualToAnchor:self.textBoard.centerXAnchor].active = YES;
    [self.titleBoard.widthAnchor constraintEqualToAnchor:self.textBoard.widthAnchor constant:-48].active = YES;
    [self.titleBoard.heightAnchor constraintEqualToConstant:56].active = YES;
    [self.titleBoard.topAnchor constraintEqualToAnchor:self.textBoard.topAnchor constant:4].active = YES;
    
    [CRLayout view:@[ self.textBoard, self.view ] type:CREdgeLeft | CREdgeRight];
}

- (void)updateTitle{
    if( [self.titleBoard.text isEqualToString:@""] )
        self.parkTitle.text = CRNoteInvalilTitle;
    else
        self.parkTitle.text = self.titleBoard.text;
}

- (void)contentLock:(BOOL)lock{
    self.textBoard.editable = !lock;
    self.titleBoard.enabled = !lock;
    self.crnote.editable = lock ? CRNoteEditableNO : CRNoteEditableYes;
    
    if( lock )
        [self.peakButtonLock setTitle:[UIFont mdiLock] forState:UIControlStateNormal];
    else
        [self.peakButtonLock setTitle:[UIFont mdiLockOpen] forState:UIControlStateNormal];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if( self.peakGuide.constant == 0 )
        [self peakLayout:NO autoLayout:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pointY = scrollView.contentOffset.y;
    
    BOOL shouldLayout = NO, isScrollUp = NO;
    CGFloat offset = self.view.frame.size.height - 52 - STATUS_BAR_HEIGHT - 128 + fabs(self.parkGuide.constant);
    CGFloat distants = pointY - self.lastPointMark;
    
    if( self.lastPointMark < pointY )
        isScrollUp = YES;
    else if( self.lastPointMark > pointY )
        isScrollUp = NO;
    
    if( pointY > -1 && pointY < scrollView.contentSize.height - offset + 1 ){
        shouldLayout = YES;
    }
    
    if( shouldLayout && self.canAdjust )
        isScrollUp ? ([self scrollViewDidScrollUp:fabs(distants)]) : ([self scrollviewDidScrollDown:fabs(distants)]);
    
    self.lastPointMark = pointY;
}

- (void)scrollviewDidScrollDown:(CGFloat)distants{
    if( self.parkGuide.constant == 0 ) return;
    
    self.parkGuide.constant = self.parkGuide.constant + distants > 0 ? 0 : self.parkGuide.constant + distants;
    [self adjustSunlight];
    [self.park layoutIfNeeded];
}

- (void)scrollViewDidScrollUp:(CGFloat)distants{
    if( self.parkGuide.constant == -128 ) return;
    
    self.parkGuide.constant = self.parkGuide.constant - distants < -128 ? -128 : self.parkGuide.constant - distants;
    [self adjustSunlight];
    [self.peak layoutIfNeeded];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self foldPark:YES];
    
    if( [textView.text isEqualToString:CRNoteInvalilContent] ){
        textView.textColor = [UIColor colorWithWhite:17 / 255.0 alpha:1];
        textView.text = @"";
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self foldPark:NO];
    
    NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if( [text isEqualToString:CRNoteInvalilContent] || [text isEqualToString:@""] ){
        textView.textColor = [UIColor colorWithWhite:109 / 255.0 alpha:1];
        textView.text = CRNoteInvalilContent;
    }
    
    return YES;
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
