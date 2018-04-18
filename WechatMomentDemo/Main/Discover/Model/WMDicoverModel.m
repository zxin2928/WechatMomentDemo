//
//  WMDicoverModel.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMDicoverModel.h"
#import "WMCommon.h"

@implementation WMDicoverModel
+ (NSMutableArray*)testTitleArray{
    NSMutableArray *titleArray = [NSMutableArray array];
    for (int i = 0; i<1; i++) {
        WMDicoverModel *model = [WMDicoverModel new];
        model.title = @"发现";
        [titleArray addObjectSafe:model];
    }
    return titleArray;
}
@end
