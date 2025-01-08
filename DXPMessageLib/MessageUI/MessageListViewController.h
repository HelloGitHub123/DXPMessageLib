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

typedef NS_ENUM(NSInteger, ShowModeType) {
	ShowModeType_GroupByType  = 101,
	ShowModeType_GroupByState = 102,
};


@interface MessageListViewController : UMBaseViewController

@property (nonatomic, strong) MessageStyleModel *styleModel;

@property (nonatomic, copy) NSString *token;

// 配置groupByType，则按照Type分组展示，Tab形式；Type分为Message和Notice两种方式
// 配置groupByState，则按照State分组展示，Tab形式；State分为A未读和R已读
// 默认不配置不展示
@property (nonatomic, assign) ShowModeType showModelType;

// 默认选择第几个tab 默认选中第一个(为0)
@property (nonatomic, assign) int selectedIndexTab;

// 日期格式化
@property (nonatomic, copy) NSString *dateFormater;

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
