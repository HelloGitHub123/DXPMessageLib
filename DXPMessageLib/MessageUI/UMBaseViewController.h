//
//  UMBaseViewController.h
//  MPTCLPMall
//
//  Created by OO on 2020/9/2.
//  Copyright © 2020 OO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UMBaseViewController : UIViewController

// 是否隐藏导航栏下面的线
@property (nonatomic, assign) BOOL hideNaVLine;
// 设置导航栏颜色
@property (nonatomic, strong) UIColor *naviColor;
// 设置导航栏背景图
@property (nonatomic, strong) UIImage *naviImg;
// 设置导航栏字体颜色
@property (nonatomic, strong) UIColor *titleColor;
// 导航栏标题
@property (nonatomic, strong) NSString *navTitleStr;

@property (nonatomic, copy) NSString *backImgName;
// tableview 距离顶部的高度
@property (nonatomic, assign) float topHight;
// 设置所有subsview代码
@property (nonatomic, assign) long subsViewIndex;

@property (nonatomic, strong) NSMutableDictionary *paramsDic;

@property (nonatomic, copy) void (^returnValue)(NSString *string);

- (void)initDataFromParmas;

- (UIImage *)imageWithColor:(UIColor *)color;

- (void)naviBackAction:(id)sender;
@end

NS_ASSUME_NONNULL_END
