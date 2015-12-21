//
//  TimeTalkerBird.m
//  dome12715
//
//  Created by caine on 7/14/15.
//  Copyright (c) 2015 com.caine. All rights reserved.
//

#import "TimeTalkerBird.h"

@implementation TimeTalkerBird

+ (NSDateComponents *)currentDate{
    
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear |
                             NSCalendarUnitMonth |
                             NSCalendarUnitWeekOfMonth |
                             NSCalendarUnitWeekOfYear |
                             NSCalendarUnitWeekday |
                             NSCalendarUnitDay |
                             NSCalendarUnitHour |
                             NSCalendarUnitMinute |
                             NSCalendarUnitSecond
                             
                                                            fromDate:[NSDate date]];
}

+ (NSUInteger)numberOfDaysInMouth:(NSUInteger)month year:(NSUInteger)year{
    
    NSDateComponents *typer = [NSDateComponents new];
    typer.month = month;
    typer.year  = year;
    
    NSRange duck = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                                      inUnit:NSCalendarUnitMonth
                                                     forDate:[[NSCalendar currentCalendar] dateFromComponents:typer]];
    
    return duck.length;
}

+ (NSInteger)firstWeekdayInMonth:(NSUInteger)month year:(NSUInteger)year{
    
    NSDateComponents *typer  = [NSDateComponents new];
    typer.day   = 1;
    typer.month = month;
    typer.year  = year;
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:typer];
    NSDateComponents *time = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday
                                                             fromDate:date];
    return time.weekday;
}

@end
