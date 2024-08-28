//
//  MessageLogic.m
//  UserMessage
//
//  Created by 李标 on 2022/11/21.
//

#import "MessageLogic.h"
#import <DXPToolsLib/HJMBProgressHUD+Category.h>
#import <DXPToolsLib/SNAlertMessage.h>
#import "MessageViewModel.h"
#import "UMDMNetAPIClient.h"
#import "UMHJRequestProtocolForVM.h"

@interface MessageLogic ()<UMHJVMRequestDelegate>

@property (nonatomic, strong) MessageViewModel *messageViewModel;
// 未读消息数量
@property (nonatomic, copy) UnreadMessageBlock unreadMessageBlock;
// 消息列表
@property (nonatomic, copy) MessageListBlock messageListBlock;
// 消息详情
@property (nonatomic, copy) MessageDetailBlock messageDetailBlock;
// 置消息已读
@property (nonatomic, copy) MarkMessageReadBlock markMessageReadBlock;
// 设置所有消息已读
@property (nonatomic, copy) MarkAllMessagesReadBlock markAllMessagesReadBlock;
// 删除单个消息
@property (nonatomic, copy) DeleteMessageBlock deleteMessageBlock;
// 删除全部消息
@property (nonatomic, copy) DeleteAllMessageBlock deleteAllMessageBlock;
@end

@implementation MessageLogic

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pageSize = 6;
        self.currentPage = 1;
		self.states = @"";
		self.msgType = @"";
    }
    return self;
}

- (void)setPageSize:(NSInteger)pageSize {
    _pageSize = pageSize;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
}

// Request unread messages
- (void)requestUnreadMessageWithBlock:(UnreadMessageBlock)unreadMessageBlock {
    self.unreadMessageBlock = unreadMessageBlock;
    [self.messageViewModel unreadMessageCount];
}

// List of request messages
//- (void)requestMessageListWithBlock:(MessageListBlock)messageListBlock {
//    self.messageListBlock = messageListBlock;
//    [self.messageViewModel messageList];
//}

- (NSInteger)gitCurrentPageNumber {
    return self.currentPage;
}

- (void)gitCurrentPageSizeWithCompletion:(void (^)(NSInteger pageSize, NSString *errorMsg))completion {
    [self requestMessageListByPageInfoWithBlock:^(MessageListModel *messageListModel, NSString *errorMsg) {
        NSInteger pageSize = messageListModel.messageList.count;
        if (completion) {
            completion(pageSize, nil);
        }
    }];
}


// Pull up to refresh
- (void)refreshMessageList {
    self.currentPage = 1;
    [self requestMessageListByPageInfoWithBlock:^(MessageListModel *messageListModel, NSString *errorMsg) {
        if (self.refresMessage) {
            self.refresMessage(messageListModel);
        }
    }];
}

// Pull down to load
- (void)loadMorMessageList{
    ++self.currentPage;
    [self requestMessageListByPageInfoWithBlock:^(MessageListModel *messageListModel, NSString *errorMsg) {
        if (self.refresMessage) {
            self.refresMessage(messageListModel);
        }
    }];
}

- (void)requestMessageListByPageInfoWithBlock:(MessageListBlock)messageListBlock {
    self.messageListBlock = messageListBlock;
    
	NSDictionary *dic = @{@"pageInfo":@{@"currentPage":@(self.currentPage),@"pageSize":@(self.pageSize)},@"msgType":self.msgType,@"State":self.states};
    [self.messageViewModel messageList:dic];
}

// Request Message Details
- (void)requestMessageDetailByMessageId:(NSString *)messageId block:(MessageDetailBlock)messageDetailBlock {
    if (!messageId || [messageId isEqualToString:@""]) {
        return;
    }
    self.messageDetailBlock = messageDetailBlock;
    [self.messageViewModel messageDetailByMessageId:messageId];
}

// Set messages to be read
- (void)requestMessageSetReadByMessageIds:(NSString *)messageIds userId:(NSString *)userId state:(NSString *)state eventCode:(NSString *)eventCode block:(MarkMessageReadBlock)markMessageReadBlock {
    
    if (!messageIds || [messageIds isEqualToString:@""]
//        || !userId || [userId isEqualToString:@""]
//        || !state || [state isEqualToString:@""]
//        || !eventCode || [eventCode isEqualToString:@""]
        ) {
        return;
    }
    self.markMessageReadBlock = markMessageReadBlock;
    [self.messageViewModel markMessageReadByMessageId:messageIds userId:userId state:state eventCode:eventCode];
}

// Set all messages to be read
- (void)requestMessageSetAllReadWithBlock:(MarkAllMessagesReadBlock)markAllMessagesReadBlock {
    self.markAllMessagesReadBlock = markAllMessagesReadBlock;
    [self.messageViewModel markAllMessagesRead];
}

// Delete individual messages
- (void)requestDeleteMessageByMessageIds:(NSString *)messageIds block:(DeleteMessageBlock)deleteMessageBlock {
    if (!messageIds || [messageIds isEqualToString:@""]) {
        return;
    }
    self.deleteMessageBlock = deleteMessageBlock;
    [self.messageViewModel deleteMessageByMessageIds:messageIds];
}

/// eg:Delete all individual messages
- (void)requestDeleteAllMessageWithBlock:(DeleteAllMessageBlock)deleteAllMessageBlock {
    self.deleteAllMessageBlock = deleteAllMessageBlock;
    [self.messageViewModel deleteAllMessage];
}

/// eg:Set request host Url
//- (void)setRequestHostUrl:(NSString *)hostUrl {
//    [UMDMNetAPIClient sharedClient].baseUrl = hostUrl;
//}

/// eg:Set request token
- (void)setHttpRequestToken:(NSString *)token {
    [[UMDMNetAPIClient sharedClient] setRequestToken:token];
}

#pragma mark - UMHJVMRequestDelegate
- (void)requestSuccess:(NSObject *)vm method:(NSString *)methodFlag {
    if ([methodFlag isEqualToString:Url_Message_Unread]) {
        UnreadMessageModel *model = ((MessageViewModel *)vm).unreadMessageModelRes.data;
        if (self.unreadMessageBlock) {
            self.unreadMessageBlock(model, @"");
        }
    }
    if ([methodFlag isEqualToString:Url_Message_List]) {
        MessageListModel *model = ((MessageViewModel *)vm).messageListModelRes.data;
        if (self.messageListBlock) {
            self.messageListBlock(model, @"");
        }
    }
    if ([methodFlag isEqualToString:Url_Message_Detail]) {
        MessageDetailModel *model = ((MessageViewModel *)vm).messageDetailModelRes.data;
        if (self.messageDetailBlock) {
            self.messageDetailBlock(model, @"");
        }
    }
    if ([methodFlag isEqualToString:Url_Message_SetRead]) {
        MarkMessageReadModel *model = ((MessageViewModel *)vm).markMessageReadModelRes.data;
        if (self.markMessageReadBlock) {
            self.markMessageReadBlock(model, @"");
        }
    }
    if ([methodFlag isEqualToString:Url_Message_SetAllRead]) {
        MarkAllMessagesReadModel *model = ((MessageViewModel *)vm).markAllMessagesReadModelRes.data;
        if (self.markAllMessagesReadBlock) {
            self.markAllMessagesReadBlock(model, @"");
        }
    }
    if ([methodFlag isEqualToString:Url_Message_Delete]) {
        DeleteMessageModel *model = ((MessageViewModel *)vm).deleteMessageModelRes.data;
        if (self.deleteMessageBlock) {
            self.deleteMessageBlock(model, @"");
        }
    }
    if ([methodFlag isEqualToString:Url_Message_DeleteAll]) {
        DeleteAllMessageModel *model = ((MessageViewModel *)vm).deleteAllMessageModelRes.data;
        if (self.deleteAllMessageBlock) {
            self.deleteAllMessageBlock(model, @"");
        }
    }
}

- (void)requestFailure:(NSObject *)vm method:(NSString *)methodFlag {
    [SNAlertMessage hideLoading];
    if ([methodFlag isEqualToString:Url_Message_Unread]) {
        NSString *msg = ((MessageViewModel *)vm).unreadMessageModelRes.resultMsg;
        if (self.unreadMessageBlock) {
            self.unreadMessageBlock(nil, msg);
        }
    }
    if ([methodFlag isEqualToString:Url_Message_List]) {
        NSString *msg = ((MessageViewModel *)vm).messageListModelRes.resultMsg;
        if (self.messageListBlock) {
            self.messageListBlock(nil, msg);
        }
    }
    if ([methodFlag isEqualToString:Url_Message_Detail]) {
        NSString *msg = ((MessageViewModel *)vm).messageDetailModelRes.resultMsg;
        if (self.messageDetailBlock) {
            self.messageDetailBlock(nil, msg);
        }
    }
    if ([methodFlag isEqualToString:Url_Message_SetRead]) {
        NSString *msg = ((MessageViewModel *)vm).markMessageReadModelRes.resultMsg;
        if (self.markMessageReadBlock) {
            self.markMessageReadBlock(nil, msg);
        }
    }
    if ([methodFlag isEqualToString:Url_Message_SetAllRead]) {
        NSString *msg = ((MessageViewModel *)vm).markAllMessagesReadModelRes.resultMsg;
        if (self.markAllMessagesReadBlock) {
            self.markAllMessagesReadBlock(nil, msg);
        }
    }
    if ([methodFlag isEqualToString:Url_Message_Delete]) {
        NSString *msg = ((MessageViewModel *)vm).deleteMessageModelRes.resultMsg;
        if (self.deleteMessageBlock) {
            self.deleteMessageBlock(nil, msg);
        }
    }
    if ([methodFlag isEqualToString:Url_Message_DeleteAll]) {
        NSString *msg = ((MessageViewModel *)vm).deleteAllMessageModelRes.resultMsg;
        if (self.deleteAllMessageBlock) {
            self.deleteAllMessageBlock(nil, msg);
        }
    }
}

#pragma mark -- lazy load
- (MessageViewModel *)messageViewModel {
    if (!_messageViewModel) {
        _messageViewModel = [[MessageViewModel alloc] init];
        _messageViewModel.vDelegate = self;
    }
    return _messageViewModel;
}

@end
