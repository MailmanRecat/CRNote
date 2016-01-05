//
//  CRNoteDebug.h
//  CRNote
//
//  Created by caine on 12/23/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define CR_APP_DEBUG NO

#import <Foundation/Foundation.h>

@interface CRNoteDebug : NSObject

@property( nonatomic, assign ) BOOL debug;

+ (instancetype)shareInstance;

+ (BOOL)isDebug;

@end
