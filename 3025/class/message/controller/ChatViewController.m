//
//  ChatViewController.m
//  3025
//
//  Created by WangErdong on 2017/6/3.
//
//

#import "ChatViewController.h"
#import "SocketRocket.h"
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate, SRWebSocketDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) NSMutableArray *messageList;
@property (nonatomic, strong) SRWebSocket *webSocket;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigtion];
    [self setupUI];
    [self setupMessages];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self.webSocket open];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self.webSocket close];
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
    titleLabel.text = self.withUsername;
    titleLabel.frame = CGRectMake(0, 7, 50, 30);
    
    // 导航栏左侧
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.titleView = titleLabel;
}

- (void)setupUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit:)]];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.bottom.mas_equalTo(self.footerView.mas_top);
    }];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
        make.height.mas_equalTo(49);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"ChatCell";
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSDictionary *messageDict = [self.messageList objectAtIndex:indexPath.row];
    NSDictionary *previousDict;
    if (indexPath.row > 0) {
        previousDict = [self.messageList objectAtIndex:(indexPath.row - 1)];
    }
    
    [cell setupData:messageDict preData:previousDict];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"ChatCell";
    static dispatch_once_t predicate;
    static ChatCell *cell;
    
    dispatch_once(&predicate, ^{
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    });
    
    NSDictionary *messageDict = [self.messageList objectAtIndex:indexPath.row];
    NSDictionary *previousDict;
    if (indexPath.row > 0) {
        previousDict = [self.messageList objectAtIndex:(indexPath.row - 1)];
    }
    
    [cell setupData:messageDict preData:previousDict];
    
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

#pragma mark - 事件处理

- (void)back:(UIButton *)button {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)endEdit:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    [self.view endEditing:YES];
}

- (void)sendMessage:(UIButton *)button {
    
    NSString *message = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (message.length > 0) {
        
        [self.webSocket send:message];
        
        [self.view endEditing:YES];
        self.textField.text = @"";

        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"1" forKey:@"action"];
        [mDict setObject:message forKey:@"content"];
        [mDict setObject:message forKey:@"createtime"];
        [mDict setObject:self.me_poster forKey:@"me_poster"];
        [mDict setObject:self.other_poster forKey:@"other_poster"];
        
        [self.messageList addObject:mDict];
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.messageList.count - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    float duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *aValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [aValue CGRectValue];

    [UIView animateWithDuration:duration animations:^{
        
        [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.width.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).mas_offset(-frame.size.height);
            make.height.mas_equalTo(49);
        }];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    float duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.width.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
            make.height.mas_equalTo(49);
        }];
    }];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@" *** %@ *** ", NSStringFromSelector(_cmd));
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@" *** %@ %@ *** ", NSStringFromSelector(_cmd), message);
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"0" forKey:@"action"];
    [mDict setObject:message forKey:@"content"];
    [mDict setObject:message forKey:@"createtime"];
    [mDict setObject:self.me_poster forKey:@"me_poster"];
    [mDict setObject:self.other_poster forKey:@"other_poster"];
    
    [self.messageList addObject:mDict];
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.messageList.count - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@" *** %@ %@ *** ", NSStringFromSelector(_cmd), error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(nullable NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@" *** %@ %ld %@ %@ *** ", NSStringFromSelector(_cmd), code, reason, wasClean ? @"YES" : @"NO");
}


#pragma mark - getter

- (SRWebSocket *)webSocket {
    if (!_webSocket) {
        _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://www.viewatmobile.cn/3025/websocket/%@/%@", self.userid, self.withUserid]]];
        _webSocket.delegate = self;
    }
    return _webSocket;
}

- (UIView *)footerView {
    
    if (!_footerView) {
        
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.layer.cornerRadius = 5;
        textField.layer.borderColor = kLineColor.CGColor;
        textField.layer.borderWidth = 1;
        textField.font = [UIFont systemFontOfSize:16.0f];
        textField.textColor = [UIColor blackColor];

        UIButton *sendButton = [[UIButton alloc] init];
        sendButton.backgroundColor = kButtonColor;
        sendButton.layer.cornerRadius = 5;
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:textField];
        [_footerView addSubview:sendButton];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_footerView).offset(15);
            make.centerY.mas_equalTo(_footerView);
            make.height.mas_equalTo(30);
        }];
        [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(textField.mas_right).offset(10);
            make.centerY.mas_equalTo(_footerView);
            make.right.mas_equalTo(_footerView).offset(-15);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(30);
        }];
        
        self.textField = textField;
    }
    
    return _footerView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

#pragma mark - 获取数据

// 获取聊天消息数据
- (void)setupMessages {
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    [activityIndicatorView startAnimating];

    NSString *sql = [NSString stringWithFormat:@"\
                     SELECT \
                         t0.action, \
                         t0.content, \
                         DATE_FORMAT(t0.createtime, '%@') createtime, \
                         t1.poster me_poster, \
                         t2.poster other_poster \
                     FROM \
                         message t0, \
                         user    t1, \
                         user    t2 \
                     WHERE  \
                             t0.userid 		= %@ \
                         AND t0.withUserid 	= %@ \
                         AND t0.status 	   != '9'  \
                         AND t1.userid       = t0.userid \
                         AND t2.userid    = t0.withUserid \
                     ORDER BY  \
                         t0.msgNO ASC;", @"%Y-%m-%d %T", self.userid, self.withUserid];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
    NSDictionary *paramDict = @{ @"sql" : sql };
    
    [HttpUtil query:url parameter:paramDict success:^(id responseObject) {

        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        self.messageList = responseDict[@"list"];
        [self.tableView reloadData];
        if (self.messageList.count > 0) {

            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.messageList.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
    } failure:^(NSError *error) {
        
        NSLog(@"*** failure %@ ***", error.description);
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
        
        [SVProgressHUD showImage:nil status:@"聊天信息获取失败"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.5];
    }];
}

@end
