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
#import "WXApi.h"
#import "ImageBrowser.h"
#import "ChatViewController.h"
#import "MomentViewController.h"

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
    
    [self.bridge registerHandler:@"jsEvent" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *dict = data;
        
        if ([dict[@"action"] isEqualToString:@"moment"]) {
            
            MomentViewController *vc = [[MomentViewController alloc] init];
            vc.category = 0;
            vc.uid = self.userModel.userid;
            
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([dict[@"action"] isEqualToString:@"img"]) {
            
            NSArray *arr = dict[@"value"];
            NSUInteger index = [dict[@"current"] integerValue];
            
            [ImageBrowser show:arr currentIndex:index];
        } else if ([dict[@"action"] isEqualToString:@"share"]) {
            
            if ([self goLogin:nil message:nil]) {
                return;
            }
            
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:@"分享到" preferredStyle:UIAlertControllerStyleActionSheet];
            
            [vc addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
/*
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = @"title";
                message.description = @"description";
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://p3.img.kksmg.com/image/2017/06/15/cbfca7e8e77e2bf40c6c6aceaa54f1c2.jpg"]];
                
                // 图片分享
                WXWebpageObject *webpageObject = [WXWebpageObject object];
                webpageObject.webpageUrl = @"http://www.kankanews.com/";
                
                message.thumbData = imageData;
                message.mediaObject = webpageObject;
                
                SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                req.message = message;
                req.bText = NO;
                req.scene = 0;
                
                // 追加分享记录
                [WXApi sendReq:req];
*/
                [vc dismissViewControllerAnimated:YES completion:nil];
            }]];
            [vc addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
/*
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = @"title";
                message.description = @"description";
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://p3.img.kksmg.com/image/2017/06/15/cbfca7e8e77e2bf40c6c6aceaa54f1c2.jpg"]];
                
                // 图片分享
                WXWebpageObject *webpageObject = [WXWebpageObject object];
                webpageObject.webpageUrl = @"http://www.kankanews.com/";
                
                message.thumbData = imageData;
                message.mediaObject = webpageObject;
                
                SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                req.message = message;
                req.bText = NO;
                req.scene = 0;
                
                // 追加分享记录
                [WXApi sendReq:req];
*/
                [vc dismissViewControllerAnimated:YES completion:nil];
            }]];
            [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [vc dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            [self presentViewController:vc animated:YES completion:nil];
            
        } else if ([dict[@"action"] isEqualToString:@"chat"]) {
            
            if ([self goLogin:nil message:nil]) {
                return;
            }
            
            ChatViewController *vc = [[ChatViewController alloc] init];
            vc.withUserid = self.userModel.userid;
            vc.withUsername = self.userModel.nickname;
            vc.me_poster = self.me.poster;
            vc.other_poster = self.userModel.poster;
            
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([dict[@"action"] isEqualToString:@"interest"]) {
            
            if ([self goLogin:nil message:nil]) {
                return;
            }
            
            [self save:[dict[@"value"] integerValue] type:@"1" compelete:responseCallback];
        } else if ([dict[@"action"] isEqualToString:@"block"]) {
            
            if ([self goLogin:nil message:nil]) {
                return;
            }
            
            [self save:[dict[@"value"] integerValue] type:@"0" compelete:responseCallback];
        }
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
    
    [mDict setObject:([self.userid isEqualToString:self.userModel.userid] ? @"1" : @"0") forKey:@"me"];
    
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
                         u.userid, \
                         u.signature, \
                         u.comment, \
                         u.photos, \
                         u.images_ID, \
                         u.images_education, \
                         u.images_position, \
                         u.important, \
                         u.father_job, \
                         u.father_comment, \
                         u.mother_job, \
                         u.mother_comment, \
                         u.address, \
                         u.address_comment, \
                         u.images_address, \
                         c.conditionid, \
                         c.sex, \
                         c.ageFrom, \
                         c.ageTo, \
                         c.heightFrom, \
                         c.domicileprovince, \
                         c.domicilecity, \
                         c.residenceprovince, \
                         c.residencecity, \
                         c.salaryFrom, \
                         c.educationFrom, \
                         c.maritalstatus, \
                         c.house, \
                         t0.type as interest, \
                         t1.type as block \
                     FROM \
                         user u \
                     LEFT JOIN conditions c ON c.userid = u.userid AND c.category = '01' \
                     left join user_target t0 on t0.userid = %@ and t0.target_userid = u.userid and t0.type = '1' \
                     left join user_target t1 on t1.userid = %@ and t1.target_userid = u.userid and t1.type = '0' \
                     where \
                             u.userid = %@",
                     self.userid,
                     self.userid,
                     [self.userModel.userid isEqualToString:@"1279"] ? @"1138" : self.userModel.userid];
    
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
                    [mDict setObject:[NSString stringWithFormat:@"%@ %@", mDict[@"mother_job"], mDict[@"mother_comment"]] forKey:@"mother_job"];
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
            if (mDict[@"photos"]) {
                NSString *photos = mDict[@"photos"];
                [mDict removeObjectForKey:@"photos"];
                if ([ConversionUtil isNotEmpty:photos]) {
                    NSArray *arr = [photos componentsSeparatedByString:@","];
                    if (arr.count == 3) {
                        
                        NSString *photo1 = arr[0];
                        NSString *photo2;
                        NSString *photo3;
                        
                        if ([ConversionUtil isEmpty:photo1]) {

                            photo1 = arr[1];
                            if ([ConversionUtil isEmpty:photo1]) {

                                photo1 = arr[2];
                            } else {
                                
                                photo2 = arr[2];
                            }
                        } else {
                            
                            photo2 = arr[1];
                            if ([ConversionUtil isEmpty:photo2]) {
                                
                                photo2 = arr[2];
                            } else {
                                
                                photo3 = arr[2];
                            }
                        }
                        
                        if ([ConversionUtil isNotEmpty:photo1]) {
                            [mDict setObject:photo1 forKey:@"photo1"];
                            [mDict setObject:@"1" forKey:@"photos"];
                        }
                        if ([ConversionUtil isNotEmpty:photo2]) {
                            [mDict setObject:photo2 forKey:@"photo2"];
                            [mDict setObject:@"1" forKey:@"photos"];
                        }
                        if ([ConversionUtil isNotEmpty:photo3]) {
                            [mDict setObject:photo3 forKey:@"photo3"];
                            [mDict setObject:@"1" forKey:@"photos"];
                        }
                    }
                }
            }
            if (mDict[@"images_address"]) {
                NSString *photos = mDict[@"images_address"];
                [mDict removeObjectForKey:@"images_address"];
                if ([ConversionUtil isNotEmpty:photos]) {
                    NSArray *arr = [photos componentsSeparatedByString:@","];
                    if (arr.count == 3) {
                        
                        NSString *photo1 = arr[0];
                        NSString *photo2;
                        NSString *photo3;
                        
                        if ([ConversionUtil isEmpty:photo1]) {
                            
                            photo1 = arr[1];
                            if ([ConversionUtil isEmpty:photo1]) {
                                
                                photo1 = arr[2];
                            } else {
                                
                                photo2 = arr[2];
                            }
                        } else {
                            
                            photo2 = arr[1];
                            if ([ConversionUtil isEmpty:photo2]) {
                                
                                photo2 = arr[2];
                            } else {
                                
                                photo3 = arr[2];
                            }
                        }
                        
                        if ([ConversionUtil isNotEmpty:photo1]) {
                            [mDict setObject:photo1 forKey:@"address_photo1"];
                            [mDict setObject:@"1" forKey:@"images_address"];
                        }
                        if ([ConversionUtil isNotEmpty:photo2]) {
                            [mDict setObject:photo2 forKey:@"address_photo2"];
                            [mDict setObject:@"1" forKey:@"images_address"];
                        }
                        if ([ConversionUtil isNotEmpty:photo3]) {
                            [mDict setObject:photo3 forKey:@"address_photo3"];
                            [mDict setObject:@"1" forKey:@"images_address"];
                        }
                    }
                }
            }
            
            if (mDict[@"conditionid"]) {
                
                // 择偶条件-性别
                if ([ConversionUtil isEmpty:mDict[@"sex"]] || [mDict[@"sex"] isEqualToString:@"0"]) {
                    [mDict removeObjectForKey:@"sex"];
                }
                
                // 择偶条件-年龄
                NSString *age;
                if ([ConversionUtil isNotEmpty:mDict[@"ageFrom"]] && ![mDict[@"ageFrom"] isEqualToString:@"0"]) {
                    age = [mDict[@"ageFrom"] substringFromIndex:2];
                }
                if ([ConversionUtil isNotEmpty:mDict[@"ageTo"]] && ![mDict[@"ageTo"] isEqualToString:@"0"]) {
                    if (age) {
                        age = [NSString stringWithFormat:@"%@年-%@年", age, [mDict[@"ageTo"] substringFromIndex:2]];
                    } else {
                        age = [NSString stringWithFormat:@"%@年以前", [mDict[@"ageTo"] substringFromIndex:2]];
                    }
                } else {
                    if (age) {
                        age = [NSString stringWithFormat:@"%@年以后", age];
                    } else {
                        age = @"年龄不限";
                    }
                }
                [mDict setObject:age forKey:@"age"];
                
                // 择偶条件-身高
                if ([ConversionUtil isNotEmpty:mDict[@"heightFrom"]] && ![mDict[@"heightFrom"] isEqualToString:@"0"]) {
                    [mDict setObject:[NSString stringWithFormat:@"%@cm", mDict[@"heightFrom"]] forKey:@"height"];
                } else {
                    [mDict setObject:@"身高不限" forKey:@"height"];
                }
                
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
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    [activityIndicatorView startAnimating];
    
    NSString *url;
    NSDictionary *parameterDict;
    
    // 筛选条件
    NSString *sql;
    if (action == 0) {
        
        url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/save.html"];
        parameterDict = @{ @"table": @"user_target", @"userid": self.userid, @"type":type, @"target_userid":self.userModel.userid};
    } else if (action == 1) {
        
        sql = [NSString stringWithFormat:@"delete from user_target where userid = '%@' and type = '%@' and target_userid = '%@'", self.userid, type, self.userModel.userid];
        url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
        parameterDict = @{ @"sql": sql };
    } else {
        return;
    }
    
    //获取网络数据
    [HttpUtil query:url parameter:parameterDict success:^(id responseObject) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"*** success %@ ***", responseDict);
        
        responseCallback(responseDict[@"code"] ? responseDict : @{@"code":@"0"});
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
    } failure:^(NSError *error) {
        
        NSLog(@"*** failure %@ ***", error.description);
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
        
        responseCallback(@{@"code":@"1"});
        
        [SVProgressHUD showImage:nil status:@"操作失败"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.5];
    }];
}

@end
