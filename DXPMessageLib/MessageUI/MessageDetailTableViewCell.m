//
//  MessageDetailTableViewCell.m
//  UserMessage
//
//  Created by 李标 on 2022/12/2.
//

#import "MessageDetailTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>
#import "MessageLogic.h"
#import "MessageHeader.h"

@interface MessageDetailTableViewCell ()

@end

@implementation MessageDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.messageTitleLab];
    [self.contentView addSubview:self.messageDateLab];
    [self.contentView addSubview:self.messageTextView];
    [self.contentView addSubview:self.imgView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.messageTitleLab.text) {
        [self.messageTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(20);
            make.top.mas_equalTo(self.contentView.mas_top).offset(30);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-11);
        }];
        return;
    }
    
    [self.messageTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.top.mas_equalTo(self.contentView.mas_top).offset(30);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH_um - 60, [self.messageTitleLab sizeThatFits:CGSizeMake(SCREEN_WIDTH_um - 60, 1000)].height));
    }];
    
    [self.messageDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.top.mas_equalTo(self.messageTitleLab.mas_bottom).offset(20);
        make.height.equalTo(@14);
    }];

    [self.messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.messageDateLab);
        make.top.mas_equalTo(self.messageDateLab.mas_bottom).offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.top.mas_equalTo(self.messageTextView.mas_bottom).offset(20);
        make.height.equalTo(@(self.h_imgView));
        //        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-11);
    }];
}

- (void)setImgURl:(NSString *)imgURl {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgURl] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.h_imgView));
        }];
    }];
}

- (void)setMessageStr:(NSMutableAttributedString *)messageStr {
    _messageStr = messageStr;
    
    _messageTextView.attributedText = _messageStr;
    _messageTextView.textColor = UIColorFromRGB_um(0x242424);
	_messageTextView.font = [UIFont systemFontOfSize:14];
    
    CGFloat fixedWidth = _messageTextView.frame.size.width;
    CGSize newSize = [_messageStr boundingRectWithSize:CGSizeMake(fixedWidth, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                             context:nil].size;

    CGFloat newHeight = ceil(newSize.height); // 取上整，以确保内容完全显示
    [self.messageTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.greaterThanOrEqualTo(@(newHeight)); // 更新高度约束
    }];
}

#pragma mark -- lazy load
- (UILabel *)messageTitleLab {
    if (!_messageTitleLab) {
        _messageTitleLab = [[UILabel alloc] init];
        _messageTitleLab.textColor = UIColorFromRGB_um(0x242424);
		_messageTitleLab.font = [UIFont boldSystemFontOfSize:20];
        _messageTitleLab.textAlignment = NSTextAlignmentLeft;
        _messageTitleLab.numberOfLines = 0;
    }
    return _messageTitleLab;
}

- (UILabel *)messageDateLab {
    if (!_messageDateLab) {
        _messageDateLab = [[UILabel alloc] init];
        _messageDateLab.textAlignment = NSTextAlignmentLeft;
        _messageDateLab.textColor = UIColorFromRGB_um(0x858585);
		_messageDateLab.font = [UIFont systemFontOfSize:14];
    }
    return _messageDateLab;
}

- (UITextView *)messageTextView {
    if (!_messageTextView) {
        _messageTextView = [[UITextView alloc] init];
        _messageTextView.editable = NO;
        _messageTextView.scrollEnabled = NO;
        _messageTextView.textColor = UIColorFromRGB_um(0x242424);
		_messageTextView.font = [UIFont systemFontOfSize:14];
        _messageTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    }
    return _messageTextView;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

@end
