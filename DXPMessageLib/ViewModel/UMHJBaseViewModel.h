//
//  UMHJBaseViewModel.h
//  UserMessage
//
//  Created by 李标 on 2022/11/19.
//  ViewModel 基类

#import <Foundation/Foundation.h>
#import "UMHJRequestProtocolForVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface UMHJBaseViewModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *resultCode;
@property (nonatomic, strong) NSString *resultMsg;
@end

NS_ASSUME_NONNULL_END
