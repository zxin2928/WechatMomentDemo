//
//  WMModelClass.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/17.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMCommon.h"
#import "WMModelClass.h"
#import "WMMomentModel.h"
#import "WMPersonModel.h"

@implementation WMModelClass
+(WMPersonModel*)personModelWithData:(NSDictionary*)dic{
    @try
    {
        WMPersonModel *personModel = [WMPersonModel modelWithJSON:dic];
        personModel.profileImage = [dic objectForKey:@"profile-image"];
        [[WMSql shared]insertPerson:personModel];
        return personModel;
    }
    @catch (NSException *exception)
    {
        return nil;
    }
}

+ (NSMutableArray*)momentListWithData:(NSArray*)data{
    @try
    {
        NSMutableArray *dataAry = [NSMutableArray array];
        for (int i = 0; i<data.count; i++) {
            NSDictionary* itemDic = [data objectAtIndexSafe:i];
            WMMomentModel *momentModel = [WMMomentModel modelWithJSON:itemDic];
            momentModel.avatar = momentModel.sender.avatar;
            momentModel.username = momentModel.sender.username;
            momentModel.nick = momentModel.sender.nick;
            momentModel.momentId = i+1;

            //图片数据
            NSMutableArray *imageArray = [NSMutableArray array];
            for (int j = 0; j < momentModel.images.count; j++) {
                WMImageModel *imageModel = [WMImageModel modelWithJSON:[momentModel.images objectAtIndexSafe:j]];
                imageModel.momentId = momentModel.momentId;
                imageModel.imageId = (i+1)*10+j;
                if (momentModel.images.count > 0) {
                    [[WMSql shared]insertMomentImage:imageModel];
                }
                [imageArray addObjectSafe:imageModel];
            }
            momentModel.images = imageArray;

            //评论列表
            NSMutableArray *commentArray = [NSMutableArray array];
            for (int k = 0; k < momentModel.comments.count; k++) {
                WMCommentModel *commentModel = [WMCommentModel modelWithJSON:[momentModel.comments objectAtIndexSafe:k]];
                commentModel.avatar = commentModel.sender.avatar;
                commentModel.username = commentModel.sender.username;
                commentModel.nick = commentModel.sender.nick;
                commentModel.commentId = (i+1)*10+k;
                commentModel.momentId = momentModel.momentId;
                if (momentModel.comments.count > 0) {
                    [[WMSql shared]insertMomentComent:commentModel];
                }
                [commentArray addObjectSafe:commentModel];
            }
            momentModel.comments = commentArray;
            
            
            if (momentModel.content.length > 0 || momentModel.images.count > 0) {
                if (momentModel.content.length == 0) {
                    momentModel.content = @"";
                }
                [[WMSql shared]insertMoment:momentModel];
                [dataAry addObject:momentModel];
            }
            
        }
        return dataAry != nil ? dataAry : [NSMutableArray array];
        
    }
    @catch (NSException *exception)
    {
        return [NSMutableArray array];
    }
}

@end
