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
#import <WebKit/WebKit.h>

@interface MessageDetailTableViewCell ()<UITextViewDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;
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
	//	[self.contentView addSubview:self.messageTextView];
	[self.contentView addSubview:self.webview];
    [self.contentView addSubview:self.imgView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.messageTitleLab.text) {
        [self.webview mas_updateConstraints:^(MASConstraintMaker *make) {
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

    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.messageDateLab);
        make.top.mas_equalTo(self.messageDateLab.mas_bottom).offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
//        make.height.greaterThanOrEqualTo(@20);
		make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-self.h_imgView);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
//        make.top.mas_equalTo(self.messageTextView.mas_bottom).offset(20);
		make.top.mas_equalTo(self.webview.mas_bottom).offset(20);
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

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
	if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
		NSURL *URL = navigationAction.request.URL;
		if ([URL absoluteString].length > 0) {
			if(self.clickDetailUrl) {
				self.clickDetailUrl(URL);
			}
			decisionHandler(WKNavigationActionPolicyAllow);
		} else {
			decisionHandler(WKNavigationActionPolicyCancel);
		}
	} else {
		decisionHandler(WKNavigationActionPolicyAllow);
	}
}

- (void)setMessageStr:(NSString *)messageStr {
	_messageStr = messageStr;
	
	NSString *string = [NSString stringWithFormat:@"%@%@%@",@"<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, user-scalable=0\" /</head><body>",messageStr,@"</body></html>"];
	
	[self.webview loadHTMLString:string baseURL:nil];
	
	//	_messageTextView.attributedText = _messageStr;
	//	_messageTextView.textColor = UIColorFromRGB(0x242424);
	//	_messageTextView.font = systemFont(14);
	//
	//	CGFloat fixedWidth = _messageTextView.frame.size.width;
	//	CGSize newSize = [_messageStr boundingRectWithSize:CGSizeMake(fixedWidth, MAXFLOAT)
	//											   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
	//											   context:nil].size;
	//
	//	CGFloat newHeight = ceil(newSize.height); // 取上整，以确保内容完全显示
	//	[self.messageTextView mas_updateConstraints:^(MASConstraintMaker *make) {
	//		make.height.greaterThanOrEqualTo(@(newHeight)); // 更新高度约束
	//	}];
}

#pragma mark - UITextViewDelegate 点富文本
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction  API_AVAILABLE(ios(10.0)){
  
    if(self.clickDetailUrl) {
        self.clickDetailUrl(URL);
    }
    
    return YES;
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

//- (UITextView *)messageTextView {
//    if (!_messageTextView) {
//        _messageTextView = [[UITextView alloc] init];
//        _messageTextView.editable = NO;
//        _messageTextView.scrollEnabled = NO;
//        _messageTextView.delegate = self;
//        _messageTextView.textColor = UIColorFromRGB_um(0x242424);
//		_messageTextView.font = [UIFont systemFontOfSize:14];
//        _messageTextView.dataDetectorTypes = UIDataDetectorTypeAll;
//    }
//    return _messageTextView;
//}

- (WKWebView *)webview {
	if (!_webview) {
		_webview = [[WKWebView alloc] init];
		_webview.navigationDelegate = self;
	}
	return _webview;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

@end
