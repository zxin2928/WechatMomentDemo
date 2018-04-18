//
//  WMBaseViewController.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMNavigationController.h"
#import "WMCommon.h"
#import "UIBarButtonItem+item.h"

@interface WMBaseViewController : UIViewController<WMNavigaitonControllerPopDelegate, WMRequestDelegate>

#pragma mark -- 导航栏
-(void)addLeftBarButtonItemWithType:(WMNavigationBarType)type;
-(void)addRightBarButtonItemWithType:(WMNavigationBarType)type;


- (void)addFooterRefreshWithView:(UIScrollView *)view;

@end
