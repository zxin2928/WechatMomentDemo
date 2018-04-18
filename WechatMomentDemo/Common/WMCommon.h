//
//  WMCommon.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#ifndef WMCommon_h
#define WMCommon_h

#import <YYKit/YYkit.h>
#import <Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import "NSString+Category.h"
#import "NSMutableArray+Safe.h"
#import "NSMutableDictionary+Safe.h"
#import "UINavigationController+FullscreenPopGesture.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import <MLEmojiLabel.h>
#import "WMRequest.h"
#import "WMRequestCommon.h"
#import "WMRequestManager.h"
#import "WMModelClass.h"
#import "UIView+gesture.h"
#import "WMSql.h"

#define isPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#if DEVELOPMENT
#define BASE_URL @"http://thoughtworks-ios.herokuapp.com"

#else
#define BASE_URL @"http://thoughtworks-ios.herokuapp.com"

#endif

#define SYSTERM_VERTION [[UIDevice currentDevice] systemVersion]

#define COLOR_NAVIGATION    0xF05858     //状态栏、导航栏
#define COLOR_BACKGROUND    0xf6f6f6    //背景颜色
#define white        0xffffff
#define black        0x111111

static const CGFloat STATUSBAR_HEIGHT   = 20.0;

//判断当前设备是否为 IPhoneX
#define IS_IPHONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO) //1125x2436

#define STATUSBAR_HEIGHT   (IS_IPHONEX?44:20)
#define NAVBAR_HEIGHT  (IS_IPHONEX?88:64)
#define TABBAR_HEIGHT  (IS_IPHONEX?83:49)
#define BlankHeight   (IS_IPHONEX?34:0)

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

#define PAGE_NUM 5

#define kScreenWidth YYScreenSize().width

#define kScreenHeight YYScreenSize().height

#define RATIO kScreenWidth/375

#define HEX_RGB(V)    [UIColor colorWithRGB:V]

#define HEX_RGBA(V, A)    [UIColor colorWithRGB:V alpha:A]

static NSString * const NETWORK_ERROR = @"网络不给力";


#endif /*  WMCommon_h */
