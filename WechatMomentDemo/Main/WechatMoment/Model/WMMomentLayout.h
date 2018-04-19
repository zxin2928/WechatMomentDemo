//
//  WMMomentLayout.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/19.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMCommon.h"

#define kDynamicsNormalPadding 15
#define kDynamicsPortraitWidthAndHeight 45
#define kDynamicsPortraitNamePadding 10
#define kDynamicsNameDetailPadding 8
#define kDynamicsNameHeight 17
#define kDynamicsMoreLessButtonHeight 30
#define kDynamicsGrayPicPadding 3


#define kDynamicsLineSpacing 5

@class WMMomentModel;

typedef void(^ClickUserBlock)(NSString * userID);
typedef void(^ClickUrlBlock)(NSString * url);
typedef void(^ClickPhoneNumBlock)(NSString * phoneNum);

@interface WMMomentLayout : NSObject

@property(nonatomic,strong)WMMomentModel * model;

@property(nonatomic,strong)YYTextLayout * detailLayout;
@property(nonatomic,assign)CGSize photoContainerSize;
@property(nonatomic,strong)YYTextLayout * thumbLayout;
@property(nonatomic,strong)NSMutableArray * commentLayoutArr;
@property(nonatomic,assign)CGFloat commentHeight;

@property(nonatomic,copy)ClickUserBlock clickUserBlock;
@property(nonatomic,copy)ClickUrlBlock clickUrlBlock;
@property(nonatomic,copy)ClickPhoneNumBlock clickPhoneNumBlock;

@property(nonatomic,assign)CGFloat height;

- (instancetype)initWithModel:(WMMomentModel *)model;
- (void)resetLayout;

@end
