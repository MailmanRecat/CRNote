//
//  CRMutableStack.h
//  CRNote
//
//  Created by caine on 1/6/16.
//  Copyright © 2016 com.caine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRMutableStack : NSObject

@property( nonatomic, strong ) id pop;
@property( nonatomic, assign ) NSUInteger count;

- (instancetype)initFromArray:(NSArray *)array;

- (void)push:(id)object;

@end
