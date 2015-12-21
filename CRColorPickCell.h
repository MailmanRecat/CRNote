//
//  CRColorPickCell.h
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const CRColorPickCellID = @"CR_COLOR_PICK_CELL_ID";

@interface CRColorPickCell : UITableViewCell

@property( nonatomic, strong ) UILabel *dotname;
@property( nonatomic, strong ) UILabel *dot;

- (void)statusON;
- (void)statusOFF;

@end
