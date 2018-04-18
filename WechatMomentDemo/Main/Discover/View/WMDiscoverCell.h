//
//  WMDiscoverCell.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDicoverModel.h"

@interface WMDiscoverCell : UITableViewCell
@property (strong, nonatomic) WMDicoverModel *model;

+(instancetype)cellWithTableView:(UITableView*)tableView identifier:(NSString*)identifier;


@end
