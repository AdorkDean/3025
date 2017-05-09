//
//  MKViewController.m
//  3025
//
//  Created by ld on 2017/3/27.
//
//

#import "MKViewController.h"

@interface MKViewController ()

@end

@implementation MKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - setter & getter

- (UserModel *)me {

    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUser];
    if (userInfo) {
        _me = [UserModel mj_objectWithKeyValues:userInfo];
    } else {
        _me = nil;
        _me = [[UserModel alloc] init];
        _me.userid = @"1140";
    }
    
    return _me;
}

- (NSString *)userid {
    return self.me.userid;
}

#pragma mark - 事件处理

- (BOOL)goLogin:(NSString *)title message:(NSString *)message {

    if (!self.me.userid) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title?title:@"您还没有登录" message:message?message:@"目前仅支持微信授权登录" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers lastObject];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return YES;
    }
    
    return NO;
}

@end
