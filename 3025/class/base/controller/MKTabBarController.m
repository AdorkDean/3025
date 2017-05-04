//
//  MKTabBarController.m
//  3025
//
//  Created by ld on 2017/3/27.
//
//

#import "MKTabBarController.h"
#import "Constant.h"
#import "MKNavigationController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ActivityViewController.h"
#import "ProfileViewController.h"

#define kImageInsets UIEdgeInsetsMake(0, 0, 0, 0)
#define kTitlePositionAdjustment UIOffsetMake(0, 0)

@interface MKTabBarController () {

}

@property (nonatomic, strong) HomeViewController *homeViewController;
@property (nonatomic, strong) MessageViewController *messageViewController;
@property (nonatomic, strong) ActivityViewController *activityViewController;
@property (nonatomic, strong) ProfileViewController *profileViewController;

@end

@implementation MKTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设定导航栏颜色
    [[UINavigationBar appearance] setBarTintColor:kNavigationColor];
    
    self.viewControllers = @[
                             [[MKNavigationController alloc] initWithRootViewController:self.homeViewController],
                             [[MKNavigationController alloc] initWithRootViewController:self.messageViewController],
                             [[MKNavigationController alloc] initWithRootViewController:self.activityViewController],
                             [[MKNavigationController alloc] initWithRootViewController:self.profileViewController]
                             ];
    self.selectedViewController = [self.viewControllers firstObject];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)setSelectedViewController:(__kindof UIViewController *)selectedViewController {
    [super setSelectedViewController:selectedViewController];
    
    NSString *userid = self.homeViewController.me.userid;
    if (!userid) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
    NSString *sql = [NSString stringWithFormat:@"SELECT COALESCE(COUNT(withUserid), 0) count FROM message WHERE userid = %@ AND status = '0'", userid];
    NSDictionary *paramDict = @{ @"sql": sql };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"*** %@ ***", dict);
        
        int count = [dict[@"list"][0][@"count"] intValue];
        if (count > 0) {
        
            self.messageViewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", count];
        } else {
            
            self.tabBarItem.badgeValue = nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"*** %@ ***", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter

- (HomeViewController *)homeViewController {
    if (!_homeViewController) {
        _homeViewController = [[HomeViewController alloc] init];
        [_homeViewController setTabBarItem:[self tabBarItem:@"首页" image:[UIImage imageNamed:@"home"] selectedImage:[UIImage imageNamed:@"home_selected"]]];
    }
    return _homeViewController;
}

- (MessageViewController *)messageViewController {
    if (!_messageViewController) {
        _messageViewController = [[MessageViewController alloc] init];
        [_messageViewController setTabBarItem:[self tabBarItem:@"消息" image:[UIImage imageNamed:@"message"] selectedImage:[UIImage imageNamed:@"message_selected"]]];
    }
    return _messageViewController;
}

- (ActivityViewController *)activityViewController {
    if (!_activityViewController) {
        _activityViewController = [[ActivityViewController alloc] init];
        [_activityViewController setTabBarItem:[self tabBarItem:@"活动" image:[UIImage imageNamed:@"activity"] selectedImage:[UIImage imageNamed:@"activity_selected"]]];
    }
    return _activityViewController;
}

- (ProfileViewController *)profileViewController {
    if (!_profileViewController) {
        _profileViewController = [[ProfileViewController alloc] init];
        [_profileViewController setTabBarItem:[self tabBarItem:@"我的" image:[UIImage imageNamed:@"profile"] selectedImage:[UIImage imageNamed:@"profile_selected"]]];
    }
    return _profileViewController;
}

/**
 *  创建UITabBarItem
 *
 *  @param title         文字
 *  @param image         未选中时图片
 *  @param selectedImage 选中时图片
 *
 *  @return UITabBarItem
 */
- (UITabBarItem *)tabBarItem:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {

    UITabBarItem *tabBarItem = [[UITabBarItem alloc] init];
    
    [tabBarItem setTitle:title];
    // 未选中时文字颜色
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kTabbarTitleColor} forState:UIControlStateNormal];
    // 选中时文字颜色
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kTabbarTitleSelectedColor} forState:UIControlStateSelected];
    // 调整文字位置
    [tabBarItem setTitlePositionAdjustment:kTitlePositionAdjustment];
    
    // 显示原图片
    [tabBarItem setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    // 调整图片大小位置
    [tabBarItem setImageInsets:kImageInsets];
    
    return tabBarItem;
}

@end
