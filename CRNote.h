//
//  CRNote.h
//  CRNote
//
//  Created by caine on 12/20/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const CRNoteEditableYes = @"CR_NOTE_EDITABLE_YES";
static NSString *const CRNoteEditableNO  = @"CR_NOTE_EDITABLE_NO";

static NSString *const CRNoteInvalidID = @"CR_NOTE_INVALID_ID";
static NSString *const CRNoteInvalilTitle = @"Untitled";
static NSString *const CRNoteInvalilContent = @"Note";
static NSString *const CRNoteInvalilTag = @"Tag";
static NSString *const CRNoteTypeDefault = @"defualt";
static NSString *const CRNoteFontnameDefault = @"Roboto-Regular";
static NSString *const CRNoteFontsizeDefault = @"21";

static NSString *const CRNoteIDString = @"CR_NOTE_ID_STRING";
static NSString *const CRNoteTitleString = @"CR_NOTE_TITLE_STRING";
static NSString *const CRNoteContentString = @"CR_NOTE_CONTENT_STRING";
static NSString *const CRNoteColorTypeString = @"CR_NOTE_COLOR_TYPE_STRING";
static NSString *const CRNoteTimeCreateString = @"CR_NOTE_TIME_CREATE_STRING";
static NSString *const CRNoteTimeUpdateString = @"CR_NOTE_TIME_UPDATE_STRING";
static NSString *const CRNoteTagString = @"CR_NOTE_TAG_STRING";
static NSString *const CRNoteTypeString = @"CR_NOTE_TYPE_STRING";
static NSString *const CRNoteFontnameString = @"CR_NOTE_FONTNAME_STRING";
static NSString *const CRNoteFontsizeString = @"CR_NOTE_FONTSIZE_STRING";
static NSString *const CRNoteEditableString = @"CR_NOTE_EDITABLE_STRING";

@interface CRNote : NSObject

@property( nonatomic, strong ) NSString *noteID;
@property( nonatomic, strong ) NSString *title;
@property( nonatomic, strong ) NSString *content;
@property( nonatomic, strong ) NSString *colorType;
@property( nonatomic, strong ) NSString *timeCreate;
@property( nonatomic, strong ) NSString *timeUpdate;
@property( nonatomic, strong ) NSString *fontname;
@property( nonatomic, strong ) NSString *fontsize;
@property( nonatomic, strong ) NSString *editable;
@property( nonatomic, strong ) NSString *tag;
@property( nonatomic, strong ) NSString *type;

+ (instancetype)defaultNote;
- (instancetype)initFromDictionary:(NSDictionary *)dictionary;

@end
