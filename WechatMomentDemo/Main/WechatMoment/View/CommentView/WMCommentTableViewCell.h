//
//  WMCommentTableViewCell.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMCommentModel;

@interface WMCommentTableViewCell : UITableViewCell

@property (strong, nonatomic) WMCommentModel *model;

@property (copy ,nonatomic) void (^linkBlock)(void);

+(instancetype)cellWithTableView:(UITableView*)tableView identifier:(NSString*)identifier;
@end

