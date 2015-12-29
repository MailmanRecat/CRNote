//
//  CRNoteViewController.m
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define CR_USER_LIBRARY_DENEY @"library access denied, tap to setting."

#import "CRNoteDatabase.h"
#import "CRNoteViewController.h"
#import "CRColorPickController.h"
#import "GGAnimationSunrise.h"
#import "CRFontController.h"
#import "CRPhotoPreviewController.h"
#import "CRPHAssetsController.h"

#import "CRPark.h"
#import "CRPeak.h"

static NSString *const PH_AUTHORIZATION_STATUS_DENIED_MESSAGE_STRING = @"Library access denied, tap to setting.";

@interface CRNoteViewController()<UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>

@property( nonatomic, strong ) GGAnimationSunrise *sun;

@property( nonatomic, assign ) BOOL noteEditable;

@property( nonatomic, strong ) CRPark *yosemite;
@property( nonatomic, strong ) NSLayoutConstraint *yosemiteLayoutGuide;
@property( nonatomic, assign ) CGFloat yosemiteLayoutConstant;
@property( nonatomic, strong ) UIButton *floatingBtn;
@property( nonatomic, assign ) BOOL floatingHidden;

@property( nonatomic, strong ) CRPeak *peak;
@property( nonatomic, strong ) NSLayoutConstraint *peakLayoutGuide;


@property( nonatomic, strong ) UIButton *floatingActionCheck;

@property( nonatomic, strong ) UITextView *textBoard;
@property( nonatomic, strong ) UITextField *titleBoard;
@property( nonatomic, assign ) CGFloat lastPointMark;

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

- (void)setFloatingHidden:(BOOL)floatingHidden{
    if( _floatingHidden == floatingHidden ) return;
    _floatingHidden = floatingHidden;
    
    if( _floatingHidden ){
        self.floatingBtn.alpha = 0;
        self.floatingBtn.transform = CGAffineTransformMakeScale(0.3, 0.3);
    }else{
        self.floatingBtn.hidden = NO;
        self.floatingBtn.transform = CGAffineTransformMakeScale(1, 1);
        self.floatingBtn.alpha = 1;
    }
}

- (void)setYosemiteLayoutConstant:(CGFloat)yosemiteLayoutConstant{
    self.yosemiteLayoutGuide.constant = yosemiteLayoutConstant;
    self.yosemite.nameplateOpacity = fabs(self.yosemiteLayoutGuide.constant) / 128.0;
    
    [self.yosemite layoutIfNeeded];
}

-(NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    UIPreviewAction *deleteAction = [UIPreviewAction actionWithTitle:@"Delete" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewController) {
        
        if( self.crnoteDeleteActionHandler )
            self.crnoteDeleteActionHandler( action.title );
        
    }];

    UIPreviewAction *cancel = [UIPreviewAction actionWithTitle:@"Cancel" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewController){
        
        if( self.crnoteDeleteActionHandler )
            self.crnoteDeleteActionHandler( action.title );
            
    }];
    
    UIPreviewActionGroup *delete = [UIPreviewActionGroup actionGroupWithTitle:@"Delete" style:UIPreviewActionStyleDestructive actions:@[ deleteAction, cancel ]];
    
    return @[ delete ];
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
//    [self makePark];
//    [self makePeak];
    [self letPark];
    [self letPeak];
    
    [self addNotificationObserver];
    [self viewLastLoad];
}

- (void)viewLastLoad{
    
    [self.textBoard.topAnchor constraintEqualToAnchor:self.yosemite.bottomAnchor].active = YES;
    [self.textBoard.bottomAnchor constraintEqualToAnchor:self.peak.bottomAnchor].active = YES;
    
    if( [self.crnote.type isEqualToString:CRNoteTypePhoto] )
        self.yosemite.image = [[CRPhotoManager defaultManager] photoFromPhotoname:self.crnote.imageName];
    
    if( self.crnote.editable == CRNoteEditableYes )
        self.noteEditable = YES;
    else
        self.noteEditable = NO;
    
    self.textBoard.font = [UIFont fontWithName:self.crnote.fontname size:[self.crnote.fontsize integerValue]];
    
    if( ![self.crnote.title isEqualToString:CRNoteInvalilTitle] )
        self.titleBoard.text = self.crnote.title;
    
//    self.textBoard.text = self.crnote.content;
    self.textBoard.tintColor = self.themeColor;
    
    self.textBoard.textColor =
    ([self.textBoard.text isEqualToString:@""] || [self.textBoard.text isEqualToString:CRNoteInvalilContent]) ?
    [UIColor colorWithWhite:109 / 255.0 alpha:1] : [UIColor colorWithWhite:17 / 255.0 alpha:1];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if( self.isPreview ){
        self.dismissButton.hidden = YES;
        self.peak.hidden = YES;
    }else{
        self.dismissButton.hidden = NO;
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
                         [self.peak layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)viewEndEdit{
    [self.view endEditing:YES];
}

- (void)push:(UIViewController *)viewController{
    self.canAdjust = NO;
    [self parkSunset];
    [self addChildViewController:viewController];
    
    viewController.view.frame = ({
        CGRect frame = self.view.frame;
        frame.origin.y = frame.size.height;
        frame;
    });
    
    self.yosemiteLayoutConstant = 0;
    self.peakLayoutGuide.constant = CR_PEAK_HEIGHT;
    
    self.floatingActionCheck.enabled = YES;
    self.floatingActionCheck.hidden = NO;
    self.floatingActionCheck.transform = CGAffineTransformMakeScale(0, 0);
    [self.view insertSubview:viewController.view belowSubview:self.park];
    [UIView animateWithDuration:0.4f
                          delay:0.0f options:( 7 << 16 )
                     animations:^{
                         self.floatingActionCheck.transform = CGAffineTransformMakeScale(1, 1);
                         viewController.view.frame = self.view.frame;
                         
                         [self.peak layoutIfNeeded];
                     }completion:^(BOOL f){
                         self.textBoard.hidden = YES;
                     }];
}

- (void)pop{
    self.canAdjust = YES;
    [self parkSunrise];
    UIViewController *target = self.childViewControllers.firstObject;
    self.textBoard.hidden = NO;
    self.peakLayoutGuide.constant = 0;
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
    
    self.themeColorString = self.crnote.colorType = string;
    self.textBoard.tintColor = self.themeColor = color;
    [self.floatingActionCheck setTitleColor:color forState:UIControlStateNormal];
}

- (void)updateNoteFont:(NSString *)name size:(NSUInteger)size{
    self.textBoard.font = [UIFont fontWithName:name size:size];
    self.crnote.fontname = name;
    self.crnote.fontsize = [NSString stringWithFormat:@"%ld", size];
}

- (void)letCopy{
    [UIPasteboard generalPasteboard].string = self.textBoard.text;
    self.peak.notification = @"content copied, tap to disappear.";
}

- (void)letPaste{
    self.textBoard.text = [UIPasteboard generalPasteboard].string;
    self.textBoard.textColor = [UIColor colorWithWhite:17 / 255.0 alpha:1];
    self.peak.notification = @"content pasted, tap to disappear.";
}

- (void)parkSunset{
    self.park.layer.shadowOpacity = 0.27;
}

- (void)parkSunrise{
    self.park.layer.shadowOpacity = 0;
}

- (void)foldPark:(BOOL)fold{
//    if( fold )
//        [self foldParkDistants:-128];
//    else
//        [self foldParkDistants:0];
}

//- (void)foldParkDistants:(CGFloat)distants{
//    self.parkGuide.constant = distants;
//    
//    CGFloat alpha = 1 - (fabs(distants) / 128.0);
//    
//    if( distants == -128 )
//        [self parkSunset];
//    else
//        [self parkSunrise];
//    
//    [UIView animateWithDuration:0.25f
//                          delay:0.0f options:(7 << 16)
//                     animations:^{
//                         
//                         self.parkTitle.alpha = alpha;
//                         [self.view layoutIfNeeded];
//                         
//                     }completion:nil];
//}

- (void)letPark{
    self.yosemite = ({
        CRPark *yose = [[CRPark alloc] initFromColor:self.themeColor];
        [yose setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addSubview:yose];
        [yose.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
        [yose.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
        [yose.heightAnchor constraintEqualToConstant:STATUS_BAR_HEIGHT + 128.0f].active = YES;
        self.yosemiteLayoutGuide = [yose.topAnchor constraintEqualToAnchor:self.view.topAnchor];
        self.yosemiteLayoutGuide.active = YES;
        self.yosemiteLayoutConstant = 0;
        yose;
    });
    
    self.floatingBtn = ({
        UIButton *floating = [[UIButton alloc] init];
        floating.translatesAutoresizingMaskIntoConstraints = NO;
        floating.backgroundColor = [UIColor whiteColor];
        floating.titleLabel.font = [UIFont MaterialDesignIconsWithSize:24];
        [self.view addSubview:floating];
        [floating.rightAnchor constraintEqualToAnchor:self.yosemite.rightAnchor constant:-16].active = YES;
        [floating.bottomAnchor constraintEqualToAnchor:self.yosemite.bottomAnchor constant:28].active = YES;
        [floating.heightAnchor constraintEqualToAnchor:floating.widthAnchor].active = YES;
        [floating.widthAnchor constraintEqualToConstant:56.0f].active = YES;
        [floating makeShadowWithSize:CGSizeMake(0.0f, 1.7f) opacity:0.3f radius:1.7f];
        [floating setTitle:[UIFont mdiCheck] forState:UIControlStateNormal];
        [floating setTitleColor:self.themeColor forState:UIControlStateNormal];
        [floating addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        floating;
    });
    
    self.yosemite.nameplate.text = @"ld install a content view controller with a single view.Figure 2-4 shows several screens from the Clock app. The World Clock tab uses a navigation controller primarily so that it can present the buttons it needs to edit the list of clocks. The Stopwatch tab requires only a single screen for its entire interface and therefore uses a single ";
    [self.yosemite.dismissBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    
    self.floatingBtn.hidden = YES;
//    self.yosemite.image = [[CRPhotoManager defaultManager] photoFromPhotoname:self.crnote.imageName];
}

- (void)letPeak{
    self.peak = ({
        CRPeak *peak = [[CRPeak alloc] init];
        [peak setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addSubview:peak];
        [peak makeShadowWithSize:CGSizeMake(0, -1) opacity:0.17 radius:3];
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
        
    }else if( tag == 1 ){
        self.noteEditable = !self.noteEditable;
    }else if( tag == 2 ){
        [self fontPick];
    }else if( tag == 3 ){
        self.crnote.type == CRNoteTypePhoto ? [self photoPreview] : [self photoPick];
    }else if( tag == 4 ){
        [self colorPick];
    }else if( tag == 5 ){
        
    }else if( tag == 6 ){
        [self letPaste];
    }else if( tag == 7 ){
        [self letCopy];
    }else if( tag == 8 ){
        [self.view endEditing:YES];
    }else if( tag == 9 ){
        self.peak.notification = nil;
    }
}

- (void)letTextBoard{
    self.textBoard = ({
        UITextView *board = [[UITextView alloc] init];
        board.translatesAutoresizingMaskIntoConstraints = NO;
        board.contentInset = UIEdgeInsetsMake(0, 0, 108, 0);
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
    
    self.textBoard.text = @"controller you choose for each tab should reflect the needs of that particular mode of operation. If you need to present a relatively rich set of data, you could install a navigation controller to manage the navigation through that data. If the data being presented is simpler, you could install a content view controller with a single view.Figure 2-4 shows several screens from the Clock app. The World Clock tab uses a navigation controller primarily so that it can present the buttons it needs to edit the list of clocks. The Stopwatch tab requires only a single screen for its entire interface and therefore uses a single view controller. The Timer tab uses a custom view controller for the main screen and presents an additional view controller modally when the When Timer Ends button is tapped.    The tab bar controller handles all of the interactions associated with presenting the content view controllers, so there is very little you have to do with regard to managing tabs or the view controllers in them. Once displayed, your content view controllers should simply focus on presenting their content.For general information and guidance on defining custom view controllers, see Creating Custom Content View Controllers inListing 2-1 shows the basic code needed to create and install a tab bar controller interface in the main window of your app. This example creates only two tabs, but you could create as many tabs as needed by creating more view controller objects and adding them to the controllers array. You need to replace the custom view controller names MyViewController and MyOtherViewController with classes from your own app";
    
    self.titleBoard = ({
        UITextField *board = [[UITextField alloc] init];
        board.translatesAutoresizingMaskIntoConstraints = NO;
        board.placeholder = CRNoteInvalilTitle;
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
    if( [self.titleBoard.text isEqualToString:@""] || [self.titleBoard.text isEqualToString:CRNoteInvalilTitle] )
        self.yosemite.nameplate.text = CRNoteInvalilTitle;
    else
        self.yosemite.nameplate.text = self.titleBoard.text;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    if( self.peakGuide.constant == 0 )
//        [self peakLayout:NO autoLayout:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pointY = scrollView.contentOffset.y;
    
    BOOL shouldLayout = NO, isScrollUp = NO;
    CGFloat offset = self.view.frame.size.height - 52 - STATUS_BAR_HEIGHT - 128 + fabs(self.yosemiteLayoutConstant);
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
    if( self.yosemiteLayoutConstant == 0 ) return;
    self.yosemiteLayoutConstant = self.yosemiteLayoutConstant + distants > 0 ? 0 : self.yosemiteLayoutConstant + distants;
}

- (void)scrollViewDidScrollUp:(CGFloat)distants{
    if( self.yosemiteLayoutConstant == -128 ) return;
    self.yosemiteLayoutConstant = self.yosemiteLayoutConstant - distants < -128 ? -128 : self.yosemiteLayoutConstant - distants;
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

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.canAdjust = NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.canAdjust = YES;
}

- (void)photoPreview{
    
    CRPhotoPreviewController *preview = [[CRPhotoPreviewController alloc] initWithImage:self.yosemite.image title:self.titleBoard.text];
    preview.photoDeletedHandler = ^{
//        self.parkBear.image = nil;
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
            [self updateNoteFont:name size:size];
        };
        picker;
    })];
}

- (void)colorPick{
    [self push:({
        CRColorPickController *picker = [[CRColorPickController alloc] init];
        picker.currentColorString = self.themeColorString;
        picker.colorSelectedHandler = ^(UIColor *color, NSString *name){
            [self updateThemeColor:color string:name];
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
//            self.parkBear.image = priview;
        };
        
        picker.PHAssetHandler = ^(PHAsset *photoAsset){
            NSLog(@"%@", photoAsset);
            if( photoAsset )
                self.crnote.photoAsset = photoAsset;
            else{
                [self pop];
//                [self.parkBear setImage:nil];
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
    
    self.crnote.content = self.textBoard.text;
    self.crnote.timeUpdate = [CRNote currentTimeString];
    
    BOOL save;
    if( [self.crnote.noteID isEqualToString:CRNoteInvalidID] )
        save = [CRNoteDatabase insertNote:self.crnote];
    else
        save = [CRNoteDatabase updateNote:self.crnote];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
