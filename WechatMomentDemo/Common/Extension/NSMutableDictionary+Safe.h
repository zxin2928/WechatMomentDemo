//
//  NSMutableDictionary+Safe.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Safe)
- (void)setObjectSafe:(id)anObject forKey:(id<NSCopying>)aKey;

@end
