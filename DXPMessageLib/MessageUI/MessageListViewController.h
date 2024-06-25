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
@end

NS_ASSUME_NONNULL_END
