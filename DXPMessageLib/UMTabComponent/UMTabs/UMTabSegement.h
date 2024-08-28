//
//  HJTabSegement.h
//  HJControls
//
//  Created by mac on 2022/10/12.
//

#import <UIKit/UIKit.h>
#import "MessageStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

/*
 * 注意点！！！！！！！！：此控件用masonry布局,控件整体高度设置为50
 */

@protocol UMTabSegementDelegate <NSObject>

- (void)tabSegementSelectIndex:(NSInteger)index;

@end

@interface UMTabSegement : UIView

@property (nonatomic, assign) id <UMTabSegementDelegate> delegate;

/*
 *  设置数据源
 */
@property (nonatomic, strong) NSArray *dataArray;



/*
 *  设置选中的index，默认0
 */
@property (nonatomic, assign) NSInteger selectIndex;

// 配置数据
@property (nonatomic, strong) MessageStyleModel *styleModel;

/*
 *  设置是否等分。如果等分，给出控件的整体的长度；
 */
- (void)setEqualSplit:(BOOL)result totalWidth:(CGFloat)totalWidth;

/*
 *  设置是否可以滑动;默认 yes
 */
- (void)setScrollEnabled:(NSInteger)result;

@end

NS_ASSUME_NONNULL_END
