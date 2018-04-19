//
//  WMBaseRefreshView.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMBaseRefreshView.h"

NSString *const kWMBaseRefreshViewObserveKeyPath = @"contentOffset";

@implementation WMBaseRefreshView

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    [scrollView addObserver:self forKeyPath:kWMBaseRefreshViewObserveKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self.scrollView removeObserver:self forKeyPath:kWMBaseRefreshViewObserveKeyPath];
    }
}

- (void)endRefreshing
{
    self.refreshState = WMRefreshViewStateNormal;
}

-(void)beginRefreshing{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    }];

    if (self.window) {
        self.refreshState = WMRefreshViewStateRefreshing;
    } else {
        if (self.refreshState != WMRefreshViewStateRefreshing) {
            self.refreshState = WMRefreshViewStateWillRefresh;
            [self setNeedsDisplay];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    // 子类实现
    
}

@end

