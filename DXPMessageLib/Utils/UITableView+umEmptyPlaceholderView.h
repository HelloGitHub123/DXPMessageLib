//
//  UITableView+EmptyPlaceholderView.h
//  MOC
//
//  Created by Lee on 2022/3/18.
//

#import <UIKit/UIKit.h>
#import "MLD_umEmptyPlaceholderView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MLD_umEmptyDataDelegate <NSObject>

- (void)emptyDataButtonHandle;

@end

@interface UITableView (umEmptyPlaceholderView)


// 缺省页面title
@property (nonatomic, copy) NSString *emptyTitle;

// 缺省页面desc
@property (nonatomic, copy) NSString *emptyDesc;


//  图片高度
@property (nonatomic, copy) NSString * topHeight;

@property (nonatomic, copy) NSString *emptyImageName;
// 缺省功能按钮标题
@property (nonatomic, copy) NSString *emptyButtonTitle;
// 缺省功能按钮标题颜色
@property (nonatomic, strong) UIColor *emptyButtonTitleColor;
// 缺省功能按钮富文本标题
@property (nonatomic, strong) NSMutableAttributedString *emptyButtonAttributedTitle;
// 缺省功能按钮背景色
@property (nonatomic, strong) UIColor *emptyButtonBGColor;

@property (nonatomic, weak) id <MLD_umEmptyDataDelegate> emptyDelegate;
/**
 展示缺省页面

 @param rowCount 数据源
 */
- (void)showEmptyViewRowCount:(NSUInteger)rowCount;

- (void)setEmptyPlaceHolder;
@end

NS_ASSUME_NONNULL_END
