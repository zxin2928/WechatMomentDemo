//
//  UIBarButtonItem+item.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WMNavigationBarType)
{
    WMNavigationBarType_BACK,
    WMNavigationBarType_CAPTURE,
    WMNavigationBarType_OTHER
};

@interface UIBarButtonItem (item)

-(instancetype)initWithBarButtonItemType:(WMNavigationBarType)type target:(id)target action:(SEL)action;

@end
