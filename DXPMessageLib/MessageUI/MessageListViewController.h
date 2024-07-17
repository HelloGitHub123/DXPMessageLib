//
//  MessageListViewController.h
//  CLP
//
//  Created by 李标 on 2023/2/3.
//

#import <UIKit/UIKit.h>
#import "UMBaseViewController.h"
#import "MessageLogic.h"
#import "MessageStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageListViewController : UMBaseViewController

@property (nonatomic, strong) MessageStyleModel *styleModel;

@property (nonatomic, copy) NSString *token;

// 埋点回调抛出
@property (nonatomic, copy) void (^trackManagementBlock)(NSString *trackName, NSDictionary *withProperties);

// 列表显示完成
@property (nonatomic, copy) void (^showMessageListComplete)(void);

// 某条站内信被点击
@property (nonatomic, copy) void (^onMessageClick)(Message *messageModel);

// 列表详情显示完成
@property (nonatomic, copy) void (^showMessageDetailList)(void);

// 点击了URL
@property (nonatomic, copy) void (^clickMessageDetailkUrl)(NSURL *url);

@end

NS_ASSUME_NONNULL_END
