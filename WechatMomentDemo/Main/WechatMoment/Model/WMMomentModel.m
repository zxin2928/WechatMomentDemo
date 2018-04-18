//
//  WMMomentModel.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMMomentModel.h"
#import "WMCommon.h"

@implementation WMSenderModel


@end

@implementation WMImageModel


@end

@implementation WMCommentModel


@end

@implementation WMMomentModel

-(void)caculateCellHeight{
    switch (self.images.count)
    {
        case 0:
        {
            self.imageWidth = 0;
            self.imageHeight = 0;
            break;
        }
        case 1:
        {
            self.imageWidth = RATIO*300.0 / 2;
            self.imageHeight = RATIO*350.0 / 2;
            break;
        }
        default:
        {
            self.imageWidth = RATIO*193.0 / 2;
            self.imageHeight = RATIO*193.0 / 2;
            break;
        }
    }
    
    if (_cellHeight == 0)
    {
        //计算图片区高度
        NSInteger imageCount = self.images.count;
        CGFloat containerH;
        switch (self.images.count)
        {
            case 0:
            {
                containerH = 0;
                break;
            }
            case 4:
            {
                containerH = (self.imageHeight + 5) * ((imageCount - 1 )/ 2 + 1) + 10;
                break;
            }
            default:
            {
                containerH = (self.imageHeight + 5) * ((imageCount - 1 )/ 3 + 1) + 10;
                break;
            }
        }
        self.imageContainerHeight = containerH;
        
        //计算发布内容区高度
        MLEmojiLabel *emojiLable = [MLEmojiLabel new];
        emojiLable.numberOfLines = 0;
        emojiLable.textAlignment = NSTextAlignmentJustified;
        emojiLable.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        emojiLable.font = [UIFont systemFontOfSize:14];
        emojiLable.isNeedAtAndPoundSign = YES;
        emojiLable.text = self.content;
        CGFloat width = kScreenWidth - 70;
        CGFloat strH = [emojiLable preferredSizeWithMaxWidth:width].height;
        
        MLEmojiLabel *emojiLable6 = [MLEmojiLabel new];
        emojiLable6.numberOfLines = 6;
        emojiLable6.textAlignment = NSTextAlignmentJustified;
        emojiLable6.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        emojiLable6.font = [UIFont systemFontOfSize:14];
        emojiLable6.isNeedAtAndPoundSign = YES;
        emojiLable6.text = self.content;
        CGFloat width6 = kScreenWidth - 70;
        CGFloat strH6 = [emojiLable6 preferredSizeWithMaxWidth:width6].height;
        if (strH > strH6) {
            self.isShowMoreButton = YES;
            self.moreButtonHeight = 20;
        }else{
            
        }
        
        if (self.isOpening) {
            self.contentHeight = strH;
        }else{
            self.contentHeight = strH6;
        }
        
        //计算评论区高度
        CGFloat commentHeight = 0;
        for (int i = 0; i < self.comments.count; i++) {
            WMCommentModel *commentModel = [self.comments objectAtIndexSafe:i];
            NSString *nickName = commentModel.nick ? commentModel.nick : (commentModel.username ? commentModel.username : @"");
            NSString *contentStr = [NSString stringWithFormat:@"%@：%@",nickName,commentModel.content];
            
            MLEmojiLabel *emojiContent = [MLEmojiLabel new];
            emojiContent.numberOfLines = 0;
            emojiContent.textAlignment = NSTextAlignmentJustified;
            emojiContent.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
            emojiContent.font = [UIFont systemFontOfSize:14];
            emojiContent.isNeedAtAndPoundSign = YES;
            emojiContent.text = contentStr;
            
            CGFloat width = kScreenWidth - 70;
            CGFloat height = [emojiContent preferredSizeWithMaxWidth:width].height;
            
            if (i == self.comments.count - 1) {
                height = height+5;
            }
            
            if (i == 0) {
                height = height+5;
                commentModel.isFirstComment = YES;
            }
            
            commentModel.commentCellHeight = height;

            commentHeight = commentHeight + height;
        }
        
        self.commentHeight = commentHeight;
        
        //计算cell高度
        self.cellHeight = 6 + 46 + self.contentHeight + self.moreButtonHeight + self.imageContainerHeight + self.commentHeight ;
    }
}

@end

