//
//  HJTabCollectionViewCell.h
//  HJControls
//
//  Created by mac on 2022/10/12.
//

#import <UIKit/UIKit.h>
#import "MessageStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UMTabCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) MessageStyleModel *styleModel;

- (void)setContentWithText:(NSString *)text currentIndex:(NSInteger)currentIndex selectIndex:(NSInteger)selectIndex;

@end

NS_ASSUME_NONNULL_END
