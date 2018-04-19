//
//  WMSql.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/18.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WMPersonModel;

@class WMMomentModel;
@class WMCommentModel;
@class WMImageModel;

@interface WMSql : NSObject

+(instancetype)shared;
-(void)createTables;

-(BOOL)insertPerson:(WMPersonModel*)personModel;

-(BOOL)insertMoment:(WMMomentModel*)momentModel;
-(BOOL)insertMomentComent:(WMCommentModel*)comentModel;
-(BOOL)insertMomentImage:(WMImageModel*)imageModel;

-(WMPersonModel*)queryCurrentPerson;
-(NSMutableArray*)queryMomentWithPage:(int)page;

@end
