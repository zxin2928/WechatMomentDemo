//
//  WMTabBarViewController.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMTabBarViewController.h"
#import "WMNavigationController.h"
#import "WMCommon.h"
#import "WMDiscoverViewController.h"

@interface WMTabBarViewController ()

@end

@implementation WMTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = HEX_RGB(white);
    
    WMNavigationController *dicoverNav = [self createNavigationControllerWithClass:[WMDiscoverViewController class] imageName:@"nav_match" seletedImageName:@"nav_match_s" title:@"发现"];
    
    self.viewControllers = @[dicoverNav];
    
    
    NSDictionary  *attributes_normal = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:10],
                                         NSForegroundColorAttributeName:
                                             HEX_RGBA(0xA6A6A6, 1),
                                         NSBackgroundColorAttributeName:
                                             [UIColor clearColor],
                                         };
    NSDictionary  *attributes_select = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:10],
                                         NSForegroundColorAttributeName:
                                             HEX_RGBA(0xF05858, 1),
                                         NSBackgroundColorAttributeName:
                                             [UIColor clearColor],
                                         };
    [[UITabBarItem appearance] setTitleTextAttributes:attributes_normal forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         attributes_select forState:UIControlStateSelected];
    
    //改变tabbar 线条颜色
    CGRect rect = CGRectMake(0, 0, kScreenWidth, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   HEX_RGB(COLOR_BACKGROUND).CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.tabBar setShadowImage:img];
    
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    
    [[WMSql shared]createTables];
    
}


- (WMNavigationController *)createNavigationControllerWithClass:(Class)class imageName:(NSString *)imageName seletedImageName:(NSString *)seletedImageName title:(NSString *)title
{
    UIViewController *vc = [[class alloc] init];
    vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:seletedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.title = title;
    WMNavigationController *nav = [[WMNavigationController alloc] initWithRootViewController:vc];
    return nav;
}

@end
