//
//  UMHJHttpModel.h
//  DITOApp
//
//  Created by mac on 2021/7/8.
//

#import <Foundation/Foundation.h>
#import "UMHJRequestProtocolForVM.h"

//typedef NS_ENUM(NSInteger, HJHttpMethod) {
//    HJHttpMethodGET,
//    HJHttpMethodPOST,
//    HJHttpMethodPUT,
//    HJHttpMethodDELETE,
//    HJHttpMethodPATCH
//};

typedef void (^umresponseHandler)(_Nullable id dataObj,id _Nullable   resp);
typedef void (^umresponseListHandler)(NSArray <id>* _Nullable  dataObj,id _Nullable resp);

NS_ASSUME_NONNULL_BEGIN

@interface UMHJHttpModel : NSObject
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *resultCode;
@property (nonatomic, copy) NSString *resultMsg;
@property (nonatomic, strong) NSError *responError;

///init初始化时调用,子类重写
- (void)setupObject;

///返回要替换的字段字典
- (NSDictionary *)hj_replacedKeyFromPropertyName;

///返回对应的数组字段
- (NSDictionary *)hj_setupObjectClassInArray;


/// 网络Get请求(不带Error返回)
/// @param actionUrl 请求接口Url
/// @param paramDict 参数 字典类型
/// @param responseDataBlock 成功响应返回
+ (void)getRequestActionByUrl:(NSString *)actionUrl
                  paramDict:(id)paramDict
              responseBlock:(umresponseHandler)responseDataBlock;

/// 网络POST请求(不带Error返回)
/// @param actionUrl 请求接口Url
/// @param paramDict 参数 字典类型
/// @param responseDataBlock 成功响应返回
+ (void)postRequestActionByUrl:(NSString *)actionUrl
                   paramDict:(id)paramDict
               responseBlock:(umresponseHandler)responseDataBlock;

/// 网络Get请求
/// @param actionUrl 请求接口Url
/// @param paramDict 参数 字典类型
/// @param responseDataBlock 成功响应返回
/// @param errorDataBlock 失败响应返回
+ (void)getRequestActionByUrl:(NSString *)actionUrl
                  paramDict:(id)paramDict
              responseBlock:(umresponseHandler)responseDataBlock
                      error:(umresponseHandler)errorDataBlock;

/// 网络POST请求
/// @param actionUrl 请求接口Url
/// @param paramDict 参数 字典类型
/// @param responseDataBlock 成功响应返回
/// @param errorDataBlock 失败响应返回
+ (void)postRequestActionByUrl:(NSString *)actionUrl
                   paramDict:(id)paramDict
               responseBlock:(umresponseHandler)responseDataBlock
                       error:(umresponseHandler)errorDataBlock;

/// 网络Get请求带代理回调处理
/// @param actionUrl 请求接口Url
/// @param paramDict 参数 字典类型
/// @param retunSelf  传递的对象
/// @param retunObject 传递模型
/// @param vDelegate 代理
/// @param methodFlag 代理方法
/// @param responseDataBlock 成功响应返回
/// @param errorDataBlock 失败响应返回
+ (void)getRequestActionByUrl:(NSString *)actionUrl
                    paramDict:(id)paramDict
                    retunSelf:(id)retunSelf
                  retunObject:(inout id)retunObject
                     delegate:(id<UMHJVMRequestDelegate>)vDelegate
                       method:(NSString *)methodFlag
                responseBlock:(umresponseHandler)responseDataBlock
                        error:(umresponseHandler)errorDataBlock;

/// 网络Post请求带代理回调处理
/// @param actionUrl 请求接口Url
/// @param paramDict 参数 字典类型
/// @param retunSelf  传递的对象
/// @param retunObject 传递模型
/// @param vDelegate 代理
/// @param methodFlag 代理方法
/// @param responseDataBlock 成功响应返回
/// @param errorDataBlock 失败响应返回
+ (void)postRequestActionByUrl:(NSString *)actionUrl
                     paramDict:(id)paramDict
                     retunSelf:(id)retunSelf
                     retunObject:(id)retunObject
                      delegate:(id<UMHJVMRequestDelegate>)vDelegate
                        method:(NSString *)methodFlag
                 responseBlock:(umresponseHandler)responseDataBlock
                         error:(umresponseHandler)errorDataBlock;
@end



//第一层为数组的继承这个方法
@interface HJHttpListModel : UMHJHttpModel

/// 网络Get请求 --- 数据为数组的响应
/// @param actionUrl 请求接口Url
/// @param paramDict 参数 字典类型
/// @param responseDataBlock 成功响应返回
+ (void)getListRequestActionByUrl:(NSString *)actionUrl
                      paramDict:(id)paramDict
                  responseBlock:(umresponseListHandler)responseDataBlock;

/// 网络POST请求 --- 数据为数组的响应
/// @param actionUrl 请求接口Url
/// @param paramDict 参数 字典类型
/// @param responseDataBlock 成功响应返回
+ (void)postListRequestActionByUrl:(NSString *)actionUrl
                       paramDict:(id)paramDict
                   responseBlock:(umresponseListHandler)responseDataBlock;

/// 网络Get请求 --- 数据为数组的响应
/// @param actionUrl 请求接口Url
/// @param paramDict 参数 字典类型
/// @param responseDataBlock 成功响应返回
/// @param errorDataBlock 失败响应返回
+ (void)getListRequestActionByUrl:(NSString *)actionUrl
                      paramDict:(id)paramDict
                  responseBlock:(umresponseListHandler)responseDataBlock
                          error:(umresponseHandler)errorDataBlock;

/// 网络POST请求 --- 数据为数组的响应
/// @param actionUrl 请求接口Url
/// @param paramDict 参数 字典类型
/// @param responseDataBlock 成功响应返回
/// @param errorDataBlock 失败响应返回
+ (void)postListRequestActionByUrl:(NSString *)actionUrl
                       paramDict:(id)paramDict
                   responseBlock:(umresponseListHandler)responseDataBlock
                           error:(umresponseHandler)errorDataBlock;

@end


@interface UMHJHttpDicModel : UMHJHttpModel
@property (nonatomic, strong) NSDictionary *data;
@end

@interface UMHJHttpStrModel : UMHJHttpModel
@property (nonatomic, copy) NSString *data;
@end
NS_ASSUME_NONNULL_END
