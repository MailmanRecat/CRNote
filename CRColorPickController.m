//
//  CRColorPickController.m
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRColorPickController.h"
#import "UIColor+CRTheme.h"
#import "CRColorPickCell.h"
#import "CRNoteApp.h"

#import "CRNoteViewController.h"

@interface CRColorPickController()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property( nonatomic, strong ) NSArray *colorsname;
@property( nonatomic, strong ) UILabel *nameplate;
@property( nonatomic, strong ) UILabel *option;

@property( nonatomic, strong ) UITableView *craigBear;
@property( nonatomic, strong ) NSIndexPath *craigIndexPath;

@end

@implementation CRColorPickController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.colorsname = [UIColor themeColorname];
    self.colors = [UIColor themeColors];
    
    [self makeCraigBear];
//    [self makePark];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if( !self.currentColorString )
        self.currentColorString = CRThemeColorDefault;
    
    if( !self.themeColor )
        self.themeColor = self.colors[CRThemeColorDefault];
    
    self.park.backgroundColor = self.themeColor;
    self.craigIndexPath = [NSIndexPath indexPathForRow:[self.colorsname indexOfObject:self.currentColorString] inSection:0];
    [self.craigBear selectRowAtIndexPath:self.craigIndexPath
                                animated:NO
                          scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.craigBear.backgroundColor = [UIColor colorWithWhite:237 / 255.0 alpha:1];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    self.craigBear.backgroundColor = [UIColor clearColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)makePark{
    self.park = ({
        UIView *park = [[UIView alloc] init];
        park.translatesAutoresizingMaskIntoConstraints = NO;
        park;
    });
    
    [self.view addSubview:self.park];
    [CRLayout view:@[ self.park, self.view ] type:CREdgeTop | CREdgeLeft | CREdgeRight];
    [self.park.heightAnchor constraintEqualToConstant:STATUS_BAR_HEIGHT + 56 + 72].active = YES;
}

- (void)makeCraigBear{
    self.craigBear = ({
        UITableView *bear = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        bear.translatesAutoresizingMaskIntoConstraints = NO;
        bear.sectionFooterHeight = 0.0f;
        bear.sectionHeaderHeight = 0.0f;
        bear.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 56 + 72, 0, 0, 0);
        bear.contentOffset = CGPointMake(0, -(56 + STATUS_BAR_HEIGHT + 72));
        bear.showsHorizontalScrollIndicator = bear.showsVerticalScrollIndicator = NO;
        bear.backgroundColor = [UIColor clearColor];
        bear.separatorStyle = UITableViewCellSeparatorStyleNone;
        bear.delegate = self;
        bear.dataSource = self;
        bear;
    });
    
    [self.view addSubview:self.craigBear];
    [CRLayout view:@[ self.craigBear, self.view ] type:CREdgeAround];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.colorsname count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ({
        CRColorPickCell *cell = [tableView dequeueReusableCellWithIdentifier:CRColorPickCellID];
        if( cell == nil ){
            cell = [[CRColorPickCell alloc] init];
            cell.dotname.font = [CRNoteApp appFontOfSize:18 weight:UIFontWeightRegular];
            cell.dotname.textColor = [UIColor colorWithWhite:59 / 255.0 alpha:1];
        }
        
        if( indexPath == self.craigIndexPath )
            [cell statusON];
        else
            [cell statusOFF];
        
        cell.dotname.text = self.colorsname[indexPath.row];
        cell.dot.textColor = self.colors[cell.dotname.text];
        
        cell;
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CRColorPickCell *cell;
    cell = [tableView cellForRowAtIndexPath:self.craigIndexPath];
    [cell statusOFF];
    
    self.craigIndexPath = indexPath;
    
    cell = [tableView cellForRowAtIndexPath:self.craigIndexPath];
    [cell statusON];
    
    self.selectedColor = cell.dot.textColor;
    self.selectedColorname = cell.dotname.text;
    
    CRNoteViewController *notevc = (CRNoteViewController *)self.parentViewController;
    [notevc updateThemeColor:self.selectedColor string:self.selectedColorname];
}

@end
