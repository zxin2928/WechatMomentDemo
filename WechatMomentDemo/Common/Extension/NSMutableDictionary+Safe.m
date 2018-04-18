//
//  NSMutableDictionary+Safe.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"

@implementation NSMutableDictionary (Safe)
- (void)setObjectSafe:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (aKey != nil && anObject != nil)
    {
        [self setObject:anObject forKey:aKey];
    }
}

@end
