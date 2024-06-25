//
//  MessageStyleModel.h
//  DXPMessageLib
//
//  Created by 李标 on 2024/6/25.
//  站内信样式model

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageStyleModel : NSObject

// 首页列表导航栏标题 默认:Message
@property (nonatomic, copy) NSString *navMainTitle;
// 所有消息已读提示语 默认:Do you want to set all messages as read?
@property (nonatomic, copy) NSString *tip_MessageRead;
// 按钮上的yes文案
@property (nonatomic, copy) NSString *btn_yes;
// 按钮上的cancel文案
@property (nonatomic, copy) NSString *btn_cancel;
// 弹框文字 默认:OK
@property (nonatomic, copy) NSString *btn_ok;
// 提示消息，删掉单条消息 默认:Do you want to delete this message?
@property (nonatomic, copy) NSString *tip_DeleteMessage;
// 提示消息，删掉多条消息 默认:Do you want to delete this messages?
@property (nonatomic, copy) NSString *tip_DeleteMessages;
// 侧滑单行 按钮read 文本
@property (nonatomic, copy) NSString *read;
// 侧滑单行 按钮delete 文本
@property (nonatomic, copy) NSString *text_delete;
// 界面没有数据的时候，呈现的提示语标题
@property (nonatomic, copy) NSString *noResults;
// 界面没有数据的时候，呈现的提示语内容 默认:You have no messages now.
@property (nonatomic, copy) NSString *noMessage;
// 编辑按钮文本 默认:Edit
@property (nonatomic, copy) NSString *edit;
// 选中所有的文案 默认: Select All
@property (nonatomic, copy) NSString *selectAll;
// 删除所有的文案 默认: Delete
@property (nonatomic, copy) NSString *deleteAll;
// 导航栏右边按钮的颜色 默认
@property (nonatomic, strong) UIColor *rightBarButtonColor;
// 弹框OK按钮的背景颜色 默认 FF5E00
@property (nonatomic, strong) UIColor *popOKButtonColor;
// 弹框OK按钮的颜色 默认 FFFFFF
@property (nonatomic, strong) UIColor *popBgOKButtonColor;
// 底部弹出pop操作删除按钮背景色 默认 FF5E00
@property (nonatomic, strong) UIColor *bottomDeleteButtonBgColor;
// 底部弹出pop操作删除按钮标题色 默认 FFFFFF
@property (nonatomic, strong) UIColor *bottomDeleteButtonTitleColor;
// 详情页面的导航标题
@property (nonatomic, copy) NSString *details;
// 月份
@property (nonatomic, copy) NSString *jan; // 1
@property (nonatomic, copy) NSString *feb; // 2
@property (nonatomic, copy) NSString *mar; // 3
@property (nonatomic, copy) NSString *apr; // 4
@property (nonatomic, copy) NSString *may; // 5
@property (nonatomic, copy) NSString *jun; // 6
@property (nonatomic, copy) NSString *jul; // 7
@property (nonatomic, copy) NSString *aug; // 8
@property (nonatomic, copy) NSString *sep; // 9
@property (nonatomic, copy) NSString *oct; // 10
@property (nonatomic, copy) NSString *nov; // 11
@property (nonatomic, copy) NSString *dec; // 12
@end

NS_ASSUME_NONNULL_END
