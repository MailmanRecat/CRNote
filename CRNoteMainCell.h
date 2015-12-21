//
//  CRNoteMainCell.h
//  CRNote
//
//  Created by caine on 12/21/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRNoteMainCell : UITableViewCell

@property( nonatomic, strong ) UIView *wrapper;
@property( nonatomic, strong ) UILabel *notetitle;
@property( nonatomic, strong ) UILabel *subtitle;

- (instancetype)initWithColorString:(NSString *)color;

@end
