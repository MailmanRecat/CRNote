//
//  CRNote.m
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define k_CONTENT_PREVIEW_LEN 150

#import "CRNote.h"
#import "TimeTalkerBird.h"
#import "UIColor+CRTheme.h"

@implementation CRNote

+ (instancetype)defaultNote{
    
    NSString *timeString = [CRNote currentTimeString];
    
    return [[CRNote alloc] initFromDictionary:@{
                                                CRNoteIDString: CRNoteInvalidID,
                                                CRNoteTitleString: CRNoteInvalilTitle,
                                                CRNoteContentString: CRNoteInvalilContent,
                                                CRNoteContentPreviewString: CRNoteInvalidContentPreview,
                                                CRNoteColorTypeString: CRThemeColorDefault,
                                                CRNoteImageNameString: CRNoteInvalilImageName,
                                                CRNoteTimeCreateString: timeString,
                                                CRNoteTimeUpdateString: timeString,
                                                CRNoteTagString: CRNoteInvalilTag,
                                                CRNoteTypeString: CRNoteTypeDefault,
                                                CRNoteFontnameString: CRNoteFontnameDefault,
                                                CRNoteFontsizeString: CRNoteFontsizeDefault,
                                                CRNoteEditableString: CRNoteEditableYes
                                                }];
}

+ (instancetype)noteFromNote:(CRNote *)note{
    return [[CRNote alloc] initFromDictionary:@{
                                                CRNoteIDString: note.noteID,
                                                CRNoteTitleString: note.title,
                                                CRNoteContentString: note.content,
                                                CRNoteContentPreviewString: note.contentPreview,
                                                CRNoteColorTypeString: note.colorType,
                                                CRNoteImageNameString: note.imageName,
                                                CRNoteTimeCreateString: note.timeCreate,
                                                CRNoteTimeUpdateString: note.timeUpdate,
                                                CRNoteTagString: note.tag,
                                                CRNoteTypeString: note.type,
                                                CRNoteFontnameString: note.fontname,
                                                CRNoteFontsizeString: note.fontsize,
                                                CRNoteEditableString: note.editable
                                                }];
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if( self ){
        self.noteID = dictionary[CRNoteIDString];
        self.title = dictionary[CRNoteTitleString];
        self.content = dictionary[CRNoteContentString];
        self.contentPreview = dictionary[CRNoteContentPreviewString];
        self.colorType = dictionary[CRNoteColorTypeString];
        self.imageName = dictionary[CRNoteImageNameString];
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

- (void)setContent:(NSString *)content{
    _content = content;
    _contentPreview = [content substringWithRange:NSMakeRange(0, content.length > k_CONTENT_PREVIEW_LEN ? k_CONTENT_PREVIEW_LEN : content.length)];
}

- (void)setPhotoAsset:(PHAsset *)photoAsset{
    _photoAsset = photoAsset;
    
    if( photoAsset )
        self.type = CRNoteTypePhoto;
    else
        self.type = CRNoteTypeDefault;
}

+ (NSString *)currentTimeString{
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
    
    return timeStringWithComponents([TimeTalkerBird currentDate]);
}

+ (void)logCRNote:(CRNote *)note{
    if( [CRNoteDebug isDebug] == NO ) return;
    
    NSLog(@"crnote: %@ start log", note);
    NSLog(@"%@", note.noteID);
    NSLog(@"%@", note.title);
    NSLog(@"%@", note.content);
    NSLog(@"%@", note.contentPreview);
    NSLog(@"%@", note.colorType);
    NSLog(@"%@", note.imageName);
    NSLog(@"%@", note.timeCreate);
    NSLog(@"%@", note.timeUpdate);
    NSLog(@"%@", note.fontname);
    NSLog(@"%@", note.fontsize);
    NSLog(@"%@", note.editable);
    NSLog(@"%@", note.tag);
    NSLog(@"%@", note.type);
    NSLog(@"%@", note.photoAsset);
//    NSLog(@"%@", note.imageData);
    NSLog(@"crnote: %@ end log", note);
}

@end
