//
//  WMModelClass.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WMPersonModel;

@interface WMModelClass : NSObject

/** 朋友圈列表数据 */
+ (NSMutableArray*)momentListWithData:(NSArray*)data;

+(WMPersonModel*)personModelWithData:(NSDictionary*)dic;

@end
