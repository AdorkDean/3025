//
//  DetailViewController.m
//  3025
//
//  Created by WangErdong on 2017/6/18.
//
//

#import "DetailViewController.h"
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"
#import "ImageBrowser.h"
#import "ChatViewController.h"
#import "MomentViewController.h"

@interface DetailViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigtion];
    [self setupUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - UI

- (void)setupNavigtion {
    
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.frame = CGRectMake(0, 7, 60, 30);
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton setTitleColor:kNavigationTitleColor forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
    [leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    // 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = kNavigationTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"活动详情";
    titleLabel.frame = CGRectMake(0, 7, 50, 30);
    
    // 导航栏右侧
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.titleView = titleLabel;
}

- (void)setupUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    
    [self.view addSubview:self.webview];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
    
    [self.bridge registerHandler:@"jsEvent" handler:^(id data, WVJBResponseCallback responseCallback) {
//        
//        NSDictionary *dict = data;
//        
//        if ([dict[@"action"] isEqualToString:@"moment"]) {
//            
//            MomentViewController *vc = [[MomentViewController alloc] init];
//            vc.category = 0;
//            vc.uid = self.activityModel.userid;
//            
//            [self.navigationController pushViewController:vc animated:YES];
//        } else if ([dict[@"action"] isEqualToString:@"img"]) {
//            
//            NSArray *arr = dict[@"value"];
//            NSUInteger index = [dict[@"current"] integerValue];
//            
//            [ImageBrowser show:arr currentIndex:index];
//        } else if ([dict[@"action"] isEqualToString:@"share"]) {
//            
//            UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:@"分享到" preferredStyle:UIAlertControllerStyleActionSheet];
//            
//            [vc addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [vc dismissViewControllerAnimated:YES completion:nil];
//            }]];
//            [vc addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [vc dismissViewControllerAnimated:YES completion:nil];
//            }]];
//            [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                [vc dismissViewControllerAnimated:YES completion:nil];
//            }]];
//            
//            [self presentViewController:vc animated:YES completion:nil];
//            
//        } else if ([dict[@"action"] isEqualToString:@"chat"]) {
//            
//            ChatViewController *vc = [[ChatViewController alloc] init];
//            vc.withUserid = self.userModel.userid;
//            vc.withUsername = self.userModel.nickname;
//            vc.me_poster = self.me.poster;
//            vc.other_poster = self.userModel.poster;
//            
//            [self.navigationController pushViewController:vc animated:YES];
//        } else if ([dict[@"action"] isEqualToString:@"interest"]) {
//            
//            [self save:[dict[@"value"] integerValue] type:@"1" compelete:responseCallback];
//        } else if ([dict[@"action"] isEqualToString:@"block"]) {
//            
//            [self save:[dict[@"value"] integerValue] type:@"0" compelete:responseCallback];
//        }
    }];
//    
//    NSMutableDictionary *mDict = [self.userModel mj_keyValues];
//    if (mDict[@"salary"]) {
//        [mDict setObject:[mDict[@"salary"] stringByAppendingString:@"以上"] forKey:@"salary"];
//    } else {
//        [mDict setObject:@"未填写" forKey:@"salary"];
//    }
//    if (mDict[@"house"]) {
//        [mDict setObject:[kHouseStatus objectAtIndex:([mDict[@"house"] intValue] - 1)] forKey:@"house"];
//    } else {
//        [mDict setObject:@"婚房状况未填写" forKey:@"house"];
//    }
//    if (mDict[@"maritalStatus"]) {
//        [mDict setObject:[kMaritalStatus objectAtIndex:([mDict[@"maritalStatus"] intValue] - 1)] forKey:@"maritalStatus"];
//    } else {
//        [mDict setObject:@"婚姻状况未填写" forKey:@"maritalStatus"];
//    }
//    
//    [mDict setObject:([self.userid isEqualToString:self.userModel.userid] ? @"1" : @"0") forKey:@"me"];
//    
//    [self.bridge callHandler:@"init" data:mDict responseCallback:^(id responseData) {
//    }];
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    NSLog(@" *** %@ *** ", NSStringFromSelector(_cmd));
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    NSLog(@" *** %@ *** ", NSStringFromSelector(_cmd));
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@" *** %@ *** ", NSStringFromSelector(_cmd));
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@" *** %@ *** ", NSStringFromSelector(_cmd));
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@" *** %@ *** ", NSStringFromSelector(_cmd));
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@" *** %@ *** ", NSStringFromSelector(_cmd));
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@" *** %@ *** ", NSStringFromSelector(_cmd));
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@" *** %@ *** ", NSStringFromSelector(_cmd));
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    NSLog(@" *** %@ *** ", NSStringFromSelector(_cmd));
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@" *** %@ *** ", NSStringFromSelector(_cmd));
}

#pragma mark - 事件处理

- (void)back:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter

- (WKWebView *)webview {
    if (!_webview) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"detail" ofType:@"html"];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        
        _webview = [[WKWebView alloc] init];
        [_webview setUIDelegate:self];
        [_webview loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    }
    return _webview;
}

- (WKWebViewJavascriptBridge *)bridge {
    if (!_bridge) {
        _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webview];
        [_bridge setWebViewDelegate:self];
    }
    return _bridge;
}

#pragma mark - 数据处理

/**
 *  加载数据
 */
- (void)loadData {
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    [activityIndicatorView startAnimating];
    
    NSString *sql = [NSString stringWithFormat:@"\
                     SELECT \
                         a.activityid, \
                         a.userid, \
                         a.image1, \
                         a.image2, \
                         a.image3, \
                         a.activityname, \
                         a.category, \
                         a.province, \
                         a.city, \
                         a.district, \
                         a.activitytime, \
                         a.address, \
                         a.capacityfrom, \
                         a.capacityto, \
                         a.cost, \
                         a.prepayment, \
                         a.content, \
                         a.status \
                     FROM \
                         activity a \
                     WHERE \
                         a.activityid = '%@'", self.activityModel.activityid];
    
    // 筛选条件
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
    NSDictionary *parameterDict = @{ @"sql": sql };
    
    //获取网络数据
    [HttpUtil query:url parameter:parameterDict success:^(id responseObject) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = responseDict[@"list"];
        
        if (array.count > 0) {
            
            NSDictionary *dict = array[0];
            
            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            
            if (mDict[@"conditionid"]) {
                
                // 择偶条件-户籍
                if ([ConversionUtil isNotEmpty:mDict[@"domicileprovince"]] && ![mDict[@"domicileprovince"] isEqualToString:@"不限"]) {
                    
                    NSString *province = mDict[@"domicileprovince"];
                    NSString *city = mDict[@"domicilecity"];
                    if (![province isEqualToString:city]) {
                        [mDict setObject:[NSString stringWithFormat:@"户籍%@省%@市", province, city] forKey:@"domicile"];
                    } else {
                        [mDict setObject:[NSString stringWithFormat:@"户籍%@市", province] forKey:@"domicile"];
                    }
                } else {
                    [mDict setObject:@"户籍不限" forKey:@"domicile"];
                }
                
                // 择偶条件-常住
                if ([ConversionUtil isNotEmpty:mDict[@"residenceprovince"]] && ![mDict[@"residenceprovince"] isEqualToString:@"不限"]) {
                    
                    NSString *province = mDict[@"residenceprovince"];
                    NSString *city = mDict[@"residencecity"];
                    if (![province isEqualToString:city]) {
                        [mDict setObject:[NSString stringWithFormat:@"常住%@省%@市", province, city] forKey:@"residence"];
                    } else {
                        [mDict setObject:[NSString stringWithFormat:@"常住%@市", province] forKey:@"residence"];
                    }
                } else {
                    [mDict setObject:@"常住不限" forKey:@"residence"];
                }
                
                // 择偶条件-学历
                if ([ConversionUtil isNotEmpty:mDict[@"educationFrom"]] && ![mDict[@"educationFrom"] isEqualToString:@"0"]) {
                    int index = [mDict[@"educationFrom"] intValue] - 1;
                    [mDict setObject:[NSString stringWithFormat:@"%@", kEducation[index]] forKey:@"education"];
                } else {
                    [mDict setObject:@"学历不限" forKey:@"education"];
                }
                
                // 择偶条件-月薪
                if ([ConversionUtil isNotEmpty:mDict[@"salaryFrom"]] && ![mDict[@"salaryFrom"] isEqualToString:@"0"]) {
                    [mDict setObject:[NSString stringWithFormat:@"月薪%@以上", mDict[@"salaryFrom"]] forKey:@"salary"];
                } else {
                    [mDict setObject:@"月薪不限" forKey:@"salary"];
                }
                
                // 择偶条件-婚姻状况
                if ([ConversionUtil isNotEmpty:mDict[@"maritalstatus"]] && ![mDict[@"maritalstatus"] isEqualToString:@"0"]) {
                    int index = [mDict[@"maritalstatus"] intValue] - 1;
                    [mDict setObject:[NSString stringWithFormat:@"%@", kMaritalStatus[index]] forKey:@"maritalstatus"];
                } else {
                    [mDict setObject:@"婚姻状况不限" forKey:@"maritalstatus"];
                }
                
                // 择偶条件-婚房
                if ([ConversionUtil isNotEmpty:mDict[@"house"]] && ![mDict[@"house"] isEqualToString:@"0"]) {
                    int index = [mDict[@"house"] intValue] - 1;
                    [mDict setObject:[NSString stringWithFormat:@"%@", kHouseStatus[index]] forKey:@"house"];
                } else {
                    [mDict setObject:@"婚房不限" forKey:@"house"];
                }
            }
            
            [self.bridge callHandler:@"init2" data:mDict responseCallback:^(id responseData) {
                NSLog(@"ObjC received response: %@", responseData);
            }];
        }
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
    } failure:^(NSError *error) {
        
        NSLog(@"*** failure %@ ***", error.description);
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
    }];
}

// action 0:insert 1:delete
- (void)save:(NSUInteger)action type:(NSString *)type compelete:(WVJBResponseCallback)responseCallback {
//    
//    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [self.view addSubview:activityIndicatorView];
//    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.view);
//    }];
//    [activityIndicatorView startAnimating];
//    
//    NSString *url;
//    NSDictionary *parameterDict;
//    
//    // 筛选条件
//    NSString *sql;
//    if (action == 0) {
//        
//        url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/save.html"];
//        parameterDict = @{ @"table": @"user_target", @"userid": self.userid, @"type":type, @"target_userid":self.userModel.userid};
//    } else if (action == 1) {
//        
//        sql = [NSString stringWithFormat:@"delete from user_target where userid = '%@' and type = '%@' and target_userid = '%@'", self.userid, type, self.userModel.userid];
//        url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
//        parameterDict = @{ @"sql": sql };
//    } else {
//        return;
//    }
//    
//    //获取网络数据
//    [HttpUtil query:url parameter:parameterDict success:^(id responseObject) {
//        
//        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"*** success %@ ***", responseDict);
//        
//        responseCallback(responseDict[@"code"] ? responseDict : @{@"code":@"0"});
//        
//        [activityIndicatorView stopAnimating];
//        [activityIndicatorView removeFromSuperview];
//    } failure:^(NSError *error) {
//        
//        NSLog(@"*** failure %@ ***", error.description);
//        
//        [activityIndicatorView stopAnimating];
//        [activityIndicatorView removeFromSuperview];
//        
//        responseCallback(@{@"code":@"1"});
//        
//        [SVProgressHUD showImage:nil status:@"操作失败"];
//        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//        [SVProgressHUD dismissWithDelay:1.5];
//    }];
}

@end
