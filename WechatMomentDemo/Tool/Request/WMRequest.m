//
//  WMRequest.m
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "WMRequest.h"
#import <AFNetworking.h>
#import "WMCommon.h"

@implementation WMRequest

- (void)GET:(NSString *)url parameters:(NSMutableDictionary *)parameters delegate:(id<WMRequestDelegate>)delegate
{
    self.delegate = delegate;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = nil;
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    
    self.sessionManager = manager;
    
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.requestUrl = task.response.URL.absoluteString;
        
        [self onGetResponseObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        self.requestUrl = task.response.URL.absoluteString;
        
        [self onGetError:error];
    }];
}

- (void)POST:(NSString *)url parameters:(NSMutableDictionary *)parameters delegate:(id<WMRequestDelegate>)delegate
{
    self.delegate = delegate;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = nil;
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    self.sessionManager = manager;
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.requestUrl = task.response.URL.absoluteString;
        
        [self onGetResponseObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.requestUrl = task.response.URL.absoluteString;
        [self onGetError:error];
    }];
}

-(void)onGetResponseObject:(id)responseObject{
    @try
    {
        if ([self.delegate respondsToSelector:@selector(requestSuccess:data:url:)])
        {
            [self.delegate requestSuccess:self data:responseObject url:self.originalUrl];
        }
        
    }
    @catch (NSException *exception)
    {
    }
}

-(void)onGetError:(NSError*)error{
    @try
    {
        if ([self.delegate respondsToSelector:@selector(requestFail:error:url:)])
        {
            if (error.code == NSURLErrorNetworkConnectionLost || error.code == NSURLErrorNotConnectedToInternet)
            {
                self.status = WMRequestStatus_NETWORK_ERROR;
                self.message = @"请求失败,请检查网络";
            }else{
                self.status = WMRequestStatus_FAIL;
                self.message = @"服务器错误";
            }
            [self.delegate requestFail:self error:error url:self.originalUrl];
        }
    }
    @catch (NSException *exception)
    {
    }
}

@end
