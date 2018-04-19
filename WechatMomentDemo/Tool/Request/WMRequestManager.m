//
//  WMRequestManager.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMRequestManager.h"
#import "WMCommon.h"

typedef NS_ENUM(NSInteger, WMRequestType)
{
    WMRequestType_PERSON,
    WMRequestType_MOMENT,
    WMRequestType_OTHER
};

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

-(NSString*)getUrlStringWithType:(WMRequestType)type{
    NSString *url = @"";
    switch (type) {
        case WMRequestType_PERSON:
            url = @"/user/jsmith";
            break;
        case WMRequestType_MOMENT:
            url = @"/user/jsmith/tweets";
            break;
        case WMRequestType_OTHER:
            url = @"";
            break;
        default:
            break;
    }
    
    return url;
}

-(void)requestType:(WMRequestType)type Key:(NSString*)key parameters:(NSDictionary*)oarameters delegate:(id<WMRequestDelegate>)delegate{
    NSString *str = [self getUrlStringWithType:type];
    NSString *url = [NSString stringWithFormat:@"%@%@",self.strURL,str];
    [self GET:url parameters:oarameters key:key delegate:delegate];
}

#pragma -mark - public method
- (void)getPersonInfoWithKey:(NSString*)key delegate:(id<WMRequestDelegate>)delegate{
    [self requestType:WMRequestType_PERSON Key:key parameters:nil delegate:delegate];
}

- (void)getMomentInfoWithKey:(NSString *)key delegate:(id<WMRequestDelegate>)delegate
{
    [self requestType:WMRequestType_MOMENT Key:key parameters:nil delegate:delegate];
}

@end
