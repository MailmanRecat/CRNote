//
//  CRFontController.m
//  CRNote
//
//  Created by caine on 12/21/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRFontController.h"
#import "CRColorPickCell.h"
#import "CRNoteViewController.h"

@interface CRFontController()<UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) UITableView *craigBear;
@property( nonatomic, strong ) NSIndexPath *craigBearIndexPath;
@property( nonatomic, strong ) NSLayoutConstraint *craigBearGuide;
@property( nonatomic, strong ) UITableView *craigMonkey;
@property( nonatomic, strong ) NSIndexPath *craigMonkeyIndexPath;
@property( nonatomic, strong ) NSLayoutConstraint *craigMonkeyGuide;

@property( nonatomic, strong ) UIView *peak;
@property( nonatomic, strong ) UIButton *peakButtonFontName;
@property( nonatomic, strong ) UIButton *peakButtonFontSize;
@property( nonatomic, assign ) BOOL canMove;

@property( nonatomic, strong ) NSArray *fontnameDataSource;
@property( nonatomic, strong ) NSArray *fontsizeDataSource;

@end

@implementation CRFontController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.themeColor = [UIColor themeColorFromString:CRThemeColorDefault];
    self.canMove = YES;
    
    [self makeCraigBear];
    [self makeCraigMonkey];
    [self makePeak];
    
    [self viewLastLoad];
}

- (void)viewLastLoad{
    self.craigMonkey.hidden = YES;
    self.peakButtonFontName.enabled = NO;
    
    self.fontnameDataSource = @[
                                @"Roboto-Thin",
                                @"Roboto-Light",
                                @"Roboto-Regular",
                                @"Roboto-Medium",
                                @"Roboto-Bold",
                                @"Roboto-Black",
                                @"PingFang TC",
                                @"PingFang HK",
                                @"PingFang SC",
                                @"Helvetica",
                                @"Helvetica Neue",
                                @"Heiti TC",
                                @"Heiti SC",
                                @"Menlo",
                                @"Futura",
                                @"Arial Hebrew",
                                @"chalkboard SE",
                                @"Arial Rounded MT Bold",
                                @"Georgia",
                                @"Times New Roman",
                                @"Thonburi"
                                ];
    
    NSMutableArray *fontsize = [NSMutableArray new];
    for( int i = 12; i < 48; i++ ){
        [fontsize addObject:[NSString stringWithFormat:@"%dpt", i]];
    }
    self.fontsizeDataSource = (NSArray *)fontsize;
}

- (void)viewWillAppear:(BOOL)animated{
    self.craigBearIndexPath = [NSIndexPath indexPathForRow:[self.fontnameDataSource indexOfObject:self.selectedFontName] inSection:0];
    self.craigMonkeyIndexPath = [NSIndexPath indexPathForRow:[self.fontsizeDataSource indexOfObject:[NSString stringWithFormat:@"%ldpt", self.selectedFontSize]]
                                                   inSection:0];
    
    [self.craigBear scrollToRowAtIndexPath:self.craigBearIndexPath
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:NO];
    [self.craigMonkey scrollToRowAtIndexPath:self.craigMonkeyIndexPath
                            atScrollPosition:UITableViewScrollPositionMiddle
                                    animated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.craigBear.backgroundColor = self.craigMonkey.backgroundColor = [UIColor colorWithWhite:237 / 255.0 alpha:1];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    self.craigBear.backgroundColor = self.craigMonkey.backgroundColor = [UIColor clearColor];
}

- (void)makePeak{
    UIButton *(^makeButton)(NSString *, NSUInteger) = ^(NSString *title, NSUInteger tag){
        UIButton *button = [[UIButton alloc] init];
        button.tag = 1000 + tag;
        button.titleLabel.font = [CRNoteApp appFontOfSize:19 weight:UIFontWeightMedium];
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:[UIColor colorWithWhite:59 / 255.0 alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:self.themeColor forState:UIControlStateDisabled];
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
    
    self.peakButtonFontName = makeButton(@"fontname", 0);
    self.peakButtonFontSize = makeButton(@"fontsize", 1);
    
    __block NSLayoutAnchor *anchor = self.peak.leftAnchor;
    [@[ self.peakButtonFontName, self.peakButtonFontSize ]
     enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger index, BOOL *sS){
         obj.translatesAutoresizingMaskIntoConstraints = NO;
         [self.peak addSubview:obj];
         
         [obj.heightAnchor constraintEqualToAnchor:self.peak.heightAnchor].active = YES;
         [obj.widthAnchor constraintEqualToAnchor:self.peak.widthAnchor multiplier:( 1 / 2.0 )].active = YES;
         [obj.centerYAnchor constraintEqualToAnchor:self.peak.centerYAnchor].active = YES;
         [obj.leftAnchor constraintEqualToAnchor:anchor].active = YES;
         anchor = obj.rightAnchor;
     }];
    
    [self.view addSubview:self.peak];
    
    [self.peak.heightAnchor constraintEqualToConstant:52].active = YES;
    [CRLayout view:@[ self.peak, self.view ] type:CREdgeLeft | CREdgeRight | CREdgeBottom];
}

- (void)peakAction:(UIButton *)sender{
    NSUInteger tag = sender.tag - 1000;
    
    if( !self.canMove ) return;
    
    if( tag == 0 )
        [self moveToMonkey:NO];
    else
        [self moveToMonkey:YES];
}

- (void)moveToMonkey:(BOOL)monkey{
    self.canMove = NO;
    
    if( monkey ){
        self.peakButtonFontName.enabled = YES;
        self.craigMonkey.hidden = NO;
        self.craigBearGuide.constant = -self.view.frame.size.width * 0.3;
        self.craigMonkeyGuide.constant = -self.view.frame.size.width;
    }else{
        self.peakButtonFontName.enabled = NO;
        self.craigBear.hidden = NO;
        self.craigBearGuide.constant = self.craigMonkeyGuide.constant = 0;
    }
    
    self.peakButtonFontSize.enabled = !self.peakButtonFontName.enabled;
    
    [UIView animateWithDuration:0.25f
                          delay:0.0 options:(7 << 16)
                     animations:^{
                         [self.view layoutIfNeeded];
                     }completion:^(BOOL f){
                         if( monkey )
                             self.craigBear.hidden = YES;
                         else
                             self.craigMonkey.hidden = YES;
                         
                         self.canMove = YES;
                     }];
    
}

- (void)makeCraigBear{
    self.craigBear = ({
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
    
    [self.view addSubview:self.craigBear];
    [self.craigBear.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.craigBear.heightAnchor constraintEqualToAnchor:self.view.heightAnchor].active = YES;
    [self.craigBear.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    self.craigBearGuide = ({
        NSLayoutConstraint *con = [self.craigBear.leftAnchor constraintEqualToAnchor:self.view.leftAnchor];
        con.active = YES;
        con;
    });
}

- (void)makeCraigMonkey{
    self.craigMonkey = ({
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
    
    [self.view addSubview:self.craigMonkey];
    [self.craigMonkey.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.craigMonkey.heightAnchor constraintEqualToAnchor:self.view.heightAnchor].active = YES;
    [self.craigMonkey.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    self.craigMonkeyGuide = [self.craigMonkey.leftAnchor constraintEqualToAnchor:self.view.rightAnchor];
    self.craigMonkeyGuide.active = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( tableView == self.craigBear )
        return 52.0f;
    else
        return indexPath.row + 42.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if( tableView == self.craigBear )
        return [self.fontnameDataSource count];
    else
        return [self.fontsizeDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ({
        CRColorPickCell *cell = [tableView dequeueReusableCellWithIdentifier:CRColorPickCellID];
        if( cell == nil ){
            cell = [[CRColorPickCell alloc] init];
            cell.dotname.font = [CRNoteApp appFontOfSize:18 weight:UIFontWeightRegular];
            cell.dotname.textColor = [UIColor colorWithWhite:59 / 255.0 alpha:1];
        }
        
        if( tableView == self.craigBear ){
            
            if( indexPath == self.craigBearIndexPath )
                [cell statusON];
            else
                [cell statusOFF];
            
            cell.dotname.text = self.fontnameDataSource[indexPath.row];
            cell.dotname.font = [UIFont fontWithName:cell.dotname.text size:21];
            cell.dot.textColor = self.themeColor;
        }else{
            
            if( indexPath == self.craigMonkeyIndexPath )
                [cell statusON];
            else
                [cell statusOFF];
            
            cell.dotname.text = self.fontsizeDataSource[indexPath.row];
            cell.dotname.font = [UIFont fontWithName:self.selectedFontName size:indexPath.row + 12];
            cell.dot.textColor = self.themeColor;
        }
        
        cell;
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CRColorPickCell *cell;
    if( tableView == self.craigBear ){
        cell = [tableView cellForRowAtIndexPath:self.craigBearIndexPath];
        [cell statusOFF];
        
        self.craigBearIndexPath = indexPath;
        
        cell = [tableView cellForRowAtIndexPath:self.craigBearIndexPath];
        [cell statusON];
        
        self.selectedFontName = self.fontnameDataSource[indexPath.row];
        [self.craigMonkey reloadData];
    }else{
        cell = [tableView cellForRowAtIndexPath:self.craigMonkeyIndexPath];
        [cell statusOFF];
        
        self.craigMonkeyIndexPath = indexPath;
        
        cell = [tableView cellForRowAtIndexPath:self.craigMonkeyIndexPath];
        [cell statusON];
        
        self.selectedFontSize = indexPath.row + 12;
    }
    
    if( self.fontSelectedHandler ){
        self.fontSelectedHandler( self.selectedFontName, self.selectedFontSize, NO );
    }
}

@end
