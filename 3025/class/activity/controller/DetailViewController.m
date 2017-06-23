//
//  DetailViewController.m
//  3025
//
//  Created by WangErdong on 2017/6/18.
//
//

#import "DetailViewController.h"
#import <WebKit/WebKit.h>
#import "WXApi.h"
#import "WKWebViewJavascriptBridge.h"
#import "ImageBrowser.h"
#import "ChatViewController.h"
#import "MomentViewController.h"

@interface DetailViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;
@property (nonatomic, strong) NSMutableDictionary *data;

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
        
        NSDictionary *dict = data;
        
        if ([dict[@"action"] isEqualToString:@"img"]) {

            NSArray *arr = dict[@"value"];
            NSUInteger index = [dict[@"current"] integerValue];
            
            [ImageBrowser show:arr currentIndex:index];
        } else if ([dict[@"action"] isEqualToString:@"share"]) {
            
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:@"分享到" preferredStyle:UIAlertControllerStyleActionSheet];
            
            [vc addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [WXApi registerApp:kWXAppKey2];
                
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = [NSString stringWithFormat:@"3025活动 %@", self.activityModel.activityname];
                message.description = @"3025定位在适婚单身白领人群，提供真诚、欢乐、有格调的婚恋交友服务。";
                [message setThumbImage:[UIImage imageNamed:@"activity_poster"]];
                
                // 分享
                WXWebpageObject *webpageObject = [WXWebpageObject object];
                webpageObject.webpageUrl = [NSString stringWithFormat:@"http://www.viewatmobile.cn/3025/activity/detail.html?userid=%@&activityUserid=%@&activityid=%@&share=1", self.userid ? self.userid : @"0", self.activityModel.user.userid, self.activityModel.activityid];
                
                message.mediaObject = webpageObject;
                
                SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                req.message = message;
                req.bText = NO;
                req.scene = WXSceneSession;
                
                // 分享
                [WXApi sendReq:req];
                
                [vc dismissViewControllerAnimated:YES completion:nil];
            }]];
            [vc addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [WXApi registerApp:kWXAppKey2];
                
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = [NSString stringWithFormat:@"3025活动 %@", self.activityModel.activityname];
                message.description = @"3025定位在适婚单身白领人群，提供真诚、欢乐、有格调的婚恋交友服务。";
                [message setThumbImage:[UIImage imageNamed:@"activity_poster"]];
                
                // 分享
                WXWebpageObject *webpageObject = [WXWebpageObject object];
                webpageObject.webpageUrl = [NSString stringWithFormat:@"http://www.viewatmobile.cn/3025/activity/detail.html?userid=%@&activityUserid=%@&activityid=%@&share=1", self.userid ? self.userid : @"0", self.activityModel.user.userid, self.activityModel.activityid];
                
                message.mediaObject = webpageObject;
                
                SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                req.message = message;
                req.bText = NO;
                req.scene = WXSceneTimeline;
                
                // 分享
                [WXApi sendReq:req];
                
                [vc dismissViewControllerAnimated:YES completion:nil];
            }]];
            [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [vc dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            [self presentViewController:vc animated:YES completion:nil];
            
        } else if ([dict[@"action"] isEqualToString:@"register"]) {
            
            if ([self goLogin:nil message:nil]) {
                return;
            }
            
            NSString *title = @"";
            NSString *msg = @"";
            
            if ([self.data[@"registerStatus"] isEqualToString:@"01"] ||
                [self.data[@"registerStatus"] isEqualToString:@"03"] ||
                [self.data[@"registerStatus"] isEqualToString:@"04"]) {
                title = @"不能取消报名！";
            } else {
                title = @"不能报名！";
            }

            if ([self.data[@"status"] isEqualToString:@"02"]) {
                msg = @"报名人数已满！";
            } else if ([self.data[@"status"] isEqualToString:@"03"]) {
                msg = @"活动已结束！";
            } else if ([self.data[@"status"] isEqualToString:@"09"]) {
                msg = @"活动已取消！";
            }
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
            [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [vc dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
    
    NSMutableDictionary *mDict = [self.activityModel mj_keyValues];
    if (self.userid) {
        [mDict setObject:self.userid forKey:@"me"];
    }
    
    [self.bridge callHandler:@"init" data:mDict responseCallback:^(id responseData) {
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
    
    NSString *subSql = [NSString stringWithFormat:@" left join (\
                        SELECT \
                            signcode, \
                            status as registerStatus \
                        FROM \
                            activity_user \
                        WHERE \
                            auid = (select max(auid) from activity_user where userid = '%@' and activityid = '%@')) t1 on 1 = 1 ",
                        self.userid,
                        self.activityModel.activityid];

    NSString *subSql2 = [NSString stringWithFormat:@" left join (select creditscore from user where userid = '%@') t2 on 1 = 1 ", self.userid];
    
    NSString *subSql3 = [NSString stringWithFormat:@" (select count(au.auid) as total from activity_user au, user u where au.auid in \
                         (select max(auid) from activity_user where activityid = '%@' group by userid) \
                         and au.status = '01' and u.userid = au.userid) c1 ", self.activityModel.activityid];
    
    NSString *subSql4 = [NSString stringWithFormat:@" (select count(au.auid) as mCount from activity_user au, user u where au.auid in \
                         (select max(auid) from activity_user where activityid = '%@' group by userid) \
                         and au.status = '01' and u.userid = au.userid and u.sex = '男') c2 ", self.activityModel.activityid];
    
    NSString *subSql5 = [NSString stringWithFormat:@" left join (select t.registerSort from (select @rownum:=@rownum+1 as registerSort, u.userid from activity_user au, user u, (select @rownum:=0) r where au.auid in \
                         (select max(auid) from activity_user where activityid = '%@' group by userid) \
                         and au.status = '01' and u.userid = au.userid order by u.creditscore desc) t where t.userid = '%@') c3 ON 1 = 1 ", self.activityModel.activityid, self.userid];
    
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
                         a.status, \
                         c1.total, \
                         c2.mCount, \
                         c3.registerSort \
                         %@ \
                         %@ \
                     FROM \
                         activity a, %@, %@ %@ \
                         \
                         %@ \
                         %@ \
                     WHERE \
                         a.activityid = '%@'",
                     self.userid ? @", t1.signcode, t1.registerStatus " : @"",
                     self.userid ? @", t2.creditscore " : @"",
                     subSql3, subSql4, subSql5,
                     self.userid ? subSql : @"",
                     self.userid ? subSql2 : @"",
                     self.activityModel.activityid];
    
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
            if (self.userid) {
                [mDict setObject:self.userid forKey:@"me"];
            }
            
            @try {
                if ([mDict[@"province"] isEqualToString:mDict[@"city"]]) {
                    [mDict setObject:@"" forKey:@"province"];
                    [mDict setObject:[NSString stringWithFormat:@"%@市", mDict[@"city"]] forKey:@"city"];
                } else {
                    [mDict setObject:[NSString stringWithFormat:@"%@省", mDict[@"province"]] forKey:@"province"];
                    [mDict setObject:[NSString stringWithFormat:@"%@市", mDict[@"city"]] forKey:@"city"];
                }
                
                int idx = [[mDict[@"category"] substringToIndex:2] intValue];
                int idx2 = [[mDict[@"category"] substringFromIndex:2] intValue];
                
                NSString *category = kActivityCategorys[idx][idx2];
                [mDict setObject:category forKey:@"category"];
                
                NSString *content = mDict[@"content"];
                content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
                [mDict setObject:[NSString stringWithFormat:@"<p>%@</p>", content] forKey:@"content"];
                
                NSString *now = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyy/MM/dd HH:mm"];
                if ([now compare:mDict[@"activitytime"]] == NSOrderedDescending) {
                    [mDict setObject:@"03" forKey:@"status"];
                } else {
                    if ([mDict[@"total"] intValue] >= [mDict[@"capacityfrom"] intValue]) {
                        [mDict setObject:@"02" forKey:@"status"];
                    }
                }
            } @catch (NSException *exception) {
                NSLog(@" *** %@ *** ", exception);
            }
            
            [self.bridge callHandler:@"init" data:mDict responseCallback:^(id responseData) {
                NSLog(@"ObjC received response: %@", responseData);
            }];
            
            self.data = [NSMutableDictionary dictionaryWithDictionary:mDict];
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
