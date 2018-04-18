//
//  WMNavigationController.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMNavigaitonControllerPopDelegate <NSObject>
@optional
-(void)onPopViewControllerAnimated:(BOOL)animated;
@end

@interface WMNavigationController : UINavigationController
@property (weak, nonatomic) id<WMNavigaitonControllerPopDelegate> popDelegate;
@end
