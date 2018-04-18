//
//  WMMomentHeadView.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMMomentHeadView : UIView

@property (copy, nonatomic) void (^iconButtonClick)(void);

- (void)updateHeight:(CGFloat)height;

@end

