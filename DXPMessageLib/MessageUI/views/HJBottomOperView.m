//
//  HJBottomOperView.m
//  UserMessage
//
//  Created by 李标 on 2022/12/1.
//

#import "HJBottomOperView.h"
#import <Masonry/Masonry.h>
#import "MessageHeader.h"

@interface HJBottomOperView () {
    BOOL __isSelected;
}

@property (nonatomic, strong) UIButton *selectAllBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) MessageStyleModel *styleModel;
@end


@implementation HJBottomOperView

- (instancetype)initWithFrame:(CGRect)frame styleModel:(MessageStyleModel*)model {
    self = [super initWithFrame:frame];
    if (self) {
		
		self.styleModel = model;
		
        self.backgroundColor = [UIColor whiteColor];
        __isSelected = NO;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.selectAllBtn];
    [self.selectAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(16);
        make.top.equalTo(self.mas_top).offset(19);
        make.height.equalTo(@20);
        make.width.equalTo(@120);
    }];
    
    [self addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing).offset(-16);
        make.top.equalTo(self.mas_top).offset(9);
        make.height.equalTo(@44);
        make.width.equalTo(@156);
    }];
}

#pragma mark -- Method
// select all
- (void)selectAllAction:(id)sender {
    if (__isSelected) {
        [_selectAllBtn setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
    } else {
        [_selectAllBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    __isSelected = !__isSelected;
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(OperViewDelegate)]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(operViewActionBySelectAll:)]) {
            [self.delegate operViewActionBySelectAll:__isSelected];
        }
    }
}

// delete
- (void)deleteAction:(id)sender {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(OperViewDelegate)]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(operViewActionByDeleteAll)]) {
            [self.delegate operViewActionByDeleteAll];
        }
    }
}

// Set delete button state
- (void)setDeleteEnable:(BOOL)isEnable {
    if (isEnable) {
        self.deleteBtn.enabled = YES;
        self.deleteBtn.alpha = 1.0f;
    } else {
        self.deleteBtn.enabled = NO;
        self.deleteBtn.alpha = 0.4f;
    }
}

#pragma mark -- lazy load
- (UIButton *)selectAllBtn {
    if (!_selectAllBtn) {
        _selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectAllBtn addTarget:self action:@selector(selectAllAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectAllBtn setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
        [_selectAllBtn setTitle:self.styleModel.selectAll forState:UIControlStateNormal];
        [_selectAllBtn setTitleColor:UIColorFromRGB_um(0x242424) forState:UIControlStateNormal];
        [_selectAllBtn setTitleEdgeInsets: UIEdgeInsetsMake(0,8,0,0)];
        _selectAllBtn.userInteractionEnabled = YES;
    }
    return _selectAllBtn;
}

- (void)adjustButtonImageViewRightTitleLeftWithButton:(UIButton *)button {
    if (button.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.image.size.width, 0, button.imageView.image.size.width+5)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width, 0, -button.titleLabel.bounds.size.width)];
    } else {
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.image.size.width, 0, button.imageView.image.size.width)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width+5, 0, -button.titleLabel.bounds.size.width)];
    }
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setTitle:self.styleModel.deleteAll forState:UIControlStateNormal];
        [_deleteBtn setBackgroundColor:self.styleModel.bottomDeleteButtonBgColor];
        [_deleteBtn setTitleColor:self.styleModel.bottomDeleteButtonTitleColor forState:UIControlStateNormal];
        _deleteBtn.layer.cornerRadius = 12;
    }
    return _deleteBtn;
}

@end
