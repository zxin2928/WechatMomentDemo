//
//  WMBaseRefreshView.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kWMBaseRefreshViewObserveKeyPath;

typedef enum {
    WMRefreshViewStateNormal,
    WMRefreshViewStateWillRefresh,
    WMRefreshViewStateRefreshing,
} WMRefreshViewState;

@interface WMBaseRefreshView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

-(void)beginRefreshing;
- (void)endRefreshing;

@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInsets;
@property (nonatomic, assign) WMRefreshViewState refreshState;

@end
