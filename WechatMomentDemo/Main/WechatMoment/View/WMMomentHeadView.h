//
//  WMMomentHeadView.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMPersonModel;

@interface WMMomentHeadView : UIView

@property (copy, nonatomic) void (^iconButtonClick)(void);

@property (strong, nonatomic) WMPersonModel *model;

@end

