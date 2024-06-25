//
//  MarkMessageReadModel.h
//  UserMessage
//
//  Created by 李标 on 2022/11/22.
//  Set individual messages to be read 设置单个消息已读

#import <Foundation/Foundation.h>
#import "UMHJHttpModel.h"

@class MarkMessageReadModel;

NS_ASSUME_NONNULL_BEGIN

@interface MarkMessageReadModelRes : UMHJHttpModel

@property (nonatomic, strong) MarkMessageReadModel *data;
@end



@interface MarkMessageReadModel : UMHJHttpModel

@property (nonatomic, copy) NSString *result;
@end



NS_ASSUME_NONNULL_END
