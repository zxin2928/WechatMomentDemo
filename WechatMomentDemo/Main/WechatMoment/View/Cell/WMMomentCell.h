//
//  WMMomentCell.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMMomentLayout;

@protocol WMMomentCellDelegate;

@interface WMMomentCell : UITableViewCell

@property (strong, nonatomic) WMMomentLayout *layout;

@property (weak, nonatomic) id<WMMomentCellDelegate> delegate;

+(instancetype)cellWithTableView:(UITableView*)tableView identifier:(NSString*)identifier;

@end

@protocol WMMomentCellDelegate <NSObject>
/**
 点击了全文/收回
 
 */
- (void)DidClickMoreLessInDynamicsCell:(WMMomentCell *)cell;

@end
