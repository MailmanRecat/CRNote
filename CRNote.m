//
//  CRNote.m
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRNote.h"
#import "TimeTalkerBird.h"
#import "UIColor+CRTheme.h"

@implementation CRNote

+ (instancetype)defaultNote{
    
    NSString *(^formatStringFromNumber)(NSUInteger) = ^(NSUInteger n){
        return n < 10 ? [NSString stringWithFormat:@"0%ld", n] : [NSString stringWithFormat:@"%ld", n];
    };
    
    NSString *(^timeStringWithComponents)(NSDateComponents *) = ^(NSDateComponents *t){
        return ({
            NSMutableString *string = [[NSMutableString alloc] init];
            [string appendString:formatStringFromNumber(t.year)];
            [string appendString:formatStringFromNumber(t.month)];
            [string appendString:formatStringFromNumber(t.day)];
            [string appendString:formatStringFromNumber(t.hour)];
            [string appendString:formatStringFromNumber(t.minute)];
            (NSString *)string;
        });
    };
    
    NSString *timeString = timeStringWithComponents([TimeTalkerBird currentDate]);
    
    return [[CRNote alloc] initFromDictionary:@{
                                                CRNoteIDString: CRNoteInvalidID,
                                                CRNoteTitleString: CRNoteInvalilTitle,
                                                CRNoteContentString: CRNoteInvalilContent,
                                                CRNoteColorTypeString: CRThemeColorDefault,
                                                CRNoteTimeCreateString: timeString,
                                                CRNoteTimeUpdateString: timeString,
                                                CRNoteTagString: CRNoteInvalilTag,
                                                CRNoteTypeString: CRNoteTypeDefault,
                                                CRNoteFontnameString: CRNoteFontnameDefault,
                                                CRNoteFontsizeString: CRNoteFontsizeDefault,
                                                CRNoteEditableString: CRNoteEditableYes
                                                }];
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if( self ){
        self.noteID = dictionary[CRNoteIDString];
        self.title = dictionary[CRNoteTitleString];
        self.content = dictionary[CRNoteContentString];
        self.colorType = dictionary[CRNoteColorTypeString];
        self.timeCreate = dictionary[CRNoteTimeCreateString];
        self.timeUpdate = dictionary[CRNoteTimeUpdateString];
        self.fontname = dictionary[CRNoteFontnameString];
        self.fontsize = dictionary[CRNoteFontsizeString];
        self.editable = dictionary[CRNoteEditableString];
        self.tag = dictionary[CRNoteTagString];
        self.type = dictionary[CRNoteTypeString];
    }
    return self;
}

@end
