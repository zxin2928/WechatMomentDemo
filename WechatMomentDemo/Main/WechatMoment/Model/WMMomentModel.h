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

@property (assign, nonatomic) NSInteger momentId;
@property (assign, nonatomic) NSInteger commentId;

@end

@interface WMImageModel : NSObject

@property (copy, nonatomic) NSString *url;

@property (assign, nonatomic) NSInteger momentId;

@end

@interface WMCommentModel : NSObject
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *nick;

@property (copy, nonatomic) NSString *content;
@property (strong, nonatomic) WMSenderModel *sender;

@property (assign, nonatomic) NSInteger commentId;
@property (assign, nonatomic) NSInteger momentId;
//每条评论cell的高度
@property (assign, nonatomic) CGFloat commentCellHeight;
@property (assign, nonatomic) BOOL isFirstComment;

@end

@interface WMMomentModel : NSObject
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *nick;

@property (copy, nonatomic) NSString *content;
@property (strong, nonatomic) NSMutableArray<WMImageModel*> *images;
@property (strong, nonatomic) NSMutableArray<WMCommentModel*> *comments;
@property (strong, nonatomic) WMSenderModel *sender;

@property (assign, nonatomic) NSInteger momentId;
// 是否展开
@property (nonatomic, assign) BOOL isOpening;
@property (nonatomic, assign) BOOL isShowMoreButton;

@property (assign, nonatomic) CGFloat contentHeight;

@property (assign, nonatomic) CGFloat moreButtonHeight;

@property (assign, nonatomic) CGFloat imageWidth;
@property (assign, nonatomic) CGFloat imageHeight;
@property (assign, nonatomic) CGFloat imageContainerHeight;

@property (assign, nonatomic) CGFloat commentHeight;

@property (assign, nonatomic) CGFloat cellHeight;

- (void)caculateCellHeight;

@end

