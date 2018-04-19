//
//  WMMomentImageContainerView.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMMomentImageContainerView : UIView

@property (nonatomic, strong) NSArray *picPathStringsArray;

@property (nonatomic, strong) UIViewController * superView;
@property (nonatomic, assign) int customImgWidth;

+ (CGSize)getContainerSizeWithPicPathStringsArray:(NSArray *)picPathStringsArray;

@end
