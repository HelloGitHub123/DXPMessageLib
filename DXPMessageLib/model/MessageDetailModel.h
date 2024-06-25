//
//  MessageDetailModel.h
//  UserMessage
//
//  Created by 李标 on 2022/11/22.
//  Check message details 查询消息详情

#import <Foundation/Foundation.h>
#import "UMHJHttpModel.h"

@class MessageDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface MessageDetailModelRes : UMHJHttpModel

@property (nonatomic, strong) MessageDetailModel *data;
@end



@interface MessageDetailModel : UMHJHttpModel

@property (nonatomic, copy) NSString *userMessageId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *brief;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *pushDate;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *readState;
@end

NS_ASSUME_NONNULL_END
