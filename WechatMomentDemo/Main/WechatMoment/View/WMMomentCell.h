//
//  WMMomentCell.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMMomentModel;

@interface WMMomentCell : UITableViewCell

@property (strong, nonatomic) WMMomentModel *model;

@property (copy ,nonatomic) void (^imageBlock)(NSArray *imageViews, NSInteger index);

@property (copy ,nonatomic) void (^linkBlock)(void);

@property (copy ,nonatomic) void (^iconBlock)(void);

@property (copy ,nonatomic) void (^moreBlock)(BOOL isToOpening);

+(instancetype)cellWithTableView:(UITableView*)tableView identifier:(NSString*)identifier;
@end
