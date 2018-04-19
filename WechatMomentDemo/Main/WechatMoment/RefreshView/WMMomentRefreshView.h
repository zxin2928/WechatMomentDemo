//
//  WMMomentRefreshView.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMBaseRefreshView.h"

@interface WMMomentRefreshView : WMBaseRefreshView

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center;

@property (copy, nonatomic) void(^refreshingBlock)(void);

@end
