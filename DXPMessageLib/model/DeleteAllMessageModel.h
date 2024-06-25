//
//  DeleteAllMessageModel.h
//  UserMessage
//
//  Created by 李标 on 2022/11/23.
//  Delete all messages 删除全部消息

#import <Foundation/Foundation.h>
#import "UMHJHttpModel.h"

@class DeleteAllMessageModel;

NS_ASSUME_NONNULL_BEGIN

@interface DeleteAllMessageModelRes : UMHJHttpModel

@property (nonatomic, strong) DeleteAllMessageModel *data;
@end



@interface DeleteAllMessageModel : UMHJHttpModel

@property (nonatomic, copy) NSString *result;
@end

NS_ASSUME_NONNULL_END
