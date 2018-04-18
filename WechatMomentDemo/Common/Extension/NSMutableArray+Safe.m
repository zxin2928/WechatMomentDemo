//
//  NSMutableArray+Safe.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "NSMutableArray+Safe.h"

@implementation NSMutableArray (Safe)

- (void)addObjectSafe:(id)anObject
{
    if (anObject != nil)
    {
        [self addObject:anObject];
    }
}

@end

@implementation NSArray (Safe)

- (id)objectAtIndexSafe:(NSUInteger)index
{
    return index < self.count ? self[index] : nil;
}

@end
