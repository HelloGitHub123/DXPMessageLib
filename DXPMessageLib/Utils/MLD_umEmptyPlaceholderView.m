//
//  MLD_umEmptyPlaceholderView.m
//  PelvicFloorPersonal
//
//  Created by 张威 on 2019/7/24.
//  Copyright © 2019 henglongwu. All rights reserved.
//

#import "MLD_umEmptyPlaceholderView.h"
#import <Masonry/Masonry.h>
#import "MessageHeader.h"

@interface MLD_umEmptyPlaceholderView ()

@end

@implementation MLD_umEmptyPlaceholderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.imageView];
        
        [self addSubview:self.titleLabel];
        
        [self addSubview:self.descLabel];
        
        [self addSubview:self.button];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-16);
            make.centerX.mas_equalTo(0);
        }];
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            make.width.mas_equalTo(230);
            make.centerX.mas_equalTo(0);
        }];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descLabel.mas_bottom).offset(16);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(156, 40));
        }];
    }
    return self;
}


/**
 set方法

 @param imageName 图片名称
 */
- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}

/**
 set方法

 @param title 设置提示语
 */
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

/**
 set方法

 @param desc 设置提示语
 */
- (void)setDesc:(NSString *)desc{
    
    _desc = desc;
    self.descLabel.text = desc;
    
}


- (void)setTopStr:(NSString *)topStr{
    _topStr = topStr;
    long topDig = [topStr longLongValue];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(topDig/2);
    }];
}
/// 点击按钮
/// @param sender button
- (void)buttonClick:(UIButton *)sender {
    
}

#pragma mark -- lazy load

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"ic_no_data"];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"No Data";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    return _titleLabel;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"Reload" forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:16];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _button.layer.cornerRadius = 8;
    }
    return _button;
}


- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.text = @"No Data";
        _descLabel.textColor = normalLabelColor_um;
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

@end
