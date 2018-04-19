//
//  WMMomentModel.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WMSenderModel : NSObject

@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *nick;

@property (assign, nonatomic) int momentId;
@property (assign, nonatomic) int commentId;

@end

@interface WMImageModel : NSObject

@property (copy, nonatomic) NSString *url;

@property (assign, nonatomic) int imageId;
@property (assign, nonatomic) int momentId;

@end

@interface WMCommentModel : NSObject
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *nick;

@property (copy, nonatomic) NSString *content;
@property (strong, nonatomic) WMSenderModel *sender;

@property (assign, nonatomic) int commentId;
@property (assign, nonatomic) int momentId;

@end

@interface WMMomentModel : NSObject
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *nick;

@property (copy, nonatomic) NSString *content;
@property (strong, nonatomic) NSMutableArray<WMImageModel*> *images;
@property (strong, nonatomic) NSMutableArray<WMCommentModel*> *comments;
@property (strong, nonatomic) WMSenderModel *sender;

@property (assign, nonatomic) int momentId;

@property (nonatomic, assign) BOOL isOpening;//已展开文字
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;//应该显示"全文"

@end

