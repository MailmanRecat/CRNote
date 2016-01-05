//
//  CRShortcutActionManager.m
//  CRNote
//
//  Created by caine on 1/4/16.
//  Copyright © 2016 com.caine. All rights reserved.
//

#import "CRShortcutActionManager.h"

@interface CRShortcutActionManager()

@end

@implementation CRShortcutActionManager

+ (instancetype)defaultManager{
    static CRShortcutActionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CRShortcutActionManager alloc] init];
    });
    return manager;
}

- (void)setLaunchFromShortcut:(BOOL)launchFromShortcut{
    if( _launchFromShortcut == launchFromShortcut ) return;
    _launchFromShortcut = launchFromShortcut;
    
    if( launchFromShortcut )
        [[NSNotificationCenter defaultCenter] postNotificationName:CRNoteAppShortcutActionNotification object:nil];
}

@end
