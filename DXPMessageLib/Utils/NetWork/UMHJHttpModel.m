//
//  UMHJHttpModel.m
//  DITOApp
//
//  Created by mac on 2021/7/8.
//
#import "MJExtension.h"
#import "UMHJHttpModel.h"
#import <DXPToolsLib/HJMBProgressHUD+Category.h>
#import <DXPToolsLib/SNAlertMessage.h>
#import "UMDMNetAPIClient.h"
#import "UMHJRequestProtocolForVM.h"
#import "MessageHeader.h"

#define HTTP_Success             @"200"

@implementation UMHJHttpModel

- (id)init {
    self = [super init];
    if (self) {
        if ([self respondsToSelector:@selector(hj_replacedKeyFromPropertyName)]&&[self hj_replacedKeyFromPropertyName]) {
            [self.class mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return [self hj_replacedKeyFromPropertyName];
            }];
        }
        if ([self respondsToSelector:@selector(hj_setupObjectClassInArray)]&&[self hj_setupObjectClassInArray]) {
            [self.class mj_setupObjectClassInArray:^NSDictionary *{
                return [self hj_setupObjectClassInArray];
            }];
        }
        [self setupObject];
    }
    return self;
}

- (void)setupObject {
    //子类重写
}

- (NSDictionary *)hj_replacedKeyFromPropertyName {
    //子类重写
    return @{
    };
    return nil;
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSString class]) {
        if ([self isEmpty:oldValue] || !oldValue) {
            return @"";
        }
    }
    return oldValue;
}

- (BOOL)isEmpty:(NSString*)text {
    if ([text isEqual:[NSNull null]]) {
        return YES;
    } else if ([text isKindOfClass:[NSNull class]]) {
        return YES;
    } else if (text == nil) {
        return YES;
    }
    return NO;
}

- (NSDictionary *)hj_setupObjectClassInArray {
    //子类重写
    return nil;
}

+ (void)requestActionByUrl:(NSString *)actionUrl
                 paramDict:(id)paramDict
                httpMethod:(UMNetworkMethod)httpMethod
              isReturnList:(BOOL)isReturnList
             responseBlock:(umresponseHandler)responseDataBlock {
    
    [self requestActionByUrl:actionUrl paramDict:paramDict httpMethod:httpMethod
                isReturnList:isReturnList retunSelf:nil retunObject:nil delegate:nil method:nil responseBlock:responseDataBlock error:nil];
}

+ (void)getRequestActionByUrl:(NSString *)actionUrl
                    paramDict:(id)paramDict
                responseBlock:(umresponseHandler)responseDataBlock {
    
    [self getRequestActionByUrl:actionUrl paramDict:paramDict responseBlock:responseDataBlock error:nil];
}

+ (void)postRequestActionByUrl:(NSString *)actionUrl
                     paramDict:(id)paramDict
                 responseBlock:(umresponseHandler)responseDataBlock {
    
    [self postRequestActionByUrl:actionUrl paramDict:paramDict responseBlock:responseDataBlock error:nil];
}

+ (void)getRequestActionByUrl:(NSString *)actionUrl
                    paramDict:(id)paramDict
                responseBlock:(umresponseHandler)responseDataBlock
                        error:(umresponseHandler)errorDataBlock {
    
    [self requestActionByUrl:actionUrl paramDict:paramDict httpMethod:Get isReturnList:NO retunSelf:nil retunObject:nil delegate:nil method:nil responseBlock:responseDataBlock error:errorDataBlock];
}

+ (void)getRequestActionByUrl:(NSString *)actionUrl
                    paramDict:(id)paramDict
                    retunSelf:(id)retunSelf
                  retunObject:(inout id)retunObject
                     delegate:(id<UMHJVMRequestDelegate>)vDelegate
                       method:(NSString *)methodFlag
                responseBlock:(umresponseHandler)responseDataBlock
                        error:(umresponseHandler)errorDataBlock {
    
    [self requestActionByUrl:actionUrl paramDict:paramDict httpMethod:Get isReturnList:NO retunSelf:retunSelf retunObject:retunObject delegate:vDelegate method:methodFlag responseBlock:responseDataBlock error:errorDataBlock];
}

+ (void)postRequestActionByUrl:(NSString *)actionUrl
                     paramDict:(id)paramDict
                 responseBlock:(umresponseHandler)responseDataBlock
                         error:(umresponseHandler)errorDataBlock {
    [self requestActionByUrl:actionUrl paramDict:paramDict httpMethod:Post isReturnList:NO retunSelf:nil retunObject:nil delegate:nil method:nil responseBlock:responseDataBlock error:errorDataBlock];
}

+ (void)postRequestActionByUrl:(NSString *)actionUrl
                     paramDict:(id)paramDict
                     retunSelf:(id)retunSelf
                     retunObject:(inout id)retunObject
                      delegate:(id<UMHJVMRequestDelegate>)vDelegate
                        method:(NSString *)methodFlag
                 responseBlock:(umresponseHandler)responseDataBlock
                         error:(umresponseHandler)errorDataBlock {
    [self requestActionByUrl:actionUrl paramDict:paramDict httpMethod:Post isReturnList:NO retunSelf:retunSelf retunObject:retunObject delegate:vDelegate method:methodFlag responseBlock:responseDataBlock error:errorDataBlock];
}

+ (void)requestActionByUrl:(NSString *)actionUrl
                 paramDict:(id)paramDict
                httpMethod:(UMNetworkMethod)httpMethod
              isReturnList:(BOOL)isReturnList
                 retunSelf:(id)retunSelf
               retunObject:(id) retunObject
                  delegate:(id<UMHJVMRequestDelegate>)vDelegate
                    method:(NSString *)methodFlag
             responseBlock:(umresponseHandler)responseDataBlock
                     error:(umresponseHandler)errorDataBlock {
    __weak typeof (retunSelf) weakretunSelf = retunSelf;
    __block  __weak id weakretunObject = retunObject;
    
    [[UMDMNetAPIClient sharedClient] requestJsonDataWithPath:actionUrl withParams:paramDict withMethodType:httpMethod elementPath:@"" andBlock:^(id res, NSError *error) {
        NSDictionary *dict = (NSDictionary *)res;
        if (!error && [HTTP_Code_um isEqualToString:HTTP_Success] && !isNull_um(HTTP_Data_um)) {
            id data;
            if (isReturnList) {
                data = [self mj_objectArrayWithKeyValuesArray:dict];
            } else {
                data = [self mj_objectWithKeyValues:dict];
            }
            weakretunObject = data;

            !responseDataBlock?:responseDataBlock(data,res);
            if (vDelegate && [vDelegate respondsToSelector:@selector(requestSuccess:method:)]) {
                [vDelegate requestSuccess:weakretunSelf method:methodFlag];
            }
        } else {
            
            // 判断网络状态
            AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
            if (manager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
                [SNAlertMessage hideLoading];
                NSLog(@"The network is not connected,please try again.");
                return;
            }
            
            id data = [self mj_objectWithKeyValues:dict];
            !errorDataBlock?:errorDataBlock(data,nil);
            if (vDelegate && [vDelegate respondsToSelector:@selector(requestFailure:method:)]) {
                [vDelegate requestFailure:weakretunSelf method:methodFlag];
            }
        }
    }];
}

@end



@implementation HJHttpListModel

+ (void)getListRequestActionByUrl:(NSString *)actionUrl
                        paramDict:(id)paramDict
                    responseBlock:(umresponseListHandler)responseDataBlock {
    
    [self getListRequestActionByUrl:actionUrl paramDict:paramDict responseBlock:responseDataBlock error:nil];
}

+ (void)postListRequestActionByUrl:(NSString *)actionUrl
                         paramDict:(id)paramDict
                     responseBlock:(umresponseListHandler)responseDataBlock {
    
    [self postListRequestActionByUrl:actionUrl paramDict:paramDict responseBlock:responseDataBlock error:nil];
}

+ (void)getListRequestActionByUrl:(NSString *)actionUrl
                        paramDict:(id)paramDict
                    responseBlock:(umresponseListHandler)responseDataBlock
                            error:(umresponseHandler)errorDataBlock {
    
    [self requestActionByUrl:actionUrl paramDict:paramDict httpMethod:Get isReturnList:YES retunSelf:nil retunObject:nil delegate:nil method:nil responseBlock:responseDataBlock error:errorDataBlock];
}

+ (void)postListRequestActionByUrl:(NSString *)actionUrl
                         paramDict:(id)paramDict
                     responseBlock:(umresponseListHandler)responseDataBlock
                             error:(umresponseHandler)errorDataBlock {
    
    [self requestActionByUrl:actionUrl paramDict:paramDict httpMethod:Post isReturnList:YES retunSelf:nil retunObject:nil delegate:nil method:nil responseBlock:responseDataBlock error:errorDataBlock];
}

@end

@implementation UMHJHttpDicModel
@end

@implementation UMHJHttpStrModel
@end
