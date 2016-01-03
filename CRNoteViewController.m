//
//  CRNoteViewController.m
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define CR_USER_LIBRARY_DENEY @"library access denied, tap to setting."

#import "CRNoteManager.h"
//#import "CRNoteDatabase.h"
#import "CRNoteViewController.h"
#import "CRColorPickController.h"
#import "GGAnimationSunrise.h"
#import "CRFontController.h"
#import "CRPhotoPreviewController.h"
#import "CRPHAssetsController.h"
#import "CRDeleteController.h"

//google style
#import "CRPark.h"
#import "CRPeak.h"

//visual style
#import "CRVisualPeak.h"
#import "CRVisualYosemite.h"
#import "CRVisualFloatingButton.h"

static NSString *const PH_AUTHORIZATION_STATUS_DENIED_MESSAGE_STRING = @"Library access denied, tap to setting.";

@interface CRNoteViewController()<UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>

@property( nonatomic, strong ) GGAnimationSunrise *sun;

@property( nonatomic, assign ) BOOL noteEditable;

@property( nonatomic, strong ) CRVisualYosemite *yosemite;
@property( nonatomic, strong ) NSLayoutConstraint *yosemiteLayoutGuide;

@property( nonatomic, strong ) CRVisualPeak *peak;
@property( nonatomic, strong ) NSLayoutConstraint *peakLayoutGuide;

@property( nonatomic, strong ) CRVisualFloatingButton *floatingCheck;

@property( nonatomic, strong ) UITextView *textBoard;
@property( nonatomic, strong ) UITextField *titleBoard;
@property( nonatomic, assign ) CGFloat lastPointMark;

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

- (void)setNoteEditable:(BOOL)noteEditable{
    _noteEditable = noteEditable;
    
    self.titleBoard.enabled = noteEditable;
    self.textBoard.editable = noteEditable;
    
    if( noteEditable ){
        self.crnote.editable = CRNoteEditableYes;
        [self.peak.lock setTitle:[UIFont mdiLockOpen] forState:UIControlStateNormal];
    }else{
        self.crnote.editable = CRNoteEditableNO;
        [self.peak.lock setTitle:[UIFont mdiLock] forState:UIControlStateNormal];
    }
}


-(NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    UIPreviewAction *moveToTopAction = [UIPreviewAction actionWithTitle:@"Move to top" style:UIPreviewActionStyleDefault handler:
                                        ^(UIPreviewAction *action, UIViewController *previewcontroller){
                                            
                                            if( self.crnoteDeleteActionHandler )
                                                self.crnoteDeleteActionHandler( action.title );
                                            
                                        }];
    
    UIPreviewAction *deleteAction = [UIPreviewAction actionWithTitle:@"Delete" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewController) {
        
        if( self.crnoteDeleteActionHandler )
            self.crnoteDeleteActionHandler( action.title );
        
    }];

    UIPreviewAction *cancel = [UIPreviewAction actionWithTitle:@"Cancel" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewController){
        
        if( self.crnoteDeleteActionHandler )
            self.crnoteDeleteActionHandler( action.title );
            
    }];
    
    UIPreviewActionGroup *delete = [UIPreviewActionGroup actionGroupWithTitle:@"Delete" style:UIPreviewActionStyleDestructive actions:@[ deleteAction, cancel ]];
    
    return @[ moveToTopAction, delete ];
}

- (void)viewThenLoad{
    self.view.backgroundColor = [UIColor whiteColor];
    self.themeColorString = self.crnote.colorType;
    self.themeColor = [UIColor themeColorFromString:self.themeColorString];
    self.canAdjust = YES;
    self.isFirstTimeViewAppear = YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self viewThenLoad];
    [self letTextBoard];
    [self letPark];
    [self letPeak];
    
    [self addNotificationObserver];
    [self viewLastLoad];
}

- (void)viewLastLoad{
    [self.textBoard.topAnchor constraintEqualToAnchor:self.yosemite.bottomAnchor].active = YES;
    [self.textBoard.bottomAnchor constraintEqualToAnchor:self.peak.bottomAnchor].active = YES;
    
    if( [self.crnote.colorType isEqualToString:CRThemeColorDefault] == NO )
        [self.peak.palette setTitleColor:[UIColor themeColorFromString:self.crnote.colorType] forState:UIControlStateNormal];
    
    if( [self.crnote.type isEqualToString:CRNoteTypePhoto] )
        self.yosemite.image = [[CRPhotoManager defaultManager] photoFromPhotoname:self.crnote.imageName];
    
    if( self.crnote.editable == CRNoteEditableYes )
        self.noteEditable = YES;
    else
        self.noteEditable = NO;
    
    self.titleBoard.font = [UIFont fontWithName:self.crnote.fontname size:21];
    self.textBoard.font = [UIFont fontWithName:self.crnote.fontname size:[self.crnote.fontsize integerValue]];
    
    if( ![self.crnote.title isEqualToString:CRNoteInvalilTitle] ){
        self.titleBoard.text = self.crnote.title;
        self.yosemite.nameplate.text = self.crnote.title;
    }else{
        self.yosemite.nameplate.text = CRNoteInvalilTitle;
    }
    
    if( ![self.crnote.content isEqualToString:CRNoteInvalilContent] ){
        self.textBoard.text = self.crnote.content;
        self.textBoard.textColor = [UIColor colorWithWhite:17 / 255.0 alpha:1];
    }else{
        self.textBoard.text = @"Note";
        self.textBoard.textColor = [UIColor colorWithWhite:107 / 255.0 alpha:1];
    }
    
    self.textBoard.tintColor = self.themeColor;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if( self.isPreview ){
        self.yosemite.dismissBtn.hidden = YES;
        self.peak.hidden = YES;
    }else{
        self.yosemite.dismissBtn.hidden = NO;
        self.peak.hidden = NO;
    }
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
    
    self.peakLayoutGuide.constant = -constant > 0 ? 0 : -constant;
    
    if( self.peakLayoutGuide.constant == 0 )
        self.peak.enbleSubbtn = NO;
    else
        self.peak.enbleSubbtn = YES;
    
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] floatValue]
                          delay:0.0f
                        options:[info[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                     animations:^{
                         
                         if( self.peak.alpha != 1 )
                             self.peak.alpha = 1;
                         
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)viewEndEdit{
    [self.view endEditing:YES];
}

- (void)push:(UIViewController *)viewController{
    self.canAdjust = NO;
    [self addChildViewController:viewController];
    
    viewController.view.frame = ({
        CGRect frame = self.view.frame;
        frame.origin.y = frame.size.height;
        frame;
    });
    
    self.peak.notification = nil;
    self.peakLayoutGuide.constant = CR_PEAK_HEIGHT;
    
    BOOL shouldLayoutYosimite = NO;
    if( self.yosemiteLayoutGuide.constant != 0 ){
        self.yosemiteLayoutGuide.constant  = 0;
        shouldLayoutYosimite = YES;
    }
    
    self.floatingCheck.hidden = NO;
    self.floatingCheck.transform = CGAffineTransformMakeScale(0, 0);
    [self.view insertSubview:viewController.view belowSubview:self.yosemite];
    [viewController.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.25f
                          delay:0.0f options:( 7 << 16 )
                     animations:^{
                         self.floatingCheck.enabled = YES;
                         self.floatingCheck.alpha = 1;
                         self.floatingCheck.transform = CGAffineTransformMakeScale(1, 1);
                         
                         viewController.view.frame = self.view.frame;
                         
                         if( shouldLayoutYosimite )
                             [self updateYosemiteOpacity];
                         
                         [self.view layoutIfNeeded];
                     }completion:^(BOOL f){
                         self.textBoard.hidden = YES;
                     }];
}

- (void)pop{
    self.canAdjust = YES;
    UIViewController *target = self.childViewControllers.firstObject;
    self.textBoard.hidden = NO;
    self.peakLayoutGuide.constant = 0;
    [UIView animateWithDuration:0.4f
                          delay:0.0f options:( 7 << 16 )
                     animations:^{
                         self.floatingCheck.enabled = NO;
                         self.floatingCheck.alpha = 0;
                         self.floatingCheck.transform = CGAffineTransformMakeScale(0.3, 0.3);
                         
                         target.view.frame = ({
                             CGRect frame = self.view.frame;
                             frame.origin.y = frame.size.height;
                             frame;
                         });
                         
                         [self.peak layoutIfNeeded];
                     }completion:^(BOOL f){
                         self.floatingCheck.hidden = YES;
                         [target.view removeFromSuperview];
                         [target removeFromParentViewController];
                         
                         if( [target isKindOfClass:[CRDeleteController class]] )
                             self.floatingCheck.title = [UIFont mdiCheck];
                         
                     }];
}

- (void)letPark{
    self.yosemite = ({
        CRVisualYosemite *yose = [[CRVisualYosemite alloc] initFromEffectStyle:UIBlurEffectStyleDark];
        [self.view addSubview:yose];
        [yose.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
        [yose.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
        self.yosemiteLayoutGuide = [yose.topAnchor constraintEqualToAnchor:self.view.topAnchor];
        self.yosemiteLayoutGuide.active = YES;
        yose;
    });
    
    self.floatingCheck = ({
        CRVisualFloatingButton *check = [[CRVisualFloatingButton alloc] initFromFont:[UIFont MaterialDesignIconsWithSize:24]
                                                                             title:[UIFont mdiCheck]
                                                                   blurEffectStyle:UIBlurEffectStyleExtraLight];
        [check addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:check];
        [check.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-16].active = YES;
        [check.bottomAnchor constraintEqualToAnchor:self.yosemite.bottomAnchor constant:28].active = YES;
        check.hidden = YES;
        check;
    });
    
//    self.yosemite.nameplate.text = @"ld install a content view controller with a single view.Figure 2-4 shows several screens from the Clock app. The World Clock tab uses a navigation controller primarily so that it can present the buttons it needs to edit the list of clocks. The Stopwatch tab requires only a single screen for its entire interface and therefore uses a single ";
    [self.yosemite.dismissBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
}

- (void)letPeak{
    self.peak = ({
        CRVisualPeak *peak = [[CRVisualPeak alloc] initFromEffectStyle:UIBlurEffectStyleDark];
        peak.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:peak];
        [peak.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
        [peak.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
        self.peakLayoutGuide = [peak.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
        self.peakLayoutGuide.active = YES;
        peak;
    });
    
    [[self.peak btns] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger index, BOOL *sS){
        [btn addTarget:self action:@selector(letPeakAction:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)letPeakAction:(UIButton *)btn{
    NSInteger tag = btn.tag - CR_PEAK_BUTTON_BASIC_TAG;
    
    if( tag == 0 ){
        [self letDelete];
    }
    else if( tag == 1 ){
        self.noteEditable = !self.noteEditable;
        self.peak.notification = [NSString stringWithFormat:@"Note %@", self.noteEditable ? @"unlocked" : @"locked"];
    }
    else if( tag == 2 ){
        [self fontPick];
    }
    else if( tag == 3 ){
        [self.crnote.type isEqualToString:CRNoteTypePhoto] ? [self photoPreview] : [self photoPick];
    }
    else if( tag == 4 ){
        [self colorPick];
    }
    else if( tag == 5 ){
        [self letSave];
    }
    else if( tag == 6 ){
        [self letPaste];
    }
    else if( tag == 7 ){
        [self letCopy];
    }
    else if( tag == 8 ){
        [self.view endEditing:YES];
    }
    else if( tag == 9 ){
        self.peak.notification = nil;
    }
}

- (void)letCopy{
    if( [self.titleBoard isFirstResponder] ){
        [UIPasteboard generalPasteboard].string = self.titleBoard.text;
        self.peak.notification = @"title copied, tap to disappear.";
    }else{
        [UIPasteboard generalPasteboard].string = self.textBoard.text;
        self.peak.notification = @"content copied, tap to disappear.";
    }
}

- (void)letPaste{
    if( ![UIPasteboard generalPasteboard].string ) return;
    
    NSString *pasteString = [UIPasteboard generalPasteboard].string;
    
    if( [self.titleBoard isFirstResponder] ){
        self.titleBoard.text = [NSString stringWithFormat:@"%@%@", self.titleBoard.text, pasteString];
        self.yosemite.nameplate.text = self.titleBoard.text;
        self.peak.notification = @"title pasted, tap to disappear.";
    }else{
        NSString *text = self.textBoard.text;
        self.textBoard.text = [NSString stringWithFormat:@"%@%@%@", [text substringToIndex:self.textBoard.selectedRange.location], pasteString, [text substringFromIndex:self.textBoard.selectedRange.location]];
        self.textBoard.textColor = [UIColor colorWithWhite:17 / 255.0 alpha:1];
        self.peak.notification = @"content pasted, tap to disappear.";
    }
}

- (void)letTextBoard{
    self.textBoard = ({
        UITextView *board = [[UITextView alloc] init];
        board.translatesAutoresizingMaskIntoConstraints = NO;
        board.contentInset = UIEdgeInsetsMake(0, 0, 112, 0);
        board.textContainerInset = UIEdgeInsetsMake(60, 24, 0, 24);
        board.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 52, 0);
        board.textContainer.lineFragmentPadding = 0;
        board.tintColor = [UIColor CRColor:97 :125 :138 :1];
        board.textColor = [UIColor colorWithWhite:109 / 255.0 alpha:1];
        board.text = CRNoteInvalilContent;
        board.delegate = self;
        board;
    });
    
    self.lastPointMark = 0;
    
//    self.textBoard.text = @"controller you choose for each tab should reflect the needs of that particular mode of operation. If you need to present a relatively rich set of data, you could install a navigation controller to manage the navigation through that data. If the data being presented is simpler, you could install a content view controller with a single view.Figure 2-4 shows several screens from the Clock app. The World Clock tab uses a navigation controller primarily so that it can present the buttons it needs to edit the list of clocks. The Stopwatch tab requires only a single screen for its entire interface and therefore uses a single view controller. The Timer tab uses a custom view controller for the main screen and presents an additional view controller modally when the When Timer Ends button is tapped.    The tab bar controller handles all of the interactions associated with presenting the content view controllers, so there is very little you have to do with regard to managing tabs or the view controllers in them. Once displayed, your content view controllers should simply focus on presenting their content.For general information and guidance on defining custom view controllers, see Creating Custom Content View Controllers inListing 2-1 shows the basic code needed to create and install a tab bar controller interface in the main window of your app. This example creates only two tabs, but you could create as many tabs as needed by creating more view controller objects and adding them to the controllers array. You need to replace the custom view controller names MyViewController and MyOtherViewController with classes from your own appom view controller for the main screen and presents an additional view controller modally when the When Timer Ends button is tapped.    The tab bar controller handles all of the interactions associated with presenting the content view controllers, so there is very little you have to do with regard to managing tabs or the view controllers in them. Once displayed, your content view controllers should simply focus on presenting their content.For general information and guidance on defining custom view controllers, see Creating Custom Content View Controllers inListing 2-1 shows the basic code needed to create and install a tab bar controller interface in the main window of your app. This example creates only two tabs, but you could create as many tabs as needed by creating more view controller objects and adding them to the controllers array. You need to replace the custom view controller names MyViewController and MyOtherViewController with classes from your own app";
    
    self.titleBoard = ({
        UITextField *board = [[UITextField alloc] init];
        board.translatesAutoresizingMaskIntoConstraints = NO;
        board.placeholder = CRNoteInvalilTitle;
        board.textColor = [UIColor colorWithWhite:27 / 255 alpha:1];
        board.font = [CRNoteApp appFontOfSize:21 weight:UIFontWeightRegular];
        board.tintColor = [UIColor CRColor:97 :125 :138 :1];
        board.adjustsFontSizeToFitWidth = YES;
        board.minimumFontSize = 14;
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
    if( [self.titleBoard.text isEqualToString:@""] || [self.titleBoard.text isEqualToString:CRNoteInvalilTitle] )
        self.yosemite.nameplate.text = CRNoteInvalilTitle;
    else
        self.yosemite.nameplate.text = self.titleBoard.text;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.peak.notification = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pointY = scrollView.contentOffset.y;
    
    CGFloat offset = self.view.frame.size.height - 52 - STATUS_BAR_HEIGHT - 128 + fabs(self.yosemiteLayoutGuide.constant);
    CGFloat distants = pointY - self.lastPointMark;
    
    BOOL isScrollUp = self.lastPointMark < pointY ? YES : NO;
    
    if( pointY > 0 && pointY < (scrollView.contentSize.height - offset + 1) && self.canAdjust ){
        isScrollUp ? ([self scrollViewDidScrollUp:fabs(distants)]) : ([self scrollviewDidScrollDown:fabs(distants)]);
    }else if( pointY <= 0 && self.canAdjust ){
        self.yosemiteLayoutGuide.constant = 0;
        [self updateYosemiteOpacity];
        [self.yosemite layoutIfNeeded];
    }
    
    self.lastPointMark = pointY;
}

- (void)updateYosemiteOpacity{
    self.yosemite.contentOpacity = fabs(self.yosemiteLayoutGuide.constant) / 128.0;
}

- (void)scrollviewDidScrollDown:(CGFloat)distants{
    if( self.yosemiteLayoutGuide.constant == 0 ) return;
    self.yosemiteLayoutGuide.constant = self.yosemiteLayoutGuide.constant + distants > 0 ? 0 : self.yosemiteLayoutGuide.constant + distants;
    [self updateYosemiteOpacity];
    [self.yosemite layoutIfNeeded];
}

- (void)scrollViewDidScrollUp:(CGFloat)distants{
    if( self.yosemiteLayoutGuide.constant == -128 ) return;
    self.yosemiteLayoutGuide.constant = self.yosemiteLayoutGuide.constant - distants < -128 ? -128 : self.yosemiteLayoutGuide.constant - distants;
    [self updateYosemiteOpacity];
    [self.yosemite layoutIfNeeded];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.yosemiteLayoutGuide.constant = -128;
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:(7 << 16)
                     animations:^{
                         [self.yosemite layoutIfNeeded];
                         [self updateYosemiteOpacity];
                     }completion:nil];
    
    if( [textView.text isEqualToString:CRNoteInvalilContent] ){
        textView.textColor = [UIColor colorWithWhite:17 / 255.0 alpha:1];
        textView.text = @"";
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    self.yosemiteLayoutGuide.constant = 0;
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:(7 << 16)
                     animations:^{
                         [self.yosemite layoutIfNeeded];
                         [self updateYosemiteOpacity];
                     }completion:nil];
    
    NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if( [text isEqualToString:CRNoteInvalilContent] || [text isEqualToString:@""] ){
        textView.textColor = [UIColor colorWithWhite:109 / 255.0 alpha:1];
        textView.text = CRNoteInvalilContent;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.canAdjust = NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.canAdjust = YES;
}

- (void)photoPreview{
    CRPhotoPreviewController *preview = [[CRPhotoPreviewController alloc] initWithImage:self.yosemite.image title:self.titleBoard.text];
    preview.photoDeletedHandler = ^{
        self.crnote.photoAsset = nil;
    };
    [self presentViewController:preview animated:YES completion:nil];
}

- (void)fontPick{
    [self push:({
        CRFontController *picker = [[CRFontController alloc] init];
        picker.themeColor = self.themeColor;
        picker.selectedFontName = self.crnote.fontname;
        picker.selectedFontSize = [self.crnote.fontsize integerValue];
        picker.fontSelectedHandler = ^(NSString *name, NSUInteger size, BOOL unknow){
            
            self.titleBoard.font = [UIFont fontWithName:name size:21];
            self.textBoard.font = [UIFont fontWithName:name size:size];
            self.crnote.fontname = name;
            self.crnote.fontsize = [NSString stringWithFormat:@"%ld", size];
            
        };
        picker;
    })];
}

- (void)colorPick{
    [self push:({
        CRColorPickController *picker = [[CRColorPickController alloc] init];
        picker.currentColorString = self.themeColorString;
        picker.colorSelectedHandler = ^(UIColor *color, NSString *name){
            
            self.themeColorString = self.crnote.colorType = name;
            self.textBoard.tintColor = self.themeColor = color;
            [self.peak.palette setTitleColor:color forState:UIControlStateNormal];
            
        };
        picker;
    })];
}

- (void)photoPick{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    void(^push)(void) = ^{
        CRPHAssetsController *picker = [[CRPHAssetsController alloc] init];
        picker.themeColor = self.themeColor;
        
        picker.PHPreviewHandler = ^(UIImage *priview){
            self.yosemite.image = priview;
        };
        
        picker.PHAssetHandler = ^(PHAsset *photoAsset){
            if( photoAsset )
                self.crnote.photoAsset = photoAsset;
            else{
                [self pop];
                [self.yosemite setImage:nil];
            }
        };
        
        [self push:picker];
    };
    
    if( status == PHAuthorizationStatusAuthorized ){
        
        push();
        
    }else if( status == PHAuthorizationStatusDenied ){
        
        self.peak.notification = PH_AUTHORIZATION_STATUS_DENIED_MESSAGE_STRING;
        
    }else if( status == PHAuthorizationStatusNotDetermined ){
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            push();
        }];
        
    }else if( status == PHAuthorizationStatusRestricted ){
        
        self.peak.notification = @"Library access denied.";
        
    }
}

- (void)letSave{
    
    self.crnote.title = self.titleBoard.text.length > 256 ? [self.textBoard.text substringToIndex:256] : [self.titleBoard.text isEqualToString:@""] ? @"Untitle" : self.titleBoard.text;
    self.crnote.content = self.textBoard.text.length > NSMaximumStringLength ? [self.textBoard.text substringToIndex:NSMaximumStringLength] : self.textBoard.text;
    self.crnote.timeUpdate = [CRNote currentTimeString];
    
    [[CRNoteManager defaultManager] letAsset:self.crnote];
    BOOL save;
    if( [self.crnote.noteID isEqualToString:CRNoteInvalidID] )
        save = [[CRNoteManager defaultManager] letSave];
    else
        save = [[CRNoteManager defaultManager] letUpdate];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)letDelete{
    [[CRNoteManager defaultManager] letAsset:self.crnote];
    [self.floatingCheck setTitle:[UIFont mdiClose]];
    [self push:[CRDeleteController new]];
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
