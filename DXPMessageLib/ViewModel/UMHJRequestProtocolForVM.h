//
//  HJRequestProtoclForVM.h
//  MPTCLPMall
//
//  Created by OO on 2021/10/14.
//  Copyright © 2021 OO. All rights reserved.
//

#ifndef UMHJRequestProtocolForVM_h
#define UMHJRequestProtocolForVM_h

@protocol UMHJVMRequestDelegate <NSObject>
@optional
// 请求成功
- (void)requestSuccess:(NSObject *)vm;
// 请求失败
- (void)requestFailure:(NSObject *)vm;
// 请求开始
- (void)requestStart:(NSObject *)vm;
/// 请求开始
/// @param vm vm
/// @param methodFlag 方法标识
- (void)requestStart:(NSObject *)vm method:(NSString *)methodFlag;
/// 请求成功
/// @param vm vm
/// @param methodFlag 方法标识
- (void)requestSuccess:(NSObject *)vm method:(NSString *)methodFlag;
/// 请求失败
/// @param vm vm
/// @param methodFlag 方法标识
- (void)requestFailure:(NSObject *)vm method:(NSString *)methodFlag;

@end

#endif /* HJRequestProtocolForVM_h */
