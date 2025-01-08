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

// 日期格式化
@property (nonatomic, copy) NSString *dateFormater;

// 列表详情显示完成
@property (nonatomic, copy) void (^showMessageDetailListComplete)(void);

// 点击了URL
@property (nonatomic, copy) void (^clickUrl)(NSURL *url);
@end

NS_ASSUME_NONNULL_END
