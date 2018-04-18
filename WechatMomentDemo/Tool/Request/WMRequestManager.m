//
//  WMRequestManager.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMRequestManager.h"
#import "WMCommon.h"

@interface WMRequestManager ()

@property (strong, nonatomic) NSMutableDictionary *requests;

@property (strong, nonatomic) NSMutableDictionary *publicParameters;

@end

@implementation WMRequestManager

+ (instancetype)sharedManager
{
    static WMRequestManager *manger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[self alloc] init];
        manger.requests = [NSMutableDictionary dictionary];
        manger.strURL = BASE_URL;
        
    });
    return manger;
}

#pragma mark -- 获取公共参数
- (NSMutableDictionary *)publicParameters
{
    if (_publicParameters == nil)
    {
        _publicParameters = [NSMutableDictionary dictionary];
        
    }
    return _publicParameters;
}

#pragma mark -- 公共方法
- (WMRequest *)GET:(NSString *)url parameters:(NSDictionary *)parameters key:(NSString *)key delegate:(id<WMRequestDelegate>)delegate
{
    WMRequest *request = self.requests[key];
    if (request == nil)
    {
        request = [[WMRequest alloc] init];
        
        self.requests[key] = request;
        request.key = key;
    }
    else
    {
        [request.sessionManager invalidateSessionCancelingTasks:YES];
    }
    
    NSMutableDictionary *dicTemp = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [request GET:url parameters:dicTemp delegate:delegate];
    return request;
}

- (WMRequest *)POST:(NSString *)url parameters:(NSDictionary *)parameters key:(NSString *)key delegate:(id<WMRequestDelegate>)delegate
{
    WMRequest *request = self.requests[key];
    if (request == nil)
    {
        request = [[WMRequest alloc] init];
        
        self.requests[key] = request;
        request.key = key;
    }
    else
    {
        [request.sessionManager invalidateSessionCancelingTasks:YES];
    }
    
    NSMutableDictionary *dicTemp = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [request POST:url parameters:dicTemp delegate:delegate];
    return request;
}

- (void)getMomentInfoWithKey:(NSString *)key delegate:(id<WMRequestDelegate>)delegate
{
    NSString *strUrl = [NSString stringWithFormat:@"%@/user/jsmith/tweets",self.strURL];
    [self GET:strUrl parameters:nil key:key delegate:delegate];
}

@end
