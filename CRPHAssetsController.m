//
//  CRPHAssetsController.m
//  CRNote
//
//  Created by caine on 12/22/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define CGSize_iphone4_X( s )  CGSizeMake(320 * s, 148 * s);
#define CGSize_iphone5_X( s )  CGSizeMake(320 * s, 148 * s);
#define CGSize_iphone6_X( s )  CGSizeMake(375 * s, 148 * s);
#define CGSize_iphone6s_X( s ) CGSizeMake(414 * (s + 1), 148 * (s + 1));

#import "CRPHAssetsController.h"
#import "CRPHAssetsCell.h"
#import "CRNoteViewController.h"
#import "CRPHAssetsPreviewController.h"

@interface CRPHAssetsController()<UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate>

@property( nonatomic, strong ) UIButton *cancelButton;
@property( nonatomic, strong ) UITableView *crBear;

@property( nonatomic, strong ) PHFetchResult *PHResult;

@property( nonatomic, assign ) CGSize  targetSize;
@property( nonatomic, assign ) CGFloat heightOfCell;

@property( nonatomic, strong ) CRPHAssetsCell *crcell;
@property( nonatomic, strong ) NSIndexPath *crindexPath;

@end

@implementation CRPHAssetsController

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    
    NSIndexPath *indexPath = [self.crBear indexPathForRowAtPoint:location];
    if( !indexPath ) return nil;
    
    CRPHAssetsCell *CRPHC = [self.crBear cellForRowAtIndexPath:indexPath];
    previewingContext.sourceRect = CRPHC.frame;
    
    return ({
        PHAsset *asset = self.PHResult[indexPath.row];
        CRPHAssetsPreviewController *previewvc = [[CRPHAssetsPreviewController alloc] initWithImage:CRPHC.crimagev.image];
        previewvc.preferredContentSize = CGSizeMake(asset.pixelWidth * 0.5, asset.pixelHeight * 0.5);
        previewvc;
    });
}

- (void)check3DTouch{
    BOOL support3DTouch = YES;
    
    if( self.traitCollection.forceTouchCapability != UIForceTouchCapabilityAvailable ) support3DTouch = NO;
    if( ![self.traitCollection respondsToSelector:@selector(forceTouchCapability)] ) support3DTouch = NO;
    
    if( support3DTouch )
        [self registerForPreviewingWithDelegate:self sourceView:self.crBear];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.heightOfCell = STATUS_BAR_HEIGHT + 56 + 72;
    
    PHFetchOptions *PHO = [[PHFetchOptions alloc] init];
    PHO.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    self.PHResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:PHO];
    
    [self makeCRBear];
    [self makeCancelButton];
    [self check3DTouch];
    
    if( self.view.frame.size.width == 320 ){
        self.targetSize = CGSize_iphone5_X(2)
    }else if( self.view.frame.size.width == 375 ){
        self.targetSize = CGSize_iphone6_X(2)
    }else if( self.view.frame.size.width == 414 ){
        self.targetSize = CGSize_iphone6s_X(2)
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.crBear.backgroundColor = [UIColor colorWithWhite:237 / 255.0 alpha:1];
}

- (void)viewWillDisappear:(BOOL)animated{
    if( self.PHPhotoHandler && self.crcell ){
        __block NSData *photo;
        [[PHImageManager defaultManager] requestImageDataForAsset:[self.PHResult objectAtIndex:self.crindexPath.row]
                                                          options:nil
                                                    resultHandler:
         ^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info){
             CGFloat size = imageData.length / 1024 / 1024.0;
             if( size > 2.6 ){
                 imageData = UIImageJPEGRepresentation([UIImage imageWithData:imageData], 2.6 / size);
             }
             photo = imageData;
             
             NSData *thumbnail = UIImageJPEGRepresentation(self.crcell.crimagev.image, 0.1);
             self.PHPhotoHandler(photo, thumbnail, NO);
         }];
    }
}

- (void)makeCancelButton{
    self.cancelButton = ({
        UIButton *cancel = [[UIButton alloc] init];
        cancel.translatesAutoresizingMaskIntoConstraints = NO;
        cancel.backgroundColor = [UIColor whiteColor];
        cancel.titleLabel.font = [CRNoteApp appFontOfSize:19 weight:UIFontWeightMedium];
        [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor colorWithWhite:59 / 255.0 alpha:1] forState:UIControlStateNormal];
        [cancel makeShadowWithSize:CGSizeMake(0, -1) opacity:0.17 radius:3];
        [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        cancel;
    });
    
    [self.view addSubview:self.cancelButton];
    [self.cancelButton.heightAnchor constraintEqualToConstant:52].active = YES;
    [CRLayout view:@[self.cancelButton, self.view] type:CREdgeLeft | CREdgeBottom | CREdgeRight];
}

- (void)cancel{
    self.crcell = nil;
    if( self.PHPhotoHandler )
        self.PHPhotoHandler(nil, nil, YES);
}

- (void)makeCRBear{
    self.crBear = ({
        UITableView *bear = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        bear.translatesAutoresizingMaskIntoConstraints = NO;
        bear.sectionFooterHeight = 0.0f;
        bear.sectionHeaderHeight = 0.0f;
        bear.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 56 + 72 - 2, 0, 52, 0);
        bear.contentOffset = CGPointMake(0, -(56 + STATUS_BAR_HEIGHT + 72));
        bear.showsHorizontalScrollIndicator = bear.showsVerticalScrollIndicator = NO;
        bear.backgroundColor = [UIColor clearColor];
        bear.separatorStyle = UITableViewCellSeparatorStyleNone;
        bear.delegate = self;
        bear.dataSource = self;
        bear;
    });
    
    [self.view addSubview:self.crBear];
    [CRLayout view:@[ self.crBear, self.view ] type:CREdgeAround];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.heightOfCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.PHResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ({
        CRPHAssetsCell *PHC = [tableView dequeueReusableCellWithIdentifier:CR_PH_ASSETS_CELL_ID];
        if( PHC == nil ){
            PHC = [[CRPHAssetsCell alloc] init];
            PHC.dot.textColor = self.themeColor;
        }
        
        if( indexPath == self.crindexPath )
            PHC.checked = YES;
        else
            PHC.checked = NO;
        
        [[PHImageManager defaultManager] requestImageForAsset:[self.PHResult objectAtIndex:indexPath.row]
                                                   targetSize:self.targetSize
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:nil
                                                resultHandler:^(UIImage *image, NSDictionary *info){
                                                    PHC.crimagev.image = image;
                                                }];
        
        PHC;
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if( indexPath == self.crindexPath )
        return;
    
    CRPHAssetsCell *cell;
    if( self.crindexPath ){
        cell = [tableView cellForRowAtIndexPath:self.crindexPath];
        cell.checked = NO;
    }
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.checked = YES;
    
    self.crcell = cell;
    self.crindexPath = indexPath;
    
    if( self.PHPreviewHandler ){
        self.PHPreviewHandler( cell.crimagev.image );
    }
}

@end
