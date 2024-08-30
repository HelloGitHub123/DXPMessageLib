//
//  UMBaseViewController.m
//  MPTCLPMall
//
//  Created by OO on 2020/9/2.
//  Copyright © 2020 OO. All rights reserved.
//

#import "UMBaseViewController.h"
#import "MessageHeader.h"

@interface UMBaseViewController ()
// 返回按钮
@property (nonatomic, strong) UIButton *backBtn1;
@end

@implementation UMBaseViewController

- (void)dealloc {
	umDebugLog(@"Message dealloc --- %@", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self initDataFromParmas];
    
    self.view.backgroundColor = UIColorFromRGB_um(0xFFFFFF);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn1];
    self.navigationController.navigationBar.translucent = NO;
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        appperance.backgroundColor = UIColorFromRGB_um(0xffffff);
        self.navigationController.navigationBar.standardAppearance = appperance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
    } else {
        //设置导航栏背景颜色
        self.navigationController.navigationBar.barTintColor = UIColorFromRGB_um(0xffffff);
    }

    if (self.navigationController.childViewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSArray *viewcontrolls = self.navigationController.viewControllers;
    if (viewcontrolls.count==1) {
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationItem setHidesBackButton:YES];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"IsHiddenTabbarView" object:@{@"count":@(0)}];
	} else if (viewcontrolls.count >= 1) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"IsHiddenTabbarView" object:@{@"count":@(1)}];
	}
}

- (void)setNavTitleStr:(NSString *)navTitleStr {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = isEmptyString_um(navTitleStr)?@"":navTitleStr;
    self.navigationItem.titleView = titleLabel;
}

- (void)initDataFromParmas {
}

- (void)setTitleColor:(UIColor *)titleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor,NSFontAttributeName:[UIFont systemFontOfSize:18]}];
}

- (void)setHideNaVLine:(BOOL)hideNaVLine {
    _hideNaVLine = hideNaVLine;
    self.navigationController.navigationBar.translucent = NO;
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        if (hideNaVLine) {
            appperance.backgroundColor = UIColorFromRGB_um(0xffffff);
            appperance.shadowImage = [[UIImage alloc]init];
            appperance.shadowColor = nil;
        }
        self.navigationController.navigationBar.standardAppearance = appperance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
    } else {
        //设置导航栏背景颜色
        self.navigationController.navigationBar.barTintColor = UIColorFromRGB_um(0xffffff);
    }
}

- (void)setNaviColor:(UIColor *)naviColor {
    _naviColor = naviColor;
    self.navigationController.navigationBar.translucent = NO;
    // 设置导航栏为不透明
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        appperance.backgroundColor = naviColor;
        appperance.shadowImage = [[UIImage alloc]init];
        appperance.shadowColor = nil;
        self.navigationController.navigationBar.standardAppearance = appperance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
    } else {
        //设置导航栏背景颜色
        self.navigationController.navigationBar.barTintColor = naviColor;
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
}

- (void)setNaviImg:(UIImage *)naviImg{
    // 设置导航栏为不透明
    self.navigationController.navigationBar.translucent = NO;
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        if (naviImg) {
            [appperance setBackgroundImage:naviImg];
        } else {
            appperance.shadowImage = [[UIImage alloc]init];
            appperance.shadowColor = nil;
        }
        self.navigationController.navigationBar.standardAppearance = appperance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
    } else {
        //设置导航栏背景tu
        if (naviImg) {
            [self.navigationController.navigationBar setBackgroundImage:naviImg forBarMetrics:UIBarMetricsDefault];
        }
    }
}

- (void)setBackImgName:(NSString *)backImgName{
    _backImgName = backImgName;
	[_backBtn1 setImage:[UIImage imageNamed:backImgName] forState:UIControlStateNormal];
}

#pragma mark - initData
- (void)naviBackAction:(id)sender {
    NSArray * viewcontrolls = self.navigationController.viewControllers;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTopHight:(float)topHight{
    _topHight = topHight;
}

#pragma mark - 手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
    if(self.navigationController.childViewControllers.count == 1) {
        return NO;
    }
    return YES;
}

- (void)getTabbarIndex{

}

#pragma mark - button action
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIButton *)backBtn1 {
    if (!_backBtn1) {
        _backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn1.frame = CGRectMake(0, 0, 24,24);
        [_backBtn1 setImage:[UIImage imageNamed:@"ic_bar_back"] forState:UIControlStateNormal];
        [_backBtn1 addTarget:self action:@selector(naviBackAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn1;
}

- (NSMutableDictionary *)paramsDic{
    if(!_paramsDic){
        _paramsDic = [[NSMutableDictionary alloc] init];
    }
    return _paramsDic;
}

@end
