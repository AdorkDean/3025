//
//  AppDelegate.m
//  3025
//
//  Created by ld on 2017/3/27.
//
//

#import "AppDelegate.h"
#import "Constant.h"
#import "MKTabBarController.h"
#import "WXApi.h"
#import "AFNetworking.h"

@interface AppDelegate () <WXApiDelegate> {
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (!self.window) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    
    MKTabBarController *tabBarController = [[MKTabBarController alloc] init];
    
    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];
    
    [WXApi registerApp:@"wxad48b0df5c0ca7af"];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}


#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq *)req {
    NSLog(@"*** %@ ***", req);
}


- (void)onResp:(BaseResp *)resp {
    
    // 微信授权
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if (authResp.errCode == 0) {

            NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", kWXAppKey, kWXAppSecret, authResp.code];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/plain"]];
            
            [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                NSDictionary *dict = responseObject;
                
                if (dict[@"openid"]) {
                    [self signin:dict[@"openid"] access_token:dict[@"access_token"]];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                NSLog(@"*** %@ ***", error);
            }];
        }
    }
    
}

- (void)signin:(NSString *)openid access_token:(NSString *)access_token {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
    NSDictionary *paramDict = @{
                                @"sql": [NSString stringWithFormat:@"select * from user where openid = '%@'", openid]
                                };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([dict[@"count"] intValue] == 1) {
            
            NSArray *arr = dict[@"list"];
            NSDictionary *userInfo = [arr firstObject];

            [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:kLoginUser];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kWXAuthNotification object:nil userInfo:userInfo];
        } else {
            
            [self signup:openid access_token:access_token];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"*** %@ ***", error);
    }];
}

- (void)signup:(NSString *)openid access_token:(NSString *)access_token {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/plain"]];
    
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@&lang=zh_CN", access_token, openid] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject;
        NSString *location = @"上海-上海";
        if ([dict[@"country"] isEqualToString:@"中国"]) {
            NSString *province = dict[@"province"];
            NSString *city = dict[@"city"];
            if ([province isEqualToString:@"北京"] ||
                [province isEqualToString:@"天津"] ||
                [province isEqualToString:@"上海"] ||
                [province isEqualToString:@"重庆"]) {
                city = province;
            }
            location = [NSString stringWithFormat:@"%@-%@", province, city];
        }
        
        // 获得当前时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *now = [dateFormatter stringFromDate:[NSDate date]];
        
        NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/save.html"];
        NSDictionary *paramDict = @{
                                    @"table": @"user",
                                    @"openid": openid,
                                    @"nickname": dict[@"nickname"]?dict[@"nickname"]:@"3025用户",
                                    @"sex": [dict[@"sex"] intValue]==1?@"男":@"女",
                                    @"poster": dict[@"headimgurl"]?dict[@"headimgurl"]:@"",
                                    @"domicile": location,
                                    @"residence": location,
                                    @"updatetime": now
                                    };
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:url parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"*** %@ ***", dict);
            
            [self signin:openid access_token:access_token];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"*** %@ ***", error);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"*** %@ ***", error);
    }];
}

@end
