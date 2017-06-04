//
//  MessageViewController.m
//  3025
//
//  Created by ld on 2017/3/27.
//
//

#import "MessageViewController.h"
#import "MomentViewController.h"
#import "ChatViewController.h"
#import "MessageCell.h"

@interface MessageViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {

}

@property (nonatomic, copy) NSString *latetime;
@property (nonatomic, copy) NSDictionary *discoverDict;
@property (nonatomic, strong) NSMutableArray *messageList;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UIImageView *dotImageView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:kBackgroundColor];
    
    self.messageList = [NSMutableArray array];
    
    [self setupNavigtion];
    [self setupUI];
    
    [self setupDiscover];
    [self setupMessages];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupDiscover];
    [self setupMessages];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

/**
 *  设定UI
 */
- (void)setupUI {
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.height.mas_equalTo(60);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
}

- (void)setupNavigtion {
    
    // 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = kNavigationTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"消息";
    titleLabel.frame = CGRectMake(0, 7, 50, 30);

    self.navigationItem.titleView = titleLabel;
}

#pragma mark - 事件处理

- (void)goDiscover:(UIGestureRecognizer *)gestureRecognizer {
    
    MomentViewController *vc = [[MomentViewController alloc] init];
    vc.category = 0;

    [self.navigationController pushViewController:vc animated:YES];
    [self updateLasttime];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSDictionary *messageDict = [self.messageList objectAtIndex:indexPath.row];
    MessageModel *messageModel = [MessageModel mj_objectWithKeyValues:messageDict];
    
    [cell setupData:messageModel];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MessageModel *messageModel = [MessageModel mj_objectWithKeyValues:[self.messageList objectAtIndex:indexPath.row]];
    if ([messageModel.status isEqualToString:@"0"]) {
        
        [self updateMessage:messageModel status:@"1"];
    }
    
    ChatViewController *vc = [[ChatViewController alloc] init];
    vc.withUserid = messageModel.withUserid;
    vc.me_poster = messageModel.me_poster;
    vc.withUsername = messageModel.other_nickname;
    vc.other_poster = messageModel.other_poster;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    MessageModel *messageModel = [MessageModel mj_objectWithKeyValues:[self.messageList objectAtIndex:indexPath.row]];
    [self updateMessage:messageModel status:@"9"];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y < 0) {
            scrollView.contentOffset = CGPointMake(0, 0);
        }
    }
}

#pragma mark - setter and getter

- (UIView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goDiscover:)]];
        
        UIImageView *leftImageView = [[UIImageView alloc] init];
        leftImageView.image = [UIImage imageNamed:@"discover"];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"查看生活圈";
        
        UIImageView *posterImageView = [[UIImageView alloc] init];
        posterImageView.layer.borderColor = kKeyColor.CGColor;
        posterImageView.layer.borderWidth = 1;
        posterImageView.layer.cornerRadius = 20.0f;
        posterImageView.layer.masksToBounds = YES;
        posterImageView.image = [UIImage imageNamed:@"poster"];
        
        UIImageView *dotImageView = [[UIImageView alloc] init];
        dotImageView.backgroundColor = [UIColor redColor];
        dotImageView.layer.cornerRadius = 5.0f;
        dotImageView.layer.masksToBounds = YES;
        dotImageView.hidden = YES;
        
        UIImageView *rightImageView = [[UIImageView alloc] init];
        rightImageView.image = [UIImage imageNamed:@"arrow"];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineColor;
        
        [_headerView addSubview:leftImageView];
        [_headerView addSubview:titleLabel];
        [_headerView addSubview:posterImageView];
        [_headerView addSubview:dotImageView];
        [_headerView addSubview:rightImageView];
        [_headerView addSubview:lineView];
        
        [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headerView).offset(10);
            make.centerY.mas_equalTo(_headerView);
            make.height.width.mas_equalTo(30);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftImageView.mas_right).offset(10);
            make.centerY.mas_equalTo(_headerView);
        }];
        [posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightImageView.mas_left).offset(-10);
            make.centerY.mas_equalTo(_headerView);
            make.height.width.mas_equalTo(40);
        }];
        [dotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(posterImageView.mas_top);
            make.centerX.mas_equalTo(posterImageView.mas_right);
            make.height.width.mas_equalTo(10);
        }];
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_headerView).offset(-10);
            make.centerY.mas_equalTo(_headerView);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.bottom.mas_equalTo(_headerView);
            make.height.mas_equalTo(1);
        }];
        
        self.posterImageView = posterImageView;
        self.dotImageView = dotImageView;
    }
    
    return _headerView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

#pragma mark - 获取数据

// 获取生活圈数据
- (void)setupDiscover {
    
    if (self.me.userid) {
        [self setupLasttime];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
    NSDictionary *paramDict = @{
                                @"sql": [NSString stringWithFormat:@"select DATE_FORMAT(m.createtime, '%@') createtime, u.poster from moment m, user u where u.userid = m.userid %@ order by m.createtime desc limit 0, 1", @"%Y-%m-%d %T", self.me.userid ? [NSString stringWithFormat:@"and u.userid != %@", self.me.userid] : @""]
                                };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *discoverList = [responseDict objectForKey:@"list"];
            if (discoverList.count > 0) {
                
                self.discoverDict = [discoverList firstObject];
                if (self.discoverDict) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.latetime) {
                            if ([self.latetime compare:self.discoverDict[@"createtime"]] == NSOrderedAscending) {
                                self.dotImageView.hidden = NO;
                            } else {
                                self.dotImageView.hidden = YES;
                            }
                        } else {
                            self.dotImageView.hidden = NO;
                        }
                        [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:self.discoverDict[@"poster"]] placeholderImage:[UIImage imageNamed:@"poster"]];
                    });
                }
            }
        } @catch (NSException *exception) {
            NSLog(@"*** %@ ***", exception);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"*** %@ ***", error);
    }];
}

// 获取上一次打开生活圈的时间
- (void)setupLasttime {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
    NSDictionary *paramDict = @{
                                @"sql": [NSString stringWithFormat:@"select value from preference where userid = %@ and page = 'message' and item = 'lasttime'", self.me.userid]
                                };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *discoverList = [responseDict objectForKey:@"list"];
            if (discoverList.count > 0) {
                
                NSDictionary *discoverDict = [discoverList firstObject];
                self.latetime = discoverDict[@"value"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.latetime) {
                        if (self.discoverDict) {
                            if ([self.latetime compare:self.discoverDict[@"createtime"]] == NSOrderedAscending) {
                                self.dotImageView.hidden = NO;
                            } else {
                                self.dotImageView.hidden = YES;
                            }
                        } else {
                            self.dotImageView.hidden = YES;
                        }
                    } else {
                        self.dotImageView.hidden = NO;
                    }
                });
            }
        } @catch (NSException *exception) {
            NSLog(@"*** %@ ***", exception);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"*** %@ ***", error);
    }];
}

// 获取消息数据
- (void)setupMessages {
    
    if (!self.me.userid) {
        
        self.messageList = [NSMutableArray array];
        [self.tableView reloadData];
        
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
    NSString *sql = [NSString stringWithFormat:@"SELECT \
                                                    m1.withUserid, \
                                                    m1.createtime, \
                                                    m1.content, \
                                                    m1.status, \
                                                    me.poster me_poster, \
                                                    other.poster other_poster, \
                                                    other.nickname other_nickname \
                                                FROM \
                                                    message m1, \
                                                    (SELECT \
                                                        userid, \
                                                        withUserid, \
                                                        max(msgNO) msgNO \
                                                    FROM \
                                                        message \
                                                    WHERE \
                                                            userid  = %@ \
                                                        AND status != '9' \
                                                    GROUP BY \
                                                        withUserid \
                                                    ) m2, \
                                                    user me, \
                                                    user other \
                                                WHERE \
                                                        m1.userid 		= m2.userid \
                                                    AND m1.withUserid 	= m2.withUserid \
                                                    AND m1.msgNO 		= m2.msgNO \
                                                    AND m1.status      != '9' \
                                                    AND me.userid       = m1.userid \
                                                    AND other.userid    = m1.withUserid \
                                                    ORDER BY \
                                                        m1.status 		ASC, \
                                                        m1.updatetime 	DESC;", self.me.userid];
    
    NSDictionary *paramDict = @{
                                @"sql": sql
                                };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *messageList = [responseDict objectForKey:@"list"];
            self.messageList = [NSMutableArray arrayWithArray:messageList];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } @catch (NSException *exception) {
            NSLog(@"*** %@ ***", exception);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"*** %@ ***", error);
    }];
}

// 更新打开生活圈的时间
- (void)updateLasttime {
    
    if (!self.me.userid) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
    NSString *sql = [NSString stringWithFormat:@"delete from preference where userid = %@ and page = 'message' and item = 'lasttime'", self.me.userid];
    NSDictionary *paramDict = @{ @"sql": sql };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"*** %@ ***", dict);
        
        // 获得当前时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *now = [dateFormatter stringFromDate:[NSDate date]];
        
        NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
        NSString *sql = [NSString stringWithFormat:@"insert into preference ( \
                                                                                userid, \
                                                                                page, \
                                                                                item, \
                                                                                value, \
                                                                                createtime, \
                                                                                updatetime \
                                                                            ) values \
                                                                            ( \
                                                                                '%@', \
                                                                                'message', \
                                                                                'lasttime', \
                                                                                '%@', \
                                                                                now(), \
                                                                                now() \
                                                                            )", self.me.userid, now];
        NSDictionary *paramDict = @{ @"sql": sql };
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:url parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"*** %@ ***", dict);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"*** %@ ***", error);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"*** %@ ***", error);
    }];
}

// 更新消息状态（0:未读，1:已读，9:删除）
- (void)updateMessage:(MessageModel *)messageModel status:(NSString *)status {
    
    if (!self.me.userid) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
    NSString *sql = [NSString stringWithFormat:@"update message set status = '%@' where userid = %@ and withUserid = %@ %@", status, self.me.userid, messageModel.withUserid, [status isEqualToString:@"9"]?@"and status != '9'":@"and status = '0'"];
    
    NSDictionary *paramDict = @{ @"sql": sql };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"*** %@ ***", dict);
        
        if ([status isEqualToString:@"9"]) {
            
            [self setupMessages];
        } else {
            
            [self setupUnreadCount];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"*** %@ ***", error);
    }];
}

// 设定未读消息数
- (void)setupUnreadCount {

    NSString *userid = self.me.userid;
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
        
        int count = [dict[@"list"][0][@"count"] intValue];
        if (count > 0) {
            
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", count];
        } else {
            
            self.tabBarItem.badgeValue = nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"*** %@ ***", error);
    }];
}

@end
