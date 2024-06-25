//
//  MessageViewModel.h
//  UserMessage
//
//  Created by 李标 on 2022/11/19.
//  消息处理 viewmodel

#import <Foundation/Foundation.h>
#import "UMHJBaseViewModel.h"
#import "UnreadMessageModel.h"
#import "MessageListModel.h"
#import "MessageDetailModel.h"
#import "MarkMessageReadModel.h"
#import "MarkAllMessagesReadModel.h"
#import "DeleteMessageModel.h"
#import "DeleteAllMessageModel.h"
#import "UMHJRequestProtocolForVM.h"

// 消息未读数
#define Url_Message_Unread      @"ecare/message/unRead"
// 消息列表
#define Url_Message_List        @"ecare/message/list"
// 消息详情
#define Url_Message_Detail      @"ecare/message/detail"
// 设置消息已读
#define Url_Message_SetRead     @"ecare/message/setRead"
// 设置消息全部已读
#define Url_Message_SetAllRead  @"ecare/message/setAllRead"
// 删除消息
#define Url_Message_Delete      @"ecare/message/delete"
// 删除所有消息
#define Url_Message_DeleteAll   @"ecare/message/deleteAll"


NS_ASSUME_NONNULL_BEGIN

@interface MessageViewModel : UMHJBaseViewModel

@property (nonatomic, assign) id<UMHJVMRequestDelegate> vDelegate;
// 未读消息数
@property (nonatomic, strong) UnreadMessageModelRes *unreadMessageModelRes;
// 消息列表
@property (nonatomic, strong) MessageListModelRes *messageListModelRes;
// 消息详情
@property (nonatomic, strong) MessageDetailModelRes *messageDetailModelRes;
// 消息已读
@property (nonatomic, strong) MarkMessageReadModelRes *markMessageReadModelRes;
// 全部消息已读
@property (nonatomic, strong) MarkAllMessagesReadModelRes *markAllMessagesReadModelRes;
// 删除单个消息
@property (nonatomic, strong) DeleteMessageModelRes *deleteMessageModelRes;
// 删除全部消息
@property (nonatomic, strong) DeleteAllMessageModelRes *deleteAllMessageModelRes;

/// eg:查询未读消息数量
- (void)unreadMessageCount;
/// eg: 查询消息列表
- (void)messageList:(NSDictionary *)dic;
/// eg: 查询消息详情
- (void)messageDetailByMessageId:(NSString *)messageId;
/// eg: 设置消息已读
- (void)markMessageReadByMessageId:(NSString *)messageIds userId:(NSString *)userId state:(NSString *)state eventCode:(NSString *)eventCode;
/// eg: 设置全部消息已读
- (void)markAllMessagesRead;
/// eg: 删除消息
- (void)deleteMessageByMessageIds:(NSString *)messageIds;
/// eg: 删除全部消息
- (void)deleteAllMessage;
@end

NS_ASSUME_NONNULL_END
