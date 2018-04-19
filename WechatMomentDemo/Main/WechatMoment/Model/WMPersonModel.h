//
//  WMPersonModel.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/19.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WMSenderModel;

@interface WMPersonModel : NSObject
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *nick;

@property (copy, nonatomic) NSString *profileImage;

@property (assign, nonatomic) int personId;
@property (strong, nonatomic) WMSenderModel *sender;

@end
