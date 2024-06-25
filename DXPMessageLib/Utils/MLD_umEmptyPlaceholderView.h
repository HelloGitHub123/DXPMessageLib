//
//  MLD_umEmptyPlaceholderView.h
//  PelvicFloorPersonal
//
//  Created by 张威 on 2019/7/24.
//  Copyright © 2019 henglongwu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLD_umEmptyPlaceholderView : UIView
// 标题
@property (nonatomic, copy) NSString *title;
// 缺省图片
@property (nonatomic, copy) NSString *imageName;
// 详情
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *descLabel;

// 高度
@property (nonatomic, copy) NSString *topStr;

@end

NS_ASSUME_NONNULL_END
