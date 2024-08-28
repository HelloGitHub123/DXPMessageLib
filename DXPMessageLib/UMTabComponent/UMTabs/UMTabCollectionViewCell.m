//
//  HJTabCollectionViewCell.m
//  HJControls
//
//  Created by mac on 2022/10/12.
//

#import "UMTabCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <DXPToolsLib/HJTool.h>
#import "MessageHeader.h"

@implementation UMTabCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = UIColorFromRGB_um(0xFFFFFF);

        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.lineView];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.centerX.mas_equalTo(0);
            make.leading.mas_greaterThanOrEqualTo(12);
            make.trailing.mas_lessThanOrEqualTo(-12);
            make.bottom.equalTo(self.lineView.mas_top).offset(-12);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(4);
        }];

    }
    return self;
}

- (void)setContentWithText:(NSString *)text currentIndex:(NSInteger)currentIndex selectIndex:(NSInteger)selectIndex {
    self.titleLab.text = text;
    
    if (currentIndex == selectIndex) {
		self.titleLab.textColor = self.styleModel.titleColor;
		self.titleLab.font = [UIFont boldSystemFontOfSize:16];
        self.lineView.hidden = NO;
    } else {
		self.titleLab.textColor = self.styleModel.unSelectedTitleColor;
		self.titleLab.font =  [UIFont systemFontOfSize:16];
        self.lineView.hidden = YES;
    }
	_lineView.backgroundColor = self.styleModel.lineColor;
}

#pragma mark - lazy
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    return _titleLab;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.layer.cornerRadius = 2;
    }
    return _lineView;
}

@end
