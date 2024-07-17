//
//  MessageListViewController.m
//  CLP
//
//  Created by 李标 on 2023/2/3.
//

#import "MessageListViewController.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import "UnreadMessageModel.h"
#import "MessageTableViewCell.h"
#import "HJAlertPopUpView.h"
#import "MessageDetailViewController.h"
#import "HJBottomOperView.h"
#import <DXPToolsLib/SNAlertMessage.h>
#import "MessageHeader.h"
#import "UITableView+umEmptyPlaceholderView.h"

#define cell_Identifier   @"MessageTableViewCellIdentifier"

@interface MessageListViewController ()<UITableViewDelegate,UITableViewDataSource,LYSideslipCellDelegate,MessageDelegate,OperViewDelegate> {
    
}

@property (nonatomic, strong) MessageLogic *messageLogic;
@property (nonatomic, strong) UITableView *vTableview;
@property (nonatomic, strong) UIButton *readAllBtn; // read all button
@property (nonatomic, strong) HJBottomOperView *bottomOperView;
// datasource
@property (nonatomic, strong) NSMutableArray<Message *> *messageList;
// 需要删除的数组列表 存放id<String>类型
@property (nonatomic, strong) NSMutableArray<NSString *> *deleteMessageList;
@property (nonatomic, assign) BOOL isEdit;
//@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) UIBarButtonItem * rightBtn;
@property (nonatomic, strong) UIBarButtonItem * cancelBtn;

@end

@implementation MessageListViewController

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.readAllBtn.hidden = NO;
    self.readAllBtn.userInteractionEnabled = YES;
    // show naigation
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    // 更新已读数量
    [self requestUnReadMessages];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.readAllBtn.hidden = YES;
    self.readAllBtn.userInteractionEnabled = NO;
    // hidden naigation
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    
    // 恢复界面初始状态
    self.isEdit = YES;
    [self updateEditState];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationTitleWithUnreadCount:@"0"];
    self.view.backgroundColor = UIColorFromRGB_um(0xF5F5F5);
    // edit
    self.navigationItem.rightBarButtonItem = self.rightBtn;
    
    // All messages have been read
    [self.navigationController.navigationBar addSubview:self.readAllBtn];
    [self.readAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.navigationController.navigationBar);
        make.left.mas_equalTo(self.navigationController.navigationBar.mas_left).offset(([[UIScreen mainScreen] bounds].size.width + 80) / 2 + 14);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self initData];
    
    // 设置请求token
//    NSString *strToken = [HJGlobalDataManager shareInstance].signInResponseModel.token;
//    [self.messageLogic setHttpRequestToken:strToken];
    
    // 请求消息列表
    [self requestMessageList];

    [self setRefreshState:YES];
    
    // 请求未读消息数量
    [self requestUnReadMessages];
    
    // 初始化底部view
    [[UIApplication sharedApplication].delegate.window addSubview:self.bottomOperView];
    
	// 埋点
	if (self.trackManagementBlock) {
		self.trackManagementBlock(@"ViewMyMessage",@{});
	}
}

- (void)setNavigationTitleWithUnreadCount:(NSString *)unreadCount {

    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(150, 0, 80, 50)];
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=[UIColor blackColor];
	[titleText setFont:[UIFont systemFontOfSize:17]];
	[titleText setText:self.styleModel.navMainTitle];
    self.navigationItem.titleView = titleText;
    
    if ([unreadCount integerValue] > 0) {
        CGFloat w_width = 16;
        if (unreadCount.length >= 2) {
            w_width = 24;
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(66, 7, w_width, 16)];
        view.layer.cornerRadius = 8.f;
        view.backgroundColor = [UIColor redColor];
        [titleText addSubview:view];
        
        UILabel *unreadLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w_width, 16)];
        unreadLab.textColor = [UIColor whiteColor];
        unreadLab.textAlignment = NSTextAlignmentCenter;
		unreadLab.font = [UIFont systemFontOfSize:10];
        unreadLab.text = unreadCount;
        [view addSubview:unreadLab];
    }
}

// 设置刷新功能是否可用
- (void)setRefreshState:(BOOL)isState {
    if (isState) {
        // 下拉刷新
        __weak typeof(self) weakSelf = self;
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf mjRefreshHeader];
            });
        }];
        self.vTableview.mj_header = refreshHeader;
        // 加载更多
        MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf mjRefreshFooterLoadMore];
            });
        }];
        self.vTableview.mj_footer = refreshFooter;
    } else {
        self.vTableview.mj_header = nil;
        self.vTableview.mj_footer = nil;
    }
}

- (void)initData {
    self.messageList = [[NSMutableArray alloc] init];
    self.deleteMessageList = [[NSMutableArray alloc] init];
    self.isEdit = NO;
    
    [self.view addSubview:self.vTableview];
    [self.vTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.top.equalTo(@0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
}

- (void)viewDidLayoutSubviews {
}

#pragma mark -- Method
- (void)setToken:(NSString *)token {
	_token = token;
	// 设置请求token
	[self.messageLogic setHttpRequestToken:token];
}

- (void)setStyleModel:(MessageStyleModel *)styleModel {
	_styleModel = styleModel;
}

// 请求消息列表
- (void)requestMessageList {
    __weak typeof(self) weakSelf = self;
    [self.messageLogic requestMessageListByPageInfoWithBlock:^(MessageListModel *messageListModel, NSString *errorMsg) {
        [weakSelf updateMessageList:messageListModel];
    }];
}

// 下拉刷新
- (void)mjRefreshHeader {
    if ([self.vTableview.mj_header isRefreshing]) {
        [self.vTableview.mj_header endRefreshing];
    }
    [self.messageLogic refreshMessageList];
    
    __weak typeof(self) weakSelf = self;
    _messageLogic.refresMessage = ^(MessageListModel * _Nonnull messageModel) {
        [weakSelf updateMessageList:messageModel];
    };
    
    
}

// 上拉加载更多
- (void)mjRefreshFooterLoadMore {
    if ([self.vTableview.mj_footer isRefreshing]) {
        [self.vTableview.mj_footer endRefreshing];
    }
    
    [self.messageLogic loadMorMessageList];
    
    __weak typeof(self) weakSelf = self;
    _messageLogic.refresMessage = ^(MessageListModel * _Nonnull messageModel) {
        [weakSelf updateMessageList:messageModel];
    };
    
    NSInteger currentPage = [self.messageLogic gitCurrentPageNumber];
    NSLog(@"---------%ld",(long)currentPage);
    
    [self.messageLogic gitCurrentPageSizeWithCompletion:^(NSInteger pageSize, NSString *errorMsg) {
        if (errorMsg) {
            NSLog(@"Error: %@", errorMsg);
        } else {
            NSLog(@"Current Page Size: %ld", (long)pageSize);
        }
    }];
}

// edit
- (void)editAction:(id)sender {
    [self updateEditState];
}

// 更新编辑状态下的界面元素
- (void)updateEditState {
    [self setRefreshState:self.isEdit];
    if (self.isEdit) {
        self.isEdit = NO;
        self.navigationItem.rightBarButtonItem = self.rightBtn;
        [self hideBottomViewAction];
    } else {
        self.isEdit = YES;
        self.navigationItem.rightBarButtonItem = self.cancelBtn;
        [self popBottomViewAction];
    }
    self.vTableview.scrollEnabled = YES;
    [self setDeleteButtonState];
    [self.vTableview reloadData];
}

// 弹出底部view
- (void)popBottomViewAction {
    if (!self.bottomOperView) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.bottomOperView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.bottomOperView.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.bottomOperView.frame.size.height)];
    } completion:^(BOOL finished) {
        [self.vTableview mas_updateConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.bottom.mas_equalTo(-self.bottomOperView.frame.size.height);
            } else {
                make.bottom.mas_equalTo(-self.bottomOperView.frame.size.height);
            }
        }];
    }];
    [self setDeleteButtonState];
}

// 隐藏底部view
- (void)hideBottomViewAction {
    if (!self.bottomOperView) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.bottomOperView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.bottomOperView.frame.size.height)];
    } completion:^(BOOL finished) {
        [self.vTableview mas_updateConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom);
            } else {
                make.bottom.mas_equalTo(0);
            }
        }];
    }];
}

// 编辑状态下，delete按钮的状态
- (void)setDeleteButtonState {
    if (self.deleteMessageList.count > 0) {
        [self.bottomOperView setDeleteEnable:YES];
    } else {
        [self.bottomOperView setDeleteEnable:NO];
    }
}

// read all
- (void)readAllAction:(id)sender {
    // 埋点回调
	if (self.trackManagementBlock) {
		self.trackManagementBlock(@"SetAllRead", @{});
	}

	HJAlertPopUpView *popView = [[HJAlertPopUpView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) title:@"" contentText:self.styleModel.tip_MessageRead okBtnTitle:self.styleModel.btn_yes cancelBtnTitle:self.styleModel.btn_cancel styleModel:self.styleModel];
    [popView show];
    __weak typeof(self) weakSelf = self;
    popView.okBlock = ^(NSString *text) {
        [self.messageLogic requestMessageSetAllReadWithBlock:^(MarkAllMessagesReadModel *markAllMessagesReadModel, NSString *errorMsg) {
            if (markAllMessagesReadModel) {
                if (markAllMessagesReadModel.result) {
                    // 设置消息状态为已读
                    for (int i = 0; i<weakSelf.messageList.count; i++) {
                        Message *messageItem = [weakSelf.messageList objectAtIndex:i];
                        messageItem.state = @"R";
                    }
                    [weakSelf.vTableview reloadData];
                    NSLog(@"所有已读成功");
                    // 更新已读数量
                    [weakSelf requestUnReadMessages];
                } else {
                    NSLog(@"所有已读失败");
                }
            }
        }];
    };
    popView.cancelBlock = ^ {
    };
}

// unRead Messages
- (void)requestUnReadMessages {
    [SNAlertMessage displayLoadingInViewInView:[UIApplication sharedApplication].delegate.window Message:@""];
    __weak typeof(self) weakSelf = self;
    [self.messageLogic requestUnreadMessageWithBlock:^(UnreadMessageModel *unreadMessageModel, NSString *errorMsg) {
        [SNAlertMessage hideLoading];
        if (unreadMessageModel) {
            NSString *msgCount = ([unreadMessageModel.unReadCount intValue] > 99) ? @"99+": unreadMessageModel.unReadCount;
            [weakSelf setNavigationTitleWithUnreadCount:msgCount];
        } else {
            // 接口调用失败
            [weakSelf setNavigationTitleWithUnreadCount:@"0"];
        }
    }];
}

// List of request messages
- (void)updateMessageList:(MessageListModel *)messageListModel {
    if (messageListModel) {
        if (messageListModel.messageList.count > 0) {
            if (self.messageLogic.currentPage == 1) {
                [self.messageList removeAllObjects];
            }
            [self.messageList addObjectsFromArray:messageListModel.messageList];
            
            [self.vTableview reloadData];
        }
        // 判断导航栏edit是否隐藏
        if (self.messageList.count == 0) {
            self.navigationItem.rightBarButtonItem = nil;
            self.readAllBtn.hidden = YES;
            self.readAllBtn.userInteractionEnabled = NO;
        } else {
            self.navigationItem.rightBarButtonItem = self.rightBtn;
            self.readAllBtn.hidden = NO;
            self.readAllBtn.userInteractionEnabled = YES;
        }
        [self.vTableview showEmptyViewRowCount:self.messageList.count];
        if (self.showMessageListComplete) {
            self.showMessageListComplete();
        }
    }
        
}

// Set messages to be read 设置单个信息已读
- (void)requestMessageSetReadByMessage:(NSString *)messageIds indexPath:(NSIndexPath *)indexPath {
	// 埋点回调
	if (self.trackManagementBlock) {
		self.trackManagementBlock(@"ReadSingleMessage", @{});
	}

    [SNAlertMessage displayLoadingInViewInView:[UIApplication sharedApplication].delegate.window Message:@""];
    __weak typeof(self) weakSelf = self;
    [self.messageLogic requestMessageSetReadByMessageIds:messageIds userId:@"" state:@"R" eventCode:@"" block:^(MarkMessageReadModel *markMessageReadModel, NSString *errorMsg) {
        [SNAlertMessage hideLoading];
        if (markMessageReadModel) {
            if (markMessageReadModel.result) {
                Message *messageModel = [weakSelf.messageList objectAtIndex:indexPath.section];
                messageModel.state = @"R";
                [weakSelf.vTableview reloadData];
                NSLog(@"已读成功");
                // 更新已读数量
                [weakSelf requestUnReadMessages];
            } else {
                NSLog(@"已读失败");
            }
        }
    }];
}

// Delete individual messages 删除单个信息
- (void)requestDeleteMessageByMessage:(Message *)message indexPath:(NSIndexPath *)indexPath {
	// 埋点回调
	if (self.trackManagementBlock) {
		self.trackManagementBlock(@"DeleteSingleMessage", @{});
	}

    HJAlertPopUpView *popView = [[HJAlertPopUpView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) title:@"" contentText:self.styleModel.tip_DeleteMessage okBtnTitle:self.styleModel.btn_yes cancelBtnTitle:self.styleModel.btn_cancel styleModel:self.styleModel];
    [popView show];
    __weak typeof(self) weakSelf = self;
    popView.okBlock = ^(NSString *text) {
        [SNAlertMessage displayLoadingInViewInView:[UIApplication sharedApplication].delegate.window Message:@""];
        [weakSelf.messageLogic requestDeleteMessageByMessageIds:message.messageId block:^(DeleteMessageModel *deleteMessageModel, NSString *errorMsg) {
            [SNAlertMessage hideLoading];
            if (deleteMessageModel) {
                if (deleteMessageModel.result) {
                    //                    Message *messageModel = [self.messageList objectAtIndex:indexPath.section];
                    [weakSelf.messageList removeObjectAtIndex:indexPath.section];
                    // 删除选中消息对应的id
                    NSMutableArray *deleteMessageListTemp = [[NSMutableArray alloc] init];
                    for (int i = 0; i< weakSelf.deleteMessageList.count; i++) {
                        NSString *messageId = [weakSelf.deleteMessageList objectAtIndex:i];
                        for (int j = 0; j<weakSelf.messageList.count ; j++) {
                            Message *messageModel = [weakSelf.messageList objectAtIndex:j];
                            if ([messageId isEqualToString:messageModel.messageId]) {
//                                [weakSelf.deleteMessageList removeObjectAtIndex:j];
                                [deleteMessageListTemp addObject:messageModel.messageId];
                            }
                        }
                    }
                    [weakSelf.deleteMessageList removeObjectsInArray:deleteMessageListTemp];
                    [weakSelf.vTableview reloadData];
                    NSLog(@"删除成功");
                } else {
                    NSLog(@"删除失败");
                }
            }
        }];
    };
    popView.cancelBlock = ^ {
    };
}

#pragma mark -- OperViewDelegate
// 删除选择所有记录
- (void)operViewActionByDeleteAll {
    if (self.deleteMessageList.count > 0) {
        HJAlertPopUpView *popView = [[HJAlertPopUpView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) title:@"" contentText:self.styleModel.tip_DeleteMessages okBtnTitle:self.styleModel.btn_yes cancelBtnTitle:self.styleModel.btn_cancel styleModel:self.styleModel];
        [popView show];
        __weak typeof(self) weakSelf = self;
        popView.okBlock = ^(NSString *text) {
			// 埋点回调
			if (self.trackManagementBlock) {
				self.trackManagementBlock(@"DeleteMoreMessage", @{@"deleteAmount":@(self.deleteMessageList.count)});
			}
			
            // 拼接messageIds => "id,id,id"
            NSString *strIds = [self.deleteMessageList objectAtIndex:0];
            for (int i = 1; i<= [self.deleteMessageList count]-1; i++) {
                NSString *idStr = [self.deleteMessageList objectAtIndex:i];
                strIds = [strIds stringByAppendingFormat:@",%@",idStr];
            }
            [SNAlertMessage displayLoadingInViewInView:[UIApplication sharedApplication].delegate.window Message:@""];
            [weakSelf.messageLogic requestDeleteMessageByMessageIds:strIds block:^(DeleteMessageModel *deleteMessageModel, NSString *errorMsg) {
                [SNAlertMessage hideLoading];
                if (deleteMessageModel) {
                    if (deleteMessageModel.result) {
                        // 关闭编辑弹框
                        [self updateEditState];
                        // 轮训找出对应的messageId
                        NSMutableArray <Message *>*deleteMessageModel = [[NSMutableArray alloc] init];
                        NSMutableArray *deleteMessageListTemp = [[NSMutableArray alloc] init];
                        
                        for (int i = 0; i<self.deleteMessageList.count; i++) {
                            NSString *messageId = [self.deleteMessageList objectAtIndex:i];
                            for (int j = 0; j<self.messageList.count; j++) {
                                Message *messageItem = [self.messageList objectAtIndex:j];
                                if ([messageItem.messageId isEqualToString:messageId]) {
//                                    [self.messageList removeObjectAtIndex:j];
//                                    [self.deleteMessageList removeObjectAtIndex:i];
                                    [deleteMessageModel addObject:messageItem];
                                    [deleteMessageListTemp addObject:messageItem.messageId];
                                }
                            }
                        }
                        [weakSelf.messageList removeObjectsInArray:deleteMessageModel];
                        [weakSelf.deleteMessageList removeObjectsInArray:deleteMessageListTemp];
                        [weakSelf.vTableview reloadData];
                        NSLog(@"删除成功");
                    } else {
                        NSLog(@"删除失败");
                    }
                }
            }];
        };
        popView.cancelBlock = ^ {
        };
    }
}

// 选择所有记录
- (void)operViewActionBySelectAll:(BOOL)isSelected {
    if (isSelected) {
        for (Message *model in self.messageList) {
            model.isSelected = YES;
            [self.deleteMessageList addObject:model.messageId];
        }
    } else {
        for (Message *model in self.messageList) {
            model.isSelected = NO;
            [self.deleteMessageList removeObject:model.messageId];
        }
    }
    // 更新编辑态，删除按钮的状态
    [self setDeleteButtonState];
    // 刷新界面
    [self.vTableview reloadData];
}

#pragma mark -- tableView delegate && datasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *messageModel = [self.messageList objectAtIndex:indexPath.section];
//    return [messageModel getCellHeight];
    
	CGFloat H_title = [self textHeightByWidth:SCREEN_WIDTH_um-16*4-20-16 withFont:[UIFont boldSystemFontOfSize:16] string:messageModel.title];
    
    CGFloat totalHeight = 0;

    NSInteger H_CellTopBottomPadding = 8; // cell距离分割线的距离（包含上下）
    NSInteger H_TitleTopPadding = 16; //标题距离Backview 顶部的距离
    NSInteger H_Title = H_title;
    NSInteger H_DateTopPadding = 8; // 日期距离标题底部的距离
    NSInteger H_Date = 22;
    NSInteger H_ImgTopPadding = messageModel.imgHeight > 0 ? 8: 0; // 图片距离上面日期底部的距离。如果图片为空，则该距离为0
	NSInteger H_ContentPadding = isEmptyString_um(messageModel.brief)?0: 12;// 内容距离图片底部的距离
    NSInteger H_ContentBottom = 16;
    // 计算cell的高度
    totalHeight = H_CellTopBottomPadding + H_TitleTopPadding + H_Title + H_DateTopPadding + H_Date + H_ImgTopPadding + messageModel.imgHeight + H_ContentPadding + H_ContentBottom + H_CellTopBottomPadding;
    return totalHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.messageList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Identifier forIndexPath:indexPath];
	cell.contentView.layer.cornerRadius = 16;
	cell.delegate = self;
	cell.pDelegate = self;
	cell.styleModel = self.styleModel;
	Message *messageModel = [self.messageList objectAtIndex:indexPath.section];
	[cell bindCellModel:messageModel isEdit:self.isEdit tableview:tableView];
	[cell setSelectBtnByState:messageModel.isSelected];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 编辑状态下不可以进入到详情
    if (self.isEdit) {
        MessageTableViewCell *cell = (MessageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell messageSelectedAction];
        return;
    }

    Message *messageModel = [self.messageList objectAtIndex:indexPath.section];
    if (![messageModel.state isEqualToString:@"R"]) {
        // 未读情况设置为已读
        [self requestMessageSetReadByMessage:messageModel.messageId indexPath:indexPath];
    }
    // detail
    MessageDetailViewController *detailVC = [[MessageDetailViewController alloc] init];
	detailVC.styleModel = self.styleModel;
    detailVC.showMessageDetailListComplete = ^{
        if(self.showMessageDetailList) {
            self.showMessageDetailList();
        }
    };
    detailVC.clickUrl = ^(NSURL * _Nonnull url) {
        if (self.clickMessageDetailkUrl) {
            self.clickMessageDetailkUrl(url);
        }
    };
    @try {
        [detailVC.paramsDic setValue:messageModel forKey:@"messageModel"];
    } @catch (NSException *exception) {
        
    }
    if (self.onMessageClick) {
        self.onMessageClick(messageModel);
    }
    [self.navigationController pushViewController:detailVC animated:YES];
    
	// 埋点回调
	if (self.trackManagementBlock) {
		self.trackManagementBlock(@"ClickMessage", @{});
	}
}

#pragma mark -- MessageDelegate
- (void)MessageIsSelectedByMessageId:(NSString *)messageId isSelected:(BOOL)isSelected {
    if (isSelected) {
        if (![self.deleteMessageList containsObject:messageId]) {
            [self.deleteMessageList addObject:messageId]; // 保存id到待删除的数组中
        }
    } else {
        [self.deleteMessageList removeObject:messageId]; // 从待删除的数组中取出需要删除的id
    }
    // 更新删除按钮状态
    [self setDeleteButtonState];
}

#pragma mark -- LYSideslipCellDelegate
- (NSArray<LYSideslipCellAction *> *)sideslipCell:(LYSideslipCell *)sideslipCell editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *arrayList = [[NSMutableArray alloc] init];
    
    Message *message = [self.messageList objectAtIndex:indexPath.section];
    if (![message.state isEqualToString:@"R"]) {
        LYSideslipCellAction *tagAction = [LYSideslipCellAction rowActionWithStyle:LYSideslipCellActionStyleNormal title:nil handler:^(LYSideslipCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSLog(@"点击了 第%ld行-%ld列",(long)indexPath.section,(long)indexPath.row);
            [sideslipCell hiddenAllSideslip];
            // Set messages to be read
            Message *messageModel = [self.messageList objectAtIndex:indexPath.section];
            [self requestMessageSetReadByMessage:messageModel.messageId indexPath:indexPath];
        }];
        tagAction.backgroundColor = UIColorFromRGB_um(0xFF6E47);
        tagAction.image = [UIImage imageNamed:@"read"];
//        tagAction.title = @"Read";
        tagAction.title = self.styleModel.read;
        
        [arrayList addObject:tagAction];
    }
    
    LYSideslipCellAction *deleteAction = [LYSideslipCellAction rowActionWithStyle:LYSideslipCellActionStyleNormal title:nil handler:^(LYSideslipCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除 点击了 第%ld行-%ld列",(long)indexPath.section,(long)indexPath.row);
        [sideslipCell hiddenAllSideslip];
        // Delete individual messages
        Message *messageModel = [self.messageList objectAtIndex:indexPath.section];
        [self requestDeleteMessageByMessage:messageModel indexPath:indexPath];
    }];
    deleteAction.backgroundColor = UIColorFromRGB_um(0xFA2C2C);
    deleteAction.image = [UIImage imageNamed:@"delete"];
    deleteAction.title = self.styleModel.text_delete;
    
    [arrayList addObject:deleteAction];
    
    return arrayList;
}

#pragma mark -- lazy load
- (MessageLogic *)messageLogic {
    if (!_messageLogic) {
        _messageLogic = [[MessageLogic alloc] init];
        _messageLogic.pageSize = 8;
        _messageLogic.currentPage = 2;
        
    }
    return _messageLogic;
}

- (UITableView *)vTableview {
    if (!_vTableview) {
        _vTableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _vTableview.delegate = self;
        _vTableview.dataSource = self;
        _vTableview.showsVerticalScrollIndicator = NO;
        _vTableview.showsHorizontalScrollIndicator = NO;
        _vTableview.backgroundColor = [UIColor clearColor];
        _vTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _vTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _vTableview.estimatedRowHeight = 154;
        _vTableview.rowHeight = UITableViewAutomaticDimension;
        [_vTableview registerClass:[MessageTableViewCell class] forCellReuseIdentifier:cell_Identifier];
        
        _vTableview.emptyTitle = self.styleModel.noResults;
        _vTableview.emptyImageName = @"ic_no_result";
		_vTableview.emptyDesc = self.styleModel.noMessage;
    }
    return _vTableview;
}

- (UIButton *)readAllBtn {
    if (!_readAllBtn) {
        _readAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_readAllBtn addTarget:self action:@selector(readAllAction:) forControlEvents:UIControlEventTouchUpInside];
        [_readAllBtn setImage:[UIImage imageNamed:@"readAll"] forState:UIControlStateNormal];
    }
    return _readAllBtn;
}

- (HJBottomOperView *)bottomOperView {
    if (!_bottomOperView) {
        if (Is_iPhoneX_Or_More_um) {
            _bottomOperView = [[HJBottomOperView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 96) styleModel:self.styleModel];
        } else {
            _bottomOperView = [[HJBottomOperView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 96 - 34) styleModel:self.styleModel];
        }
        _bottomOperView.delegate = self;
    }
    return _bottomOperView;
}


- (UIBarButtonItem *)rightBtn{
    if(!_rightBtn){
        _rightBtn = [[UIBarButtonItem alloc]initWithTitle:self.styleModel.edit style:UIBarButtonItemStyleDone target:self action:@selector(editAction:)];
        [_rightBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:self.styleModel.rightBarButtonColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} forState:UIControlStateNormal];
        _rightBtn.enabled = YES;
    }
    return _rightBtn;
}

- (UIBarButtonItem *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [[UIBarButtonItem alloc]initWithTitle:self.styleModel.btn_cancel style:UIBarButtonItemStyleDone target:self action:@selector(editAction:)];
        [_cancelBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:self.styleModel.rightBarButtonColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} forState:UIControlStateNormal];
        _cancelBtn.enabled = YES;
    }
    return _cancelBtn;
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

@end
