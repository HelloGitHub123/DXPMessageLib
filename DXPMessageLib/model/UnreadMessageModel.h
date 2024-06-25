//
//  UnreadMessageModel.h
//  UserMessage
//
//  Created by 李标 on 2022/11/19.
//  Number of unread messages 未读消息数

#import <Foundation/Foundation.h>
#import "UMHJHttpModel.h"

@class UnreadMessageModel;

NS_ASSUME_NONNULL_BEGIN
@interface UnreadMessageModelRes : UMHJHttpModel

@property (nonatomic, strong) UnreadMessageModel *data;
@end



@interface UnreadMessageModel : UMHJHttpModel

@property (nonatomic, copy) NSString *unReadCount;
@end

NS_ASSUME_NONNULL_END
