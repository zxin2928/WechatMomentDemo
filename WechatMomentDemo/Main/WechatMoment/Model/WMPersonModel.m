//
//  WMPersonModel.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/19.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMPersonModel.h"
#import "WMMomentModel.h"

@implementation WMPersonModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"WMPersonModel找不到Key----------------------------%@",key);
}

@end
