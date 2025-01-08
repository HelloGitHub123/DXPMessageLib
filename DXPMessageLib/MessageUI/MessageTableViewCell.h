//
//  MessageTableViewCell.h
//  UserMessage
//
//  Created by 李标 on 2022/11/23.
//

#import <UIKit/UIKit.h>
#import "MessageListModel.h"
#import "LYSideslipCell.h"
#import "MessageStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MessageDelegate <NSObject>
/// eg: 消息是否选中
/// @param messageId 消息id
/// @param isSelected 是否选中  yes:选择  no:不选择
- (void)MessageIsSelectedByMessageId:(NSString *)messageId isSelected:(BOOL)isSelected;
@end

@interface MessageTableViewCell : LYSideslipCell

@property (nonatomic, assign) id<MessageDelegate> pDelegate;

@property (nonatomic, strong) MessageStyleModel *styleModel;

// 日期格式化
@property (nonatomic, copy) NSString *dateFormater;

// 绑定model
- (void)bindCellModel:(Message *)message isEdit:(BOOL)isEdit tableview:(UITableView *)tableView;
// 更新cell中选择按钮状态
- (void)setSelectBtnByState:(BOOL)isSelected;

- (void)messageSelectedAction;
@end

NS_ASSUME_NONNULL_END
