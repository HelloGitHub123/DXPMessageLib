//
//  MessageDetailViewController.m
//  UserMessage
//
//  Created by 李标 on 2022/11/29.
//

#import "MessageDetailViewController.h"
#import "MessageDetailTableViewCell.h"
#import <Masonry/Masonry.h>
#import <YYText/YYText.h>
#import "MessageHeader.h"

#define isNull(x)                (!x || [x isKindOfClass:[NSNull class]])
#define isEmptyString(x)         (isNull(x) || [x isEqual:@""] || [x isEqual:@"(null)"] || [x isEqual:@"null"] || [x isEqual:@"<null>"])

#define cell_Identifier   @"MessageDetailIdentifier"

@interface MessageDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) MessageLogic *messageLogic;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MessageDetailModel *messageDetailModel;

@property (nonatomic, strong) Message *messageModel;
@end

@implementation MessageDetailViewController
- (void)initDataFromParmas{
    @try {
        _messageModel = [self.paramsDic valueForKey:@"messageModel"];
    } @catch (NSException *exception) {
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.styleModel.details;
    self.view.backgroundColor = UIColorFromRGB_um(0xF5F5F5);
    
    [self.view addSubview:self.tableView];
    [self requestMessageDetail:self.messageModel];
}

- (void)viewDidLayoutSubviews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.width.mas_equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
}

// 请求消息详情内容
- (void)requestMessageDetail:(Message *)messageModel {
    [self.messageLogic requestMessageDetailByMessageId:messageModel.messageId block:^(MessageDetailModel *messageDetailModel, NSString *errorMsg) {
        if (messageDetailModel) {
            self.messageDetailModel = messageDetailModel;
            [self.tableView reloadData];
            
            if (self.showMessageDetailListComplete){
                self.showMessageDetailListComplete();
            }
        }
    }];
}

#pragma mark -- tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return self.messageModel.imgHeight + 120 + [self getSpaceLabelHeightwithSpeace:0 withFont:[UIFont systemFontOfSize:14] withWidth:SCREEN_WIDTH_um-40];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Identifier];
    if (!cell) {
        cell = [[MessageDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_Identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.messageTitleLab.text = self.messageModel.title;
    cell.messageDateLab.text = [self getddMMyyyyHHmmssByDateTimeFormat:self.messageModel.pushDate];
    cell.h_imgView = self.messageModel.imgHeight;
    cell.imgURl = self.messageModel.thumbUrl;
    if (!isEmptyString_um(self.messageDetailModel.content)) {
        NSMutableAttributedString *attri_str= [self praseHtmlStr:self.messageDetailModel.content];        
        [attri_str setYy_lineSpacing:0];
        attri_str.yy_minimumLineHeight = 22;
        cell.messageStr = attri_str;
    }
    cell.clickDetailUrl = ^(NSURL * _Nonnull url) {
        if(self.clickUrl) {
            self.clickUrl(url);
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  0.1f;
}

#pragma mark -- lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = YES;
        _tableView.rowHeight = [[UIScreen mainScreen] bounds].size.height;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = YES;
        [_tableView registerClass:[MessageDetailTableViewCell class] forCellReuseIdentifier:@"MessageDetailIdentifier"];
    }
    return _tableView;
}

- (MessageLogic *)messageLogic {
    if (!_messageLogic) {
        _messageLogic = [[MessageLogic alloc] init];
    }
    return _messageLogic;
}

#pragma mark -- other
- (NSMutableAttributedString *)praseHtmlStr:(NSString *)htmlStr {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@""];
    if (!isEmptyString_um(htmlStr)) {
        if ([htmlStr containsString:@"<p"]) {
            attStr = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        } else {
            attStr = [[NSMutableAttributedString alloc] initWithString:htmlStr];
        }
    }
	[attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attStr.length)];
    return attStr;
}

/**
 *  计算富文本字体高度
 *
 *  @param lineSpeace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 富文本高度
 */
- (CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
//    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
//                          };
    if (isEmptyString_um(self.messageDetailModel.content)) {
        return 0;
    }
    NSMutableAttributedString *attri_str= [self praseHtmlStr:self.messageDetailModel.content];
    [attri_str setYy_lineSpacing:0];
    attri_str.yy_minimumLineHeight = 22;
    CGRect size = [attri_str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return size.size.height;
}

// 将yyyy-mm-dd HH:mm:ss 转换成 dd MM yyyy HH:mm:ss
- (NSString *)getddMMyyyyHHmmssByDateTimeFormat:(NSString *)dateStr {
	if (isEmptyString_um(dateStr)) {
		return dateStr;
	}
	NSArray *dateArr = [dateStr componentsSeparatedByString:@" "];
	NSArray *firstArr = [dateArr[0] componentsSeparatedByString:@"-"]; // @[yyyy,mm,dd]
	NSString *month = [self getMonthEnNameWithStr:firstArr[1]]; // 转换月份为文字
	
	if (!isEmptyString(self.dateFormater)) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
		[formatter setDateFormat:@"HH:mm:ss"];//输入的日期格式
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
		
		NSString *dateFormatStr = @"";
		
		if ([self.dateFormater containsString:@"hh"]) {
			dateFormatStr = [NSString stringWithFormat:@"%@%@", dateFormatStr, @"hh:mm:ss"];
		} else {
			dateFormatStr = [NSString stringWithFormat:@"%@%@", dateFormatStr, @"HH:mm:ss"];
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
