//
//  MessageDetailViewController.h
//  UserMessage
//
//  Created by 李标 on 2022/11/29.
//  消息详情

#import <UIKit/UIKit.h>
#import "UMBaseViewController.h"
#import "MessageListModel.h"
#import "MessageLogic.h"
#import "MessageStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageDetailViewController : UMBaseViewController

@property (nonatomic, strong) MessageStyleModel *styleModel;
@end

NS_ASSUME_NONNULL_END
