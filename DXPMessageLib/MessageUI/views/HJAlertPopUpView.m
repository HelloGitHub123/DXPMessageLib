//
//  HJAlertPopUpView.m
//  UserMessage
//
//  Created by 李标 on 2022/11/29.
//

#import "HJAlertPopUpView.h"
#import <Masonry/Masonry.h>
#import "MessageHeader.h"

static CGFloat kTransitionDuration = 0.3;

@interface HJAlertPopUpView ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIButton *okBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) MessageStyleModel *styleModel;
@end

@implementation HJAlertPopUpView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title contentText:(NSString *)contentText okBtnTitle:(NSString *)okBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle styleModel:(MessageStyleModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
		
		self.styleModel = model;
		
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        // 弹框视图
        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(kScreenWidth-50*2);
            make.center.mas_equalTo(0);
            make.leading.mas_equalTo(40);
            make.trailing.mas_equalTo(-40);
        }];
//        [self.backView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [self.backView setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        // title
        [self.backView addSubview:self.titleLab];
        NSInteger H_Titlelab = 0;
        NSInteger vTopMargin = 0;
        if (title && ![title isEqualToString:@""]) {
            H_Titlelab = 22;
            vTopMargin = 24;
            self.titleLab.text = title;
        }
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.backView.mas_leading).offset(24);
            make.trailing.equalTo(self.backView.mas_trailing).offset(-24);
            make.top.equalTo(self.backView.mas_top).offset(vTopMargin);
            make.height.equalTo(@(H_Titlelab));
        }];
        // content
        [self.backView addSubview:self.contentLab];
        CGFloat H_Content = 0;
        if (contentText && ![contentText isEqualToString:@""]) {
            self.contentLab.text = contentText;
            //  计算内容的高度
            H_Content = [self heightForString:contentText fontSize:22 andWidth:kScreenWidth_um-40*2-24*2];
        }
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.backView.mas_leading).offset(24);
            make.trailing.equalTo(self.backView.mas_trailing).offset(-24);
            make.top.equalTo(self.titleLab.mas_bottom).offset(24);
            make.height.equalTo(@(H_Content));
        }];
        // 按钮
        [self.backView addSubview:self.cancelBtn];
        [self.cancelBtn setTitle:cancelBtnTitle forState:UIControlStateNormal];
        NSInteger btn_width = (kScreenWidth_um-40*2-24*2-12)/2;
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.backView.mas_leading).offset(24);
            make.width.equalTo(@(btn_width));
            make.height.equalTo(@40);
            make.top.equalTo(self.contentLab.mas_bottom).offset(16);
        }];
        [self.backView addSubview:self.okBtn];
        [self.okBtn setTitle:okBtnTitle forState:UIControlStateNormal];
        [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.cancelBtn.mas_trailing).offset(12);
            make.trailing.equalTo(self.backView.mas_trailing).offset(-24);
            make.height.equalTo(@40);
            make.top.equalTo(self.contentLab.mas_bottom).offset(16);
        }];
        
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.okBtn.mas_bottom).offset(24);
        }];
    }
    return self;
}

// fontSize 为 行高
- (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width {
	CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

#pragma mark - Method
/*
 * 展示自定义AlertView
 */
- (void)show {
//    [Tools currentVC]
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

//- (void)willMoveToSuperview:(UIView *)newSuperview {
//    if (newSuperview == nil) {
//        return;
//    }
//    // 一系列动画效果,达到反弹效果
//    self.backView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.05, 0.05);
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:kTransitionDuration/2];
//    [UIView setAnimationDelegate:self.backView];
//    [UIView setAnimationDidStopSelector:@selector(bounceAnimationStopped)];
//    self.backView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
//    [UIView commitAnimations];
//
//    [super willMoveToSuperview:newSuperview];
//}
//
//#pragma mark - 缩放
//- (void)bounceAnimationStopped {
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:kTransitionDuration/2];
//    [UIView setAnimationDelegate:self.backView];
//    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
//    self.backView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7);
//    [UIView commitAnimations];
//}
//
//#pragma mark - 缩放
//- (void)bounce2AnimationStopped {
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:kTransitionDuration/2];
//    self.backView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
//    [UIView commitAnimations];
//}

- (void)dismissAlert {
    [self remove];
}

- (void)remove {
    [self removeFromSuperview];
}

- (void)cancelBtnClick:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismissAlert];
}

- (void)okBtnAction:(UIButton *)sender {
    if (self.okBlock) {
        self.okBlock(@"");
    }
    [self dismissAlert];
}

#pragma mark -- lazy load
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 16;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentCenter;
		_titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = UIColorFromRGB_um(0x545454);
        _titleLab.numberOfLines = 0;
        _titleLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _titleLab;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textAlignment = NSTextAlignmentCenter;
		_contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.textColor = UIColorFromRGB_um(0x545454);
        _contentLab.numberOfLines = 0;
        _contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _contentLab;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setBackgroundColor:UIColorFromRGB_um(0xFFFFFF)];
        [_cancelBtn setTitle:self.styleModel.btn_cancel forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColorFromRGB_um(0x242424) forState:UIControlStateNormal];
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = UIColorFromRGB_um(0xD5D5D5).CGColor;
        _cancelBtn.layer.cornerRadius = 8;
		_cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _cancelBtn;
}

- (UIButton *)okBtn {
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_okBtn setBackgroundColor:self.styleModel.popBgOKButtonColor];
        [_okBtn setTitle:self.styleModel.btn_ok forState:UIControlStateNormal];
        [_okBtn setTitleColor:self.styleModel.popOKButtonColor forState:UIControlStateNormal];
        _okBtn.layer.cornerRadius = 8;
		_okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _okBtn;
}

@end
