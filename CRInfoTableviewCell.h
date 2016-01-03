//
//  CRInfoTableviewCell.h
//  CRClassSchedule
//
//  Created by caine on 12/17/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const CRInfoTableViewCellID = @"CR_INFO_TABLEVIEW_CELL_ID";

@interface CRInfoTableviewCell : UITableViewCell

@property( nonatomic, strong ) UILabel *subLabel;
@property( nonatomic, strong ) UILabel *maiLabel;

- (void)makeBorder:(BOOL)hidden;

@end
