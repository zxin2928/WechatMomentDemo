//
//  UIBarButtonItem+item.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "UIBarButtonItem+item.h"
#import "WMCommon.h"

@implementation UIBarButtonItem (item)
-(instancetype)initWithBarButtonItemType:(WMNavigationBarType)type target:(id)target action:(SEL)action{
    UIButton *btn = nil;
    NSString *imgName = @"";
    NSString *title = @"";

    switch (type) {
        case WMNavigationBarType_BACK:
            imgName = @"";
            title = @"发现";
            break;
        case WMNavigationBarType_CAPTURE:
            imgName = @"";
            title = @"相机";
            break;
        default:
            break;
    }
    
    UIImage *img = [UIImage imageNamed:imgName];
    btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    btn.tag = type;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:img forState:UIControlStateNormal];
    UIBarButtonItem *button = [self initWithCustomView:btn];
    
    return button;
}

@end
