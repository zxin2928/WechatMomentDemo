//
//  NSMutableArray+Safe.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Safe)

- (void)addObjectSafe:(id)anObject;

@end

@interface NSArray (Safe)

- (id)objectAtIndexSafe:(NSUInteger)index;

@end
