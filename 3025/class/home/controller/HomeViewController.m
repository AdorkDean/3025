//
//  ViewController.m
//  3025
//
//  Created by ld on 2017/3/27.
//
//

#import "HomeViewController.h"
#import "UserModel.h"
#import "UserCell.h"
#import "DatabaseUtil.h"
#import "SortViewController.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate> {

}

@property (nonatomic, copy) NSArray *userList;
@property (nonatomic, strong) NSMutableDictionary *cellHeightDict;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshBackNormalFooter *refreshFooter;
@property (nonatomic, strong) MASConstraint *leftConstraint;
@property (nonatomic, strong) MASConstraint *rightConstraint;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) BOOL isAttentive;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setAutoresizesSubviews:NO];
    [self.view setBackgroundColor:kBackgroundColor];
    
    self.userList = [NSArray array];
    self.cellHeightDict = [NSMutableDictionary dictionary];
    
    [self setupNavigtion];
    [self setupUI];
    
    self.pageNumber = 0;
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kSort]) {

        self.pageNumber = 0;
        [self loadData];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSort];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.userList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"UserCell";
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    UserModel *userModel = [UserModel mj_objectWithKeyValues:[self.userList objectAtIndex:indexPath.section]];
    [cell setupData:userModel];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = 0.0;
    NSString *key = [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row];

    if (self.cellHeightDict[key]) {
        
        NSString *value = [self.cellHeightDict objectForKey:key];
        cellHeight = value.floatValue;
    } else {
        
        static UserCell *cell = nil;
        static dispatch_once_t predicate;
        
        dispatch_once(&predicate, ^{
            cell = [[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserCell"];
        });
        
        UserModel *userModel = [UserModel mj_objectWithKeyValues:[self.userList objectAtIndex:indexPath.section]];
        [cell setupData:userModel];
        
        cellHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1.0;
        
//        [self.cellHeightDict setObject:[NSString stringWithFormat:@"%f", cellHeight] forKey:key];
    }

    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *identifier = @"viewForHeader";
    
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!view) {
        view = [[UIView alloc] init];
        view.backgroundColor = kBackgroundColor;
    }
    
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - setter & getter

- (UIView *)headView {

    if (!_headView) {

        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor whiteColor];
        
        // 最新
        UIButton *latestButton = [[UIButton alloc] init];
        [latestButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [latestButton setTitle:@"最新" forState:UIControlStateNormal];
        [latestButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [latestButton setTitle:@"最新" forState:UIControlStateSelected];
        [latestButton setTitleColor:kKeyColor forState:UIControlStateSelected];
        [latestButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [latestButton setTag:0];
        
        // 竖线
        UIView *vLineView = [[UIView alloc] init];
        vLineView.backgroundColor = [UIColor lightGrayColor];
        
        // 关注
        UIButton *attentiveButton = [[UIButton alloc] init];
        [attentiveButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [attentiveButton setTitle:@"关注" forState:UIControlStateNormal];
        [attentiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [attentiveButton setTitle:@"关注" forState:UIControlStateSelected];
        [attentiveButton setTitleColor:kKeyColor forState:UIControlStateSelected];
        [attentiveButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [attentiveButton setTag:1];
        
        // 下划线
        UIView *hLineView = [[UIView alloc] init];
        hLineView.backgroundColor = kKeyColor;
        
        // 底部边框
        UIView *bLineView = [[UIView alloc] init];
        bLineView.backgroundColor = [UIColor lightGrayColor];
        
        [_headView addSubview:latestButton];
        [_headView addSubview:vLineView];
        [_headView addSubview:attentiveButton];
        [_headView addSubview:hLineView];
        [_headView addSubview:bLineView];
        
        [latestButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.height.mas_equalTo(_headView);
            make.width.mas_equalTo(_headView).multipliedBy(0.5);
        }];
        [vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_headView);
            make.height.mas_equalTo(_headView).multipliedBy(0.5);
            make.width.mas_equalTo(0.5);
        }];
        [attentiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.height.mas_equalTo(_headView);
            make.width.mas_equalTo(_headView).multipliedBy(0.5);
        }];
        [hLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_headView);
            make.height.mas_equalTo(3.0);
            make.width.mas_equalTo(30.0);
            self.leftConstraint = make.centerX.mas_equalTo(latestButton);
            self.rightConstraint = make.centerX.mas_equalTo(attentiveButton);
        }];
        [bLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.width.mas_equalTo(_headView);
            make.height.mas_equalTo(0.5);
        }];
        
        [latestButton setSelected:YES];
        self.isAttentive = NO;
        [self.leftConstraint activate];
        [self.rightConstraint deactivate];
    }

    return _headView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = self.refreshHeader;
        _tableView.mj_footer = self.refreshFooter;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

- (MJRefreshNormalHeader *)refreshHeader {
    
    if (!_refreshHeader) {
        
        _refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

            self.pageNumber = 0;
            [self loadData];
        }];
    }
    
    return _refreshHeader;
}

- (MJRefreshBackNormalFooter *)refreshFooter {
    
    if (!_refreshFooter) {
        
        _refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

            self.pageNumber++;
            [self loadData];
        }];
    }
    
    return _refreshFooter;
}

#pragma mark - action

- (void)goSort:(UIButton *)button {
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[SortViewController alloc] init]] animated:YES completion:nil];
}

- (void)click:(UIButton *)button {
    
    if (button.tag == 1) {
        
        if ([self goLogin:nil message:@"查看关注需要先登录帐号"]) {
            return;
        }
    }
    
    self.isAttentive = (button.tag == 1);
    self.pageNumber = 0;
    self.cellHeightDict = [NSMutableDictionary dictionary];
    [self loadData];
    
    for (UIView *subview in self.headView.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [(UIButton *)subview setSelected:(subview == button)];
        }
    }
    if (button.tag ==0) {
        [self.rightConstraint deactivate];
        [self.leftConstraint activate];
    } else {
        [self.leftConstraint deactivate];
        [self.rightConstraint activate];
    }
    [self.view layoutIfNeeded];
}

#pragma mark - 自定义

/**
 *  设定UI
 */
- (void)setupUI {
    
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];

    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.width.mas_equalTo(self.view);
        make.height.mas_equalTo(30.0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.mas_bottom);
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
}

- (void)setupNavigtion {

    // 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = kNavigationTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"首页";
    titleLabel.frame = CGRectMake(0, 7, 50, 30);
    
    UIButton *filterButton = [[UIButton alloc] init];
    filterButton.backgroundColor = kKeyColor;
    filterButton.layer.cornerRadius = 5;
    filterButton.frame = CGRectMake(0, 7, 50, 30);
    [filterButton setTitle:@"筛选" forState:UIControlStateNormal];
    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [filterButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [filterButton addTarget:self action:@selector(goSort:) forControlEvents:UIControlEventTouchUpInside];
    
    // 导航栏右侧
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

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
    
    // 筛选条件
    NSString *sql = [self sql];
    
    NSString *url;
    NSString *cacheUrl;
    NSDictionary *parameterDict;
    
    url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
    cacheUrl = [NSString stringWithFormat:@"%@?page=%@", url, @"Home"];
    parameterDict = @{ @"sql": sql };
    
    // 初次加载数据或者刷新
    if (self.pageNumber == 0) {
        
        // 取缓存数据
        NSString *response = [DatabaseUtil response:cacheUrl effective:0];
        if (response) {
            
            NSData *responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
            self.userList = responseDict[@"list"];
            
            [self.tableView reloadData];
        }
    }

    //获取网络数据
    [HttpUtil query:url parameter:parameterDict success:^(id responseObject) {

        NSString *json = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *array;
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        array = responseDict[@"list"];

        if (self.pageNumber == 0) {
            
            self.userList = array;
            
            // 缓存网络请求数据到本地
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [DatabaseUtil cacheResponse:json forURL:cacheUrl];
            });
        } else {
            if (array.count > 0) {
                
                NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.userList];
                [mArray addObjectsFromArray:array];
                self.userList = [NSArray arrayWithArray:mArray];
            } else {
                
                [SVProgressHUD showImage:nil status:@"已加载全部数据"];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD dismissWithDelay:1.5];
            }
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
    } failure:^(NSError *error) {

        NSLog(@"*** failure %@ ***", error.description);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.pageNumber > 0) {
            self.pageNumber--;
        }
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];

        [SVProgressHUD showImage:nil status:@"加载失败"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.5];
    }];
}

// 获取筛选页数据
- (NSString *)sql {
    
    NSString *sortSql = @"";
    
    // 筛选页 用户ID
    NSString *sortUserid = [[NSUserDefaults standardUserDefaults] objectForKey:kSortUserid];
    
    if (sortUserid) {
        
        sortSql = [NSString stringWithFormat:@" and u.userid = '%@' ", sortUserid];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSortUserid];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        
        // 筛选页 其他
        NSArray *sortArr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSort];
        if (sortArr) {
            for (int i=0; i<sortArr.count; i++) {
                
                NSDictionary *dict = sortArr[i];
                NSString *value = dict[@"value"];
                NSString *value2 = dict[@"value2"];

                if ([value isEqualToString:@"不限"] && (!value2 || [value2 isEqualToString:@"不限"])) {
                    continue;
                }
                // 性别
                if (i == 0) {

                    sortSql = [sortSql stringByAppendingString:[NSString stringWithFormat:@" and u.sex = '%@' ", value]];
                }
                // 年龄
                if (i == 1) {
                    
                    if (![value isEqualToString:@"不限"]) {

                        int age = [[value substringWithRange:NSMakeRange(0, 2)] intValue];
                        int year = [[ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyy"] intValue];
                        NSString *monthDay = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"MM-dd"];
                        
                        sortSql = [sortSql stringByAppendingString:[NSString stringWithFormat:@" and u.birthday <= '%d-%@' ", (year - age), monthDay]];
                    }
                    if (![value2 isEqualToString:@"不限"]) {
                        
                        int age = [[value2 substringWithRange:NSMakeRange(0, 0)] intValue];
                        int year = [[ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyy"] intValue];
                        NSString *monthDay = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"MM-dd"];
                        
                        sortSql = [sortSql stringByAppendingString:[NSString stringWithFormat:@" and u.birthday >= '%d-%@' ", (year - age), monthDay]];
                    }
                }
                // 身高
                if (i == 2) {
                    
                    sortSql = [sortSql stringByAppendingString:[NSString stringWithFormat:@" and u.height >= '%@' ", [value substringWithRange:NSMakeRange(0, 3)]]];
                }
                // 户籍
                if (i == 3) {
                    
                    value = [value stringByReplacingOccurrencesOfString:@"省" withString:@""];
                    value = [value stringByReplacingOccurrencesOfString:@"市" withString:@""];
                    if (![value containsString:@"-"]) {
                        value = [NSString stringWithFormat:@"%@-%@", value, value];
                    }
                    
                    sortSql = [sortSql stringByAppendingString:[NSString stringWithFormat:@" and u.domicile = '%@' ", value]];
                }
                // 常住城市
                if (i == 4) {
                    
                    value = [value stringByReplacingOccurrencesOfString:@"省" withString:@""];
                    value = [value stringByReplacingOccurrencesOfString:@"市" withString:@""];
                    if (![value containsString:@"-"]) {
                        value = [NSString stringWithFormat:@"%@-%@", value, value];
                    }
                    
                    sortSql = [sortSql stringByAppendingString:[NSString stringWithFormat:@" and u.residence = '%@' ", value]];
                }
                // 最高学历
                if (i == 5) {
                    
                    value = [value stringByReplacingOccurrencesOfString:@"及以上" withString:@""];
                    NSUInteger index = [kEducation indexOfObject:value];
                    
                    sortSql = [sortSql stringByAppendingString:[NSString stringWithFormat:@" and u.education >= '0%ld' ", index]];
                }
                // 月收入
                if (i == 6) {
                    
                    value = [value stringByReplacingOccurrencesOfString:@"及以上" withString:@""];
                    
                    sortSql = [sortSql stringByAppendingString:[NSString stringWithFormat:@" and u.salary >= '%@' ", value]];
                }
                // 单位性质
                if (i == 7) {
                    
                    sortSql = [sortSql stringByAppendingString:[NSString stringWithFormat:@" and u.unit_nature = '0%ld' ", [kUnitNature indexOfObject:value]]];
                }
                // 婚姻状态
                if (i == 8) {
                    
                    sortSql = [sortSql stringByAppendingString:[NSString stringWithFormat:@" and u.marital_status = '0%ld' ", [kMaritalStatus indexOfObject:value]]];
                }
                // 婚房
                if (i == 9) {
                    
                    sortSql = [sortSql stringByAppendingString:[NSString stringWithFormat:@" and u.house = '0%ld' ", [kHouseStatus indexOfObject:value]]];
                }
            }
        }
    }
    
    NSString *sql = [NSString stringWithFormat:@"\
                     select \
                         u.birthday, \
                         u.comment, \
                         u.domicile, \
                         u.education, \
                         u.height, \
                         u.house, \
                         u.important, \
                         u.marital_status maritalStatus, \
                         u.nickname, \
                         u.position, \
                         u.poster, \
                         u.residence, \
                         u.salary, \
                         u.sex, \
                         u.signature, \
                         u.unit_nature, \
                         u.userid, \
                         concat(c.ageFrom, '-', c.ageTo) conditionAge, \
                         concat(c.domicileprovince, '-', c.domicilecity) conditionDomicile \
                     from \
                         user u \
                     left join \
                         conditions c \
                     on \
                             c.userid = u.userid \
                         and c.category = '01' \
                     where \
                         u.userid != '%@' \
                         %@ \
                         %@ \
                         %@ \
                     order by \
                         u.updatetime desc \
                     limit \
                     %ld, 10;",
                     self.userid,
                     self.userid ? [NSString stringWithFormat:@" AND u.userid NOT IN (SELECT userid FROM user_target WHERE target_userid = '%@' AND type = '0') ", self.userid] : @"", // 未被拉黑
                     self.isAttentive ? [NSString stringWithFormat:@" AND u.userid IN (SELECT target_userid FROM user_target WHERE userid = '%@' AND type = '1') ", self.userid] : @"", // 我关注的
                     sortSql, // 检索条件
                     self.pageNumber * 10];
    
    return sql;
}

@end
