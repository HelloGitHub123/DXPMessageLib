//
//  MessageTableViewCell.m
//  UserMessage
//
//  Created by 李标 on 2022/11/23.
//

#import "MessageTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>
#import <Masonry/Masonry.h>
#import "MessageHeader.h"

#define isNull(x)                (!x || [x isKindOfClass:[NSNull class]])

@interface MessageTableViewCell ()

@property (nonatomic, strong) Message *message; //

@property (nonatomic, strong) UIView *backView; // 背景view
@property (nonatomic, strong) UIView *baseContainer; // 存放视图的view
// 界面元素
@property (nonatomic, strong) UIButton *selectBtn; // 选择按钮
@property (nonatomic, strong) UIView *unreadView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *detailImgView;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *contentLab;
@end


@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self ==  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.btnCornerRadius = 16;
        
        [self.contentView addSubview:self.backView];
        [self configView];
    }
    return self;
}

- (void)configView {
    // 背景底板
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(0);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(0);
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
    }];
    // 容器
    [self.backView addSubview:self.baseContainer];
    [self.baseContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backView.mas_leading).offset(16);
        make.trailing.equalTo(self.backView.mas_trailing).offset(-16);
        make.top.equalTo(self.backView.mas_top).offset(16);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-16);
    }];
    // 选择按钮
    [self.backView addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.mas_centerY);
        make.leading.equalTo(self.backView.mas_leading).offset(12);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
//    // 未读标识
//    [self.baseContainer addSubview:self.unreadView];
//    [self.unreadView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.baseContainer.mas_leading).offset(0);
//        make.top.equalTo(self.baseContainer.mas_top).offset(9);
//        make.width.equalTo(@6);
//        make.height.equalTo(@6);
//    }];
    // 详情图标
    [self.baseContainer addSubview:self.detailImgView];
    [self.detailImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        make.trailing.equalTo(self.baseContainer.mas_trailing).offset(-8);
        make.top.equalTo(self.baseContainer.mas_top).offset(0);
    }];
    // 标题
    [self.baseContainer addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.baseContainer.mas_leading).offset(14);
        make.top.equalTo(self.baseContainer.mas_top).offset(0);
//        make.height.equalTo(@24);
        make.trailing.equalTo(self.detailImgView.mas_leading).offset(-16);
    }];
    
    // 未读标识
    [self.baseContainer addSubview:self.unreadView];
    [self.unreadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.baseContainer.mas_leading).offset(0);
//        make.top.equalTo(self.baseContainer.mas_top).offset(9);
        make.centerY.equalTo(self.titleLab.mas_centerY);
        make.width.equalTo(@6);
        make.height.equalTo(@6);
    }];
    
    // 日期
    [self.baseContainer addSubview:self.dateLab];
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.baseContainer.mas_leading).offset(0);
        make.top.equalTo(self.titleLab.mas_bottom).offset(8);
        make.height.equalTo(@22);
        make.trailing.equalTo(self.baseContainer.mas_trailing).offset(0);
    }];
    // 图片
    [self.baseContainer addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLab.mas_bottom).offset(8);
        make.leading.equalTo(self.baseContainer.mas_leading).offset(0);
        make.trailing.equalTo(self.baseContainer.mas_trailing).offset(0);
        make.height.equalTo(@0);
    }];
    // 内容
    [self.baseContainer addSubview:self.contentLab];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(12);
        make.leading.equalTo(self.baseContainer.mas_leading).offset(0);
        make.trailing.equalTo(self.baseContainer.mas_trailing).offset(0);
        make.bottom.equalTo(self.baseContainer.mas_bottom).offset(0);
    }];
}

// 绑定model
- (void)bindCellModel:(Message *)message isEdit:(BOOL)isEdit tableview:(UITableView *)tableView {
    self.message = message;
    
    if (isEdit) {
        // 处于编辑状态
        [self.baseContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.backView.mas_leading).offset(44);
        }];
        [self selectBtnShow:YES];
    } else {
        // 处于非编辑状态
        [self.baseContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.backView.mas_leading).offset(16);
        }];
        [self selectBtnShow:NO];
    }
    
    if ([message.state isEqualToString:@"R"]) {
        // 已读状态
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.baseContainer.mas_leading).offset(0);
        }];
        self.unreadView.hidden = YES;
    } else {
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.baseContainer.mas_leading).offset(14);
        }];
        self.unreadView.hidden = NO;
    }
    // 标题
    if (message.title && ![message.title isEqualToString:@""]) {
        self.titleLab.text = message.title;
        
		CGFloat H_title = [self textHeightByWidth:SCREEN_WIDTH_um-16*4-20-16 withFont:[UIFont boldSystemFontOfSize:16] string:message.title];

        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(H_title));
        }];
    } else {
        self.titleLab.text = @"";
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
    }
    
    // 失效日期
    if (message.pushDate && ![message.pushDate isEqualToString:@""]) {
        self.dateLab.text = [self getddMMyyyyHHmmssByDateTimeFormat:message.pushDate];
    }
    // 缩略图片
    if (message.thumbUrl && ![message.thumbUrl isEqualToString:@""] && ([message.thumbUrl containsString:@"https://"] || [message.thumbUrl containsString:@"http://"])) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:message.thumbUrl] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(image.size.height));
            }];
            message.imgHeight = image.size.height;
            [tableView beginUpdates];
            [tableView endUpdates];
        }];
    } else {
        [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
            make.top.equalTo(self.dateLab.mas_bottom).offset(0);
        }];
        message.imgHeight = 0;
        [tableView beginUpdates];
        [tableView endUpdates];
    }
    // 文本内容
	if (message.brief && ![message.brief isEqualToString:@""]) {
		self.contentLab.text = message.brief;
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        // 行高
        paragraphStyle.maximumLineHeight = 22;
        paragraphStyle.minimumLineHeight = 22;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        CGFloat baselineOffset = (22 - _contentLab.font.lineHeight) / 4;
        [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
        // 行间距
        paragraphStyle.lineSpacing = 8 - (_contentLab.font.lineHeight - _contentLab.font.pointSize);
        _contentLab.attributedText = [[NSAttributedString alloc] initWithString:_contentLab.text attributes:attributes];
    } else {
        self.contentLab.text = @"";
        [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
            make.top.equalTo(self.imgView.mas_bottom).offset(0);
        }];
    }
}

- (void)selectEditAction:(id)sender {
//    if (self.message.isSelected) {
//        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
//    } else {
//        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
//    }
//    self.message.isSelected = !self.message.isSelected;
//    // 回调
//    if (self.pDelegate && [self.pDelegate conformsToProtocol:@protocol(MessageDelegate)]) {
//        if (self.pDelegate && [self.pDelegate respondsToSelector:@selector(MessageIsSelectedByMessageId:isSelected:)]) {
//            [self.pDelegate MessageIsSelectedByMessageId:self.message.messageId isSelected:self.message.isSelected];
//        }
//    }
    
    [self messageSelectedAction];
}

- (void)messageSelectedAction {
    if (self.message.isSelected) {
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
    } else {
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    self.message.isSelected = !self.message.isSelected;
    // 回调
    if (self.pDelegate && [self.pDelegate conformsToProtocol:@protocol(MessageDelegate)]) {
        if (self.pDelegate && [self.pDelegate respondsToSelector:@selector(MessageIsSelectedByMessageId:isSelected:)]) {
            [self.pDelegate MessageIsSelectedByMessageId:self.message.messageId isSelected:self.message.isSelected];
        }
    }
}

- (void)setSelectBtnByState:(BOOL)isSelected {
    if (isSelected) {
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    } else {
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
    }
}

- (void)selectBtnShow:(BOOL)isShow {
    self.selectBtn.hidden = !isShow;
}

#pragma mark -- lazy load
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor clearColor];
    }
    return _backView;
}

- (UIView *)baseContainer {
    if (!_baseContainer) {
        _baseContainer = [[UIView alloc] init];
        _baseContainer.backgroundColor = [UIColor whiteColor];
    }
    return _baseContainer;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn addTarget:self action:@selector(selectEditAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
    }
    return _selectBtn;
}

- (UIView *)unreadView {
    if (!_unreadView) {
        _unreadView = [[UIView alloc] init];
        _unreadView.layer.cornerRadius = 3;
        _unreadView.backgroundColor = UIColorFromRGB_um(0xFF8D1B);
    }
    return _unreadView;
}

- (UIImageView *)detailImgView {
    if (!_detailImgView) {
        _detailImgView = [[UIImageView alloc] init];
        _detailImgView.image = [UIImage imageNamed:@"detail"];
    }
    return _detailImgView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = UIColorFromRGB_um(0x242424);
        _titleLab.font = [UIFont boldSystemFontOfSize:16];
        _titleLab.numberOfLines = 0;
        _titleLab.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}

- (UILabel *)dateLab {
    if (!_dateLab) {
        _dateLab = [[UILabel alloc] init];
        _dateLab.textColor = UIColorFromRGB_um(0xB5B5B5);
		_dateLab.font = [UIFont systemFontOfSize:14];
        _dateLab.numberOfLines = 0;
        _dateLab.textAlignment = NSTextAlignmentLeft;
    }
    return _dateLab;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.cornerRadius = 12;
    }
    return _imgView;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = UIColorFromRGB_um(0x242424);
		_contentLab.font = [UIFont systemFontOfSize:14];
        //        _contentLab.numberOfLines = 1;
        _contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLab.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLab;
}

#pragma mark -- other
- (CGFloat)textHeightByWidth:(CGFloat)width withFont:(UIFont*)font string:(NSString *)string {
	NSAssert(font, @"heightForWidth:方法必须传进font参数");
	CGSize labelsize  = [string
						 boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
						options:NSStringDrawingUsesLineFragmentOrigin
						attributes:@{NSFontAttributeName:font}
						context:nil].size;
	return ceilf(labelsize.height);
}

// 将yyyy-mm-dd HH:mm:ss 转换成 dd MM yyyy HH:mm:ss
- (NSString *)getddMMyyyyHHmmssByDateTimeFormat:(NSString *)dateStr {
	if (isEmptyString_um(dateStr)) {
		return dateStr;
	}
	NSArray *dateArr = [dateStr componentsSeparatedByString:@" "];
	NSArray *firstArr = [dateArr[0] componentsSeparatedByString:@"-"]; // @[yyyy,mm,dd]
	NSString *month = [self getMonthEnNameWithStr:firstArr[1]]; // 转换月份为文字
	
	if (!isNull(self.dateFormater) || !self.dateFormater) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
		[formatter setDateFormat:@"HH:mm:ss"];//输入的日期格式
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
		
		NSString *dateFormatStr = @"";
		
		if ([self.dateFormater containsString:@"hh"]) {
			dateFormatStr = [NSString stringWithFormat:@"%@%@", dateFormatStr, @"hh:mm:ss"];
		}
		
		if ([self.dateFormater containsString:@"a"]) {
			dateFormatStr = [NSString stringWithFormat:@"%@ %@", dateFormatStr, @"a"];
		}
		
		[dateFormat setDateFormat:dateFormatStr];//输出的日期格式
		
		NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
		[formatter setLocale:locale];
		[dateFormat setLocale:locale];
		
		NSDate *dateHMS = [formatter dateFromString:dateArr[1]];
		
		NSString *formatDate = [NSString stringWithFormat:@"%@ %@ %@ %@",firstArr[2],month,firstArr[0],[dateFormat stringFromDate:dateHMS]];
		return formatDate;
	}
	
	// 组装
	NSString *timeString = [NSString stringWithFormat:@"%@ %@ %@ %@",firstArr[2],month,firstArr[0],dateArr[1]];
	return timeString;
}

- (NSString *)getMonthEnNameWithStr:(NSString *)str {
	if ([str isEqualToString:@"01"]||[str isEqualToString:@"1"]) {
		return self.styleModel.jan;
	}else if ([str isEqualToString:@"02"]||[str isEqualToString:@"2"]){
		return self.styleModel.feb;
	}else if ([str isEqualToString:@"03"]||[str isEqualToString:@"3"]){
		return self.styleModel.mar;
	}else if ([str isEqualToString:@"04"]||[str isEqualToString:@"4"]){
		return self.styleModel.apr;
	}else if ([str isEqualToString:@"05"]||[str isEqualToString:@"5"]){
		return self.styleModel.may;
	}else if ([str isEqualToString:@"06"]||[str isEqualToString:@"6"]){
		return self.styleModel.jun;
	}else if ([str isEqualToString:@"07"]||[str isEqualToString:@"7"]){
		return self.styleModel.jul;
	}else if ([str isEqualToString:@"08"]||[str isEqualToString:@"8"]){
		return self.styleModel.aug;
	}else if ([str isEqualToString:@"09"]||[str isEqualToString:@"9"]){
		return self.styleModel.sep;
	}else if ([str isEqualToString:@"10"]||[str isEqualToString:@"10"]){
		return self.styleModel.oct;
	}else if ([str isEqualToString:@"11"]||[str isEqualToString:@"11"]){
		return self.styleModel.nov;
	}else if ([str isEqualToString:@"12"]||[str isEqualToString:@"12"]){
		return self.styleModel.dec;
	}
	return @"";
	return @"";
	
}

@end
