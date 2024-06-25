//
//  DeleteMessageModel.h
//  UserMessage
//
//  Created by 李标 on 2022/11/23.
//  Delete individual messages 删除单个消息

#import <Foundation/Foundation.h>
#import "UMHJHttpModel.h"

@class DeleteMessageModel;

NS_ASSUME_NONNULL_BEGIN

@interface DeleteMessageModelRes : UMHJHttpModel

@property (nonatomic, strong) DeleteMessageModel *data;
@end



@interface DeleteMessageModel : UMHJHttpModel

@property (nonatomic, copy) NSString *result;
@end

NS_ASSUME_NONNULL_END
