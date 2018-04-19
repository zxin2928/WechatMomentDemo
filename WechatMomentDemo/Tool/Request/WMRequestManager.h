//
//  WMRequestManager.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMRequest.h"

@interface WMRequestManager : NSObject

@property(copy, nonatomic)NSString *strURL;

+ (instancetype)sharedManager;

/** 请求朋友圈头部个人信息 */
- (void)getPersonInfoWithKey:(NSString*)key delegate:(id<WMRequestDelegate>)delegate;

/** 请求朋友圈列表数据 */
- (void)getMomentInfoWithKey:(NSString *)key delegate:(id<WMRequestDelegate>)delegate;

@end
