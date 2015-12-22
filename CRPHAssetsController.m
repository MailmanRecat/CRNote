//
//  CRPHAssetsController.m
//  CRNote
//
//  Created by caine on 12/22/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <Photos/Photos.h>
#import "CRPHAssetsController.h"
#import "CRPHAssetsCell.h"
#import "CRNoteViewController.h"

@interface CRPHAssetsController()<UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) UIButton *cancelButton;
@property( nonatomic, strong ) UITableView *crBear;

@property( nonatomic, strong ) PHFetchResult *PHResult;

@property( nonatomic, assign ) CGFloat heightOfCell;
@property( nonatomic, strong ) NSIndexPath *crindexPath;

@end

@implementation CRPHAssetsController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.heightOfCell = STATUS_BAR_HEIGHT + 56 + 72;
    
    PHFetchOptions *PHO = [[PHFetchOptions alloc] init];
    PHO.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    self.PHResult = [PHAsset fetchAssetsWithOptions:PHO];
    
    [self makeCRBear];
    [self makeCancelButton];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.crBear.backgroundColor = [UIColor colorWithWhite:237 / 255.0 alpha:1];
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
        [cancel addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        cancel;
    });
    
    [self.view addSubview:self.cancelButton];
    [self.cancelButton.heightAnchor constraintEqualToConstant:52].active = YES;
    [CRLayout view:@[self.cancelButton, self.view] type:CREdgeLeft | CREdgeBottom | CREdgeRight];
}

- (void)makeCRBear{
    self.crBear = ({
        UITableView *bear = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        bear.translatesAutoresizingMaskIntoConstraints = NO;
        bear.sectionFooterHeight = 0.0f;
        bear.sectionHeaderHeight = 0.0f;
        bear.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 56 + 72, 0, 52, 0);
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
            [PHC statusON];
        else
            [PHC statusOFF];
        
        [[PHImageManager defaultManager] requestImageForAsset:[self.PHResult objectAtIndex:indexPath.row]
                                                   targetSize:CGSizeMake(self.view.frame.size.width, self.heightOfCell)
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
    
    CRPHAssetsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell statusON];
    
    if( self.crindexPath ){
        cell = [tableView cellForRowAtIndexPath:self.crindexPath];
        [cell statusOFF];
    }
    
    self.crindexPath = indexPath;
    
    if( [self.parentViewController isKindOfClass:[CRNoteViewController class]] ){
        CRNoteViewController *notevc = (CRNoteViewController *)self.parentViewController;
        [[PHImageManager defaultManager] requestImageForAsset:[self.PHResult objectAtIndex:indexPath.row]
                                                   targetSize:PHImageManagerMaximumSize
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:nil
                                                resultHandler:^(UIImage *image, NSDictionary *info){
                                                    [notevc updateNoteCover:image];
                                                }];
    }
}

- (void)dismissSelf{
    NSLog(@"dismiss");
}

@end
