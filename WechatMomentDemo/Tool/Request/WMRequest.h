//
//  WMRequest.h
//  WechatMomentDemo
//
//  Created by zhaoxin on 2018/4/16.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, WMRequestStatus)
{
    WMRequestStatus_SUCCESS,
    WMRequestStatus_FAIL,
    WMRequestStatus_NETWORK_ERROR,
    WMRequestStatus_OTHER
};

@class WMRequest;
@class AFHTTPSessionManager;

@protocol WMRequestDelegate <NSObject>

@optional

- (void)requestSuccess:(WMRequest *)request data:(id)data url:(NSString *)url;

- (void)requestFail:(WMRequest *)request error:(NSError *)error url:(NSString *)url;

@end

@interface WMRequest : NSObject

@property (weak, nonatomic) id<WMRequestDelegate> delegate;

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@property (copy, nonatomic) NSString *originalUrl;

@property (copy, nonatomic) NSString *requestUrl;

@property (copy, nonatomic) NSString *key;

@property (copy, nonatomic) NSString *message;
@property (assign, nonatomic) WMRequestStatus status;

- (void)GET:(NSString *)url parameters:(NSMutableDictionary *)parameters delegate:(id<WMRequestDelegate>)delegate;

- (void)POST:(NSString *)url parameters:(NSMutableDictionary *)parameters delegate:(id<WMRequestDelegate>)delegate;

@end
