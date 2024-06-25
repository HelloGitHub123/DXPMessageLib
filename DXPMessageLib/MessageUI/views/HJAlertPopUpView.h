//
//  HJAlertPopUpView.h
//  UserMessage
//
//  Created by 李标 on 2022/11/29.
//

#import <UIKit/UIKit.h>
#import "MessageStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJAlertPopUpView : UIView

@property (nonatomic, copy) void (^okBlock)(NSString *text);
@property (nonatomic, copy) void (^cancelBlock)();

// Initialising the pop-up box
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title contentText:(NSString *)contentText okBtnTitle:(NSString *)okBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle styleModel:(MessageStyleModel *)model;
// Display pop-up box
- (void)show;
@end

NS_ASSUME_NONNULL_END
