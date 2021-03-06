//
//  WMMomentRefreshView.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMMomentRefreshView.h"

static const CGFloat criticalY = -60.f;

#define kWMTimeLineRefreshHeaderRotateAnimationKey @"RotateAnimationKey"

@implementation WMMomentRefreshView
{
    CABasicAnimation *_rotateAnimation;
}

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center
{
    WMMomentRefreshView *header = [WMMomentRefreshView new];
    header.center = center;
    return header;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AlbumReflashIcon"]];
        self.bounds = imageView.bounds;
        [self addSubview:imageView];
        
        _rotateAnimation = [[CABasicAnimation alloc] init];
        _rotateAnimation.keyPath = @"transform.rotation.z";
        _rotateAnimation.fromValue = @0;
        _rotateAnimation.toValue = @(M_PI * 2);
        _rotateAnimation.duration = 1.0;
        _rotateAnimation.repeatCount = MAXFLOAT;
    }
    return self;
}


- (void)setRefreshState:(WMRefreshViewState)refreshState
{
    [super setRefreshState:refreshState];
    
    if (refreshState == WMRefreshViewStateRefreshing) {
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        [self.layer addAnimation:_rotateAnimation forKey:kWMTimeLineRefreshHeaderRotateAnimationKey];
    } else if (refreshState == WMRefreshViewStateNormal) {
        [self.layer removeAnimationForKey:kWMTimeLineRefreshHeaderRotateAnimationKey];
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }
}


- (void)updateRefreshHeaderWithOffsetY:(CGFloat)y
{
    
    CGFloat rotateValue = y / 300.0 * M_PI;
    
    if (y < criticalY) {
        y = criticalY;
        
        if (self.scrollView.isDragging && self.refreshState != WMRefreshViewStateWillRefresh) {
            self.refreshState = WMRefreshViewStateWillRefresh;
        } else if (!self.scrollView.isDragging && self.refreshState == WMRefreshViewStateWillRefresh) {
            self.refreshState = WMRefreshViewStateRefreshing;
        }
    }
    
    if (self.refreshState == WMRefreshViewStateRefreshing) return;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 0, -y);
    transform = CGAffineTransformRotate(transform, rotateValue);
    
    self.transform = transform;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (keyPath != kWMBaseRefreshViewObserveKeyPath) return;
    
    [self updateRefreshHeaderWithOffsetY:self.scrollView.contentOffset.y];
}

@end

