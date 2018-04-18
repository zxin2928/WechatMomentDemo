//
//  WMNavigationController.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMNavigationController.h"
#import "WMBaseViewController.h"
#import "UINavigationController+FullscreenPopGesture.h"

@interface WMNavigationController ()

@end

@implementation WMNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.popGestureStyle = FullscreenPopGestureGradientStyle;
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    if ([viewController isKindOfClass:[WMBaseViewController class]]) {
        WMBaseViewController *vc = (WMBaseViewController*)viewController;
        self.popDelegate = vc;
    }
    
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    WMBaseViewController *vc = (WMBaseViewController*)[super popViewControllerAnimated:animated];
    if ([vc respondsToSelector:@selector(onPopViewControllerAnimated:)]) {
        [vc onPopViewControllerAnimated:animated];
    }
    return vc;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
