//
//  UITableView+umEmptyPlaceholderView.m
//  MOC
//
//  Created by Lee on 2022/3/18.
//

#import "UITableView+umEmptyPlaceholderView.h"
#import <objc/runtime.h>
#import "MessageHeader.h"

static NSString *const emptyTitleKey = @"emptyTitle";
static NSString *const emptyDescKey = @"emptyDesc";
static NSString *const emptyTopKey = @"emptyTop";
static NSString *const emptyImageNameKey = @"emptyImageName";
static NSString *const emptyButtonTitleKey = @"emptyButtonTitle";
static NSString *const emptyButtonAttributedTitleKey = @"emptyButtonAttributedTitle";
static NSString *const emptyButtonTitleColorKey = @"emptyButtonTitleColor";
static NSString *const emptyButtonBGColorKey = @"emptyButtonBGColor";
static NSString *const emptyButtonActionKey = @"emptyButtonAction";
static NSString *const emptyKey = @"empty";

static NSString *const emptyDelegateKey = @"emptyDelegate";

@interface UITableView ()

@property (nonatomic, strong) MLD_umEmptyPlaceholderView *emptyView1;

@end

@implementation UITableView (umEmptyPlaceholderView)
/**
 set方法

 @param emptyTitle 缺省提示语
 */
- (void)setEmptyTitle:(NSString *)emptyTitle {
    objc_setAssociatedObject(self, &emptyTitleKey, emptyTitle, OBJC_ASSOCIATION_COPY);
}

/**
 set方法

 @param emptyDesc 缺省提示语
 */
- (void)setEmptyDesc:(NSString *)emptyDesc{
    objc_setAssociatedObject(self, &emptyDescKey, emptyDesc, OBJC_ASSOCIATION_COPY);
}

/**
 set方法

 @param topHeight 高度
 */
- (void)setTopHeight:(NSString *)topHeight {
    objc_setAssociatedObject(self, &emptyTopKey, topHeight, OBJC_ASSOCIATION_COPY);
}



/**
 获得缺省提示语

 @return 返回缺省提示语
 */
- (NSString *)emptyTitle {
    return objc_getAssociatedObject(self, &emptyTitleKey);
}

- (NSString *)emptyDesc {
    return objc_getAssociatedObject(self, &emptyDescKey);
}

- (NSString *)topHeight{
    return objc_getAssociatedObject(self, &emptyTopKey);
}

- (void)setEmptyImageName:(NSString *)emptyImageName {
    
    objc_setAssociatedObject(self, &emptyImageNameKey, emptyImageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)emptyImageName {
    return objc_getAssociatedObject(self, &emptyImageNameKey);
}

- (void)setEmptyButtonTitle:(NSString *)emptyButtonTitle {
    objc_setAssociatedObject(self, &emptyButtonTitleKey, emptyButtonTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)emptyButtonTitle {
    return objc_getAssociatedObject(self, &emptyButtonTitleKey);
}

- (void)setEmptyButtonAttributedTitle:(NSMutableAttributedString *)emptyButtonAttributedTitle {
    objc_setAssociatedObject(self, &emptyButtonAttributedTitleKey, emptyButtonAttributedTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableAttributedString *)emptyButtonAttributedTitle {
    return objc_getAssociatedObject(self, &emptyButtonAttributedTitleKey);
}

- (void)setEmptyButtonTitleColor:(UIColor *)emptyButtonTitleColor {
    objc_setAssociatedObject(self, &emptyButtonTitleColorKey, emptyButtonTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)emptyButtonTitleColor {
    return objc_getAssociatedObject(self, &emptyButtonTitleColorKey);
}

- (void)setEmptyButtonBGColor:(UIColor *)emptyButtonBGColor {
    objc_setAssociatedObject(self, &emptyButtonBGColorKey, emptyButtonBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)emptyButtonBGColor {
    return objc_getAssociatedObject(self, &emptyButtonBGColorKey);
}

- (void)setEmptyDelegate:(id<MLD_umEmptyDataDelegate>)emptyDelegate {
    
    objc_setAssociatedObject(self, &emptyDelegateKey, emptyDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<MLD_umEmptyDataDelegate>)emptyDelegate {
    return objc_getAssociatedObject(self, &emptyDelegateKey);
}


/**
 set方法

 @param emptyView 缺省视图
 */
- (void)setEmptyView1:(MLD_umEmptyPlaceholderView *)emptyView1 {
    
    objc_setAssociatedObject(self, &emptyKey, emptyView1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 缺省视图实例

 @return 返回一个View实例
 */
- (MLD_umEmptyPlaceholderView *)emptyView1 {
    
    MLD_umEmptyPlaceholderView *emptyView = objc_getAssociatedObject(self, &emptyKey);
    if (!emptyView) {
        emptyView = [[MLD_umEmptyPlaceholderView alloc] init];
    }
    emptyView.title = self.emptyTitle;
    emptyView.imageName = self.emptyImageName;
    emptyView.desc = self.emptyDesc;
    emptyView.topStr = self.topHeight;
    emptyView.button.hidden = YES;
    if(!isEmptyString_um(self.emptyButtonTitle)) {
        emptyView.button.hidden = NO;
        [emptyView.button setTitle:self.emptyButtonTitle forState:UIControlStateNormal];
        emptyView.button.backgroundColor = self.emptyButtonBGColor;
        [emptyView.button addTarget:self action:@selector(emptyButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [emptyView.button setTitleColor:self.emptyButtonTitleColor?:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    return emptyView;
}

- (void)showEmptyViewRowCount:(NSUInteger)rowCount {
    
    if (rowCount == 0) {
        self.scrollEnabled = NO;
        self.backgroundView = self.emptyView1;
    }
    else
    {
        self.scrollEnabled = YES;
        self.backgroundView = nil;
    }
}

- (void)emptyButtonHandle:(UIButton *)sender {
    
    if (self.emptyDelegate && [self.emptyDelegate respondsToSelector:@selector(emptyDataButtonHandle)]) {
        [self.emptyDelegate emptyDataButtonHandle];
    }
}


@end
