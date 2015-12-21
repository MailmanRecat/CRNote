//
//  TimeTalkerBird.h
//  dome12715
//
//  Created by caine on 7/14/15.
//  Copyright (c) 2015 com.caine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTalkerBird : NSObject

+ (NSDateComponents *)currentDate;
+ (NSUInteger)numberOfDaysInMouth:(NSUInteger)month year:(NSUInteger)year;
+ (NSInteger)firstWeekdayInMonth:(NSUInteger)month year:(NSUInteger)year;

@end
