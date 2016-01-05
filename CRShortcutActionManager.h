//
//  CRShortcutActionManager.h
//  CRNote
//
//  Created by caine on 1/4/16.
//  Copyright © 2016 com.caine. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const CRNoteAppShortcutActionNotification = @"CR_NOTE_APP_SHORTCUT_ACTION_NOTIFICATION";

@interface CRShortcutActionManager : NSObject

@property( nonatomic, assign ) BOOL launchFromShortcut;
@property( nonatomic, strong ) NSString *launchShortcutType;

+ (instancetype)defaultManager;

@end
