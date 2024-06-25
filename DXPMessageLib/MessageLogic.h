//
//  MessageLogic.h
//  UserMessage
//
//  Created by 李标 on 2022/11/21.
//  Message Management 消息管理

#import <Foundation/Foundation.h>
#import "UnreadMessageModel.h"
#import "MessageListModel.h"
#import "MessageDetailModel.h"
#import "MarkMessageReadModel.h"
#import "MarkAllMessagesReadModel.h"
#import "DeleteMessageModel.h"
#import "DeleteAllMessageModel.h"

// Request unread messages
typedef void(^UnreadMessageBlock)(UnreadMessageModel *unreadMessageModel, NSString *errorMsg);

// List of request messages
typedef void(^MessageListBlock)(MessageListModel *messageListModel, NSString *errorMsg);

// Request Message Details
typedef void(^MessageDetailBlock)(MessageDetailModel *messageDetailModel, NSString *errorMsg);

// Set messages to be read
typedef void(^MarkMessageReadBlock)(MarkMessageReadModel *markMessageReadModel, NSString *errorMsg);

// Set all messages to be read
typedef void(^MarkAllMessagesReadBlock)(MarkAllMessagesReadModel *markAllMessagesReadModel, NSString *errorMsg);

// Delete individual messages
typedef void(^DeleteMessageBlock)(DeleteMessageModel *deleteMessageModel, NSString *errorMsg);

// Delete all individual messages
typedef void(^DeleteAllMessageBlock)(DeleteAllMessageModel *deleteAllMessageModel, NSString *errorMsg);


NS_ASSUME_NONNULL_BEGIN
@interface MessageLogic : NSObject

/// eg: Request unread messages
/// @param unreadMessageBlock Return data callback
- (void)requestUnreadMessageWithBlock:(UnreadMessageBlock)unreadMessageBlock;

/// eg: List of request messages
/// @param pageInfoDic 页面信息参数
/// @param messageListBlock Return data callback
- (void)requestMessageListByPageInfo:(NSDictionary *)pageInfoDic block:(MessageListBlock)messageListBlock;

/// eg: Request Message Details
/// @param messageId Single message id
/// @param messageDetailBlock Return data callback
- (void)requestMessageDetailByMessageId:(NSString *)messageId block:(MessageDetailBlock)messageDetailBlock;

/// eg: Set messages to be read
/// @param messageIds  A set of message ids
/// @param userId User id
/// @param state Message Status
/// @param eventCode Event code
/// @param markMessageReadBlock Return data callback
- (void)requestMessageSetReadByMessageIds:(NSString *)messageIds userId:(NSString *)userId state:(NSString *)state eventCode:(NSString *)eventCode block:(MarkMessageReadBlock)markMessageReadBlock;

/// eg:Set all messages to be read
/// @param markAllMessagesReadBlock Return data callback
- (void)requestMessageSetAllReadWithBlock:(MarkAllMessagesReadBlock)markAllMessagesReadBlock;

/// eg:Delete individual messages
/// @param messageIds  A set of message ids
/// @param deleteMessageBlock Return data callback
- (void)requestDeleteMessageByMessageIds:(NSString *)messageIds block:(DeleteMessageBlock)deleteMessageBlock;

/// eg:Delete all individual messages
/// @param deleteAllMessageBlock Return data callback
- (void)requestDeleteAllMessageWithBlock:(DeleteAllMessageBlock)deleteAllMessageBlock;

///// eg:Set request host Url
//- (void)setRequestHostUrl:(NSString *)hostUrl;

/// eg:Set request token
/// @param token Unique identification
- (void)setHttpRequestToken:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
