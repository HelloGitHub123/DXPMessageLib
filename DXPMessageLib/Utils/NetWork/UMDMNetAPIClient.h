//
//  UMDMNetAPIClint.h
//  DataMall
//
//  Created by 刘伯洋 on 16/1/4.
//  Copyright © 2016年 刘伯洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "UMSecurityUtil.h"

typedef void(^SuccessBlock)(id res);
typedef void(^FailureBlock)(NSError *error);
typedef void(^UMCompleteBlock)(id res, NSError *error);

typedef enum {
    Get = 0,
    Post,
    Put,
    Delete
} UMNetworkMethod;

@interface UMDMNetAPIClient : AFHTTPSessionManager

@property (nonatomic, copy) NSString *baseUrl;

+ (UMDMNetAPIClient *)sharedClient;

//+ (UMDMNetAPIClient *)sharedClient:(NSString *)url;

- (void)setRequestToken:(NSString *)token;

- (void)GET:(NSString *)url paramaters:(NSDictionary *)paramaters CompleteBlock:(UMCompleteBlock)completeBlock;

- (void)POST:(NSString *)url paramaters:(NSDictionary *)paramaters CompleteBlock:(UMCompleteBlock)completeBlock;

- (void)upload:(NSString *)url data:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName CompleteBlock:(UMCompleteBlock)completeBlock;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(UMNetworkMethod)method
                        elementPath:(NSString *)elementPath
                       andBlock:(void (^)(id data, NSError *error))block;
@end
