//
//  UserViewController.m
//  3025
//
//  Created by ld on 2017/6/9.
//
//

#import "UserViewController.h"
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"

@interface UserViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;

@end

@implementation UserViewController

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
    titleLabel.text = @"详情";
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
    
    [self.bridge registerHandler:@"init" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC Echo called with: %@", data);
        responseCallback(data);
    }];
    
    NSMutableDictionary *mDict = [self.userModel mj_keyValues];
    if (mDict[@"salary"]) {
        [mDict setObject:[mDict[@"salary"] stringByAppendingString:@"以上"] forKey:@"salary"];
    } else {
        [mDict setObject:@"未填写" forKey:@"salary"];
    }
    if (mDict[@"house"]) {
        [mDict setObject:[kHouseStatus objectAtIndex:([mDict[@"house"] intValue] - 1)] forKey:@"house"];
    } else {
        [mDict setObject:@"婚房状况未填写" forKey:@"house"];
    }
    if (mDict[@"maritalStatus"]) {
        [mDict setObject:[kMaritalStatus objectAtIndex:([mDict[@"maritalStatus"] intValue] - 1)] forKey:@"maritalStatus"];
    } else {
        [mDict setObject:@"婚姻状况未填写" forKey:@"maritalStatus"];
    }
    
    [self.bridge callHandler:@"init" data:mDict responseCallback:^(id responseData) {
        NSLog(@"ObjC received response: %@", responseData);
    }];
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
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"user_detail" ofType:@"html"];
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
                     select \
                         userid, \
                         signature, \
                         comment, \
                         photos, \
                         images_ID, \
                         images_education, \
                         images_position, \
                         important, \
                         father_job, \
                         father_comment, \
                         mother_job, \
                         mother_comment, \
                         address, \
                         address_comment, \
                         images_address \
                     FROM \
                         user \
                     where \
                         userid = %@", self.userModel.userid];
    
    // 筛选条件
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
    NSDictionary *parameterDict = @{ @"sql": sql };
    
    //获取网络数据
    [HttpUtil query:url parameter:parameterDict success:^(id responseObject) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = responseDict[@"list"];
        
        if (array.count == 1) {
            
            NSDictionary *dict = array[0];
            
            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            if (mDict[@"signature"]) {
                if ([ConversionUtil isEmpty:mDict[@"signature"]]) {
                    [mDict setObject:@"未填写" forKey:@"signature"];
                }
            } else {
                [mDict setObject:@"未填写" forKey:@"signature"];
            }
            if (mDict[@"comment"]) {
                if ([ConversionUtil isEmpty:mDict[@"comment"]]) {
                    [mDict setObject:@"未填写" forKey:@"comment"];
                }
            } else {
                [mDict setObject:@"未填写" forKey:@"comment"];
            }
            if (mDict[@"important"]) {
                if ([ConversionUtil isEmpty:mDict[@"important"]]) {
                    [mDict setObject:@"未填写" forKey:@"important"];
                }
            } else {
                [mDict setObject:@"未填写" forKey:@"important"];
            }
            if (mDict[@"father_job"]) {
                if ([ConversionUtil isEmpty:mDict[@"father_job"]]) {
                    [mDict setObject:@"未填写" forKey:@"father_job"];
                } else {
                    [mDict setObject:[NSString stringWithFormat:@"%@ %@", mDict[@"father_job"], mDict[@"father_comment"]] forKey:@"father_job"];
                }
            } else {
                [mDict setObject:@"未填写" forKey:@"father_job"];
            }
            if (mDict[@"mother_job"]) {
                if ([ConversionUtil isEmpty:mDict[@"mother_job"]]) {
                    [mDict setObject:@"未填写" forKey:@"mother_job"];
                } else {
                    [mDict setObject:[NSString stringWithFormat:@"%@ %@", mDict[@"mother_job"], mDict[@"mother_comment"]] forKey:@"father_job"];
                }
            } else {
                [mDict setObject:@"未填写" forKey:@"mother_job"];
            }
            if (mDict[@"address"]) {
                if ([ConversionUtil isEmpty:mDict[@"address"]]) {
                    [mDict setObject:@"未填写" forKey:@"address"];
                } else {
                    [mDict setObject:[NSString stringWithFormat:@"%@ %@", mDict[@"address"], mDict[@"address_comment"]] forKey:@"address"];
                }
            } else {
                [mDict setObject:@"未填写" forKey:@"address"];
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

@end
