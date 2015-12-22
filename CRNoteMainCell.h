//
//  CRNoteMainCell.h
//  CRNote
//
//  Created by caine on 12/21/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const CRNoteImageCell = @"CR_NOTE_IMAGE_CELL";
static NSString *const CRNoteImageCellGuide = @"CR_NOTE_IMAGE_CELL_GUIDE";

@interface CRNoteMainCell : UITableViewCell

@property( nonatomic, strong ) UIView *wrapper;
@property( nonatomic, strong ) UILabel *timeTag;
@property( nonatomic, strong ) UILabel *notetitle;
@property( nonatomic, strong ) UILabel *subtitle;
@property( nonatomic, strong ) UIImageView *crimageview;
@property( nonatomic, strong ) NSLayoutConstraint *crimageviewGuide;


- (instancetype)initWithColorString:(NSString *)color;
- (instancetype)initWithType:(NSString *)type;

@end
