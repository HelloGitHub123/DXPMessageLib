//
//  HJBottomOperView.h
//  UserMessage
//
//  Created by 李标 on 2022/12/1.
//  底部弹出视图

#import <UIKit/UIKit.h>
#import "MessageStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OperViewDelegate <NSObject>

// 删除选择所有记录
- (void)operViewActionByDeleteAll;
// 选择所有记录
- (void)operViewActionBySelectAll:(BOOL)isSelected;
@end

@interface HJBottomOperView : UIView

@property (nonatomic, assign) id<OperViewDelegate> delegate;

// init
- (instancetype)initWithFrame:(CGRect)frame styleModel:(MessageStyleModel*)model;
// Set delete button state
- (void)setDeleteEnable:(BOOL)isEnable;
@end

NS_ASSUME_NONNULL_END
