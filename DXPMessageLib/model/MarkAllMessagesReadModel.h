//
//  MarkAllMessagesReadModel.h
//  UserMessage
//
//  Created by 李标 on 2022/11/22.
//  Set all messages to be read 设置所有消息已读

#import <Foundation/Foundation.h>
#import "UMHJHttpModel.h"

@class MarkAllMessagesReadModel;

NS_ASSUME_NONNULL_BEGIN

@interface MarkAllMessagesReadModelRes : UMHJHttpModel

@property (nonatomic, strong) MarkAllMessagesReadModel *data;
@end



@interface MarkAllMessagesReadModel : UMHJHttpModel

@property (nonatomic, copy) NSString *result;
@end

NS_ASSUME_NONNULL_END
