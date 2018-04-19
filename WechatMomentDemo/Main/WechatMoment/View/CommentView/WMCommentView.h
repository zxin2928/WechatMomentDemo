//
//  WMCommentView.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/19.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMCommentModel;
@class WMMomentModel;
@class WMMomentLayout;
@class WMMomentCell;

@interface WMCommentView : UIView
@property(nonatomic,strong)NSMutableArray * commentArray;
@property(nonatomic,strong)WMMomentLayout * layout;
@property(nonatomic,strong)UITableView * commentTable;

@property(nonatomic,strong)WMMomentCell * cell;

- (void)setCommentArr:(NSMutableArray *)commentArr WMMomentLayout:(WMMomentLayout *)layout;

@end
