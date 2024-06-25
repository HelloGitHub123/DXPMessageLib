//
//  MessageListModel.h
//  UserMessage
//
//  Created by 李标 on 2022/11/21.
//  Message List 消息列表

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UMHJHttpModel.h"

@class MessageListModel;
@class Message;
@class PageInfo;
@class ContentParamMap;

NS_ASSUME_NONNULL_BEGIN

@interface MessageListModelRes : UMHJHttpModel

@property (nonatomic, strong) MessageListModel *data;
@end



@interface MessageListModel : UMHJHttpModel

@property (nonatomic, strong) NSMutableArray<Message *> *messageList;
@property (nonatomic, strong) PageInfo *pageInfo;
@end



@interface Message : UMHJHttpModel

@property (nonatomic, copy) NSString *eventCode;
@property (nonatomic, copy) NSString *userId; // add new
@property (nonatomic, copy) NSString *priority; // add new


@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *msgType;
@property (nonatomic, copy) NSString *thumbUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *brief;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *rule;
@property (nonatomic, copy) NSString *ruleData;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *msgAttr;
@property (nonatomic, copy) NSString *effDate;
@property (nonatomic, copy) NSString *expDate;
@property (nonatomic, copy) NSString *pushDate;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *stateDate;
@property (nonatomic, strong) ContentParamMap *contentParamMap;
//  Whether to select(Multiple choice) 是否选择(多选)
@property (nonatomic, assign) BOOL isSelected;
// model cell 高度
- (CGFloat)getCellHeight;
@property (nonatomic, assign) CGFloat imgHeight;
@end

// add new
@interface ContentParamMap : UMHJHttpModel

@property (nonatomic, copy) NSString *offerCode;
@end


@interface PageInfo : UMHJHttpModel

@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *currentPage;
@property (nonatomic, copy) NSString *total;
@end

NS_ASSUME_NONNULL_END
