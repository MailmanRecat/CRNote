//
//  CRPHAssetsCell.h
//  CRNote
//
//  Created by caine on 12/22/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const CR_PH_ASSETS_CELL_ID = @"CR_PH_ASSETS_CELL_ID";

@interface CRPHAssetsCell : UITableViewCell

@property( nonatomic, strong ) UIImageView *crimagev;
@property( nonatomic, strong ) UILabel *dot;
@property( nonatomic, assign ) BOOL checked;

@end
