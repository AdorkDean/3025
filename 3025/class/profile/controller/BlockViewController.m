//
//  BlockViewController.m
//  3025
//
//  Created by WangErdong on 2017/6/4.
//
//

#import "BlockViewController.h"
#import "BlockModel.h"
#import "BlockCell.h"
#import "DatabaseUtil.h"
#import "SortViewController.h"

@interface BlockViewController () <UITableViewDataSource, UITableViewDelegate> {
    
}

@property (nonatomic, copy) NSArray *userList;
@property (nonatomic, strong) NSMutableDictionary *cellHeightDict;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshBackNormalFooter *refreshFooter;
@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userList = [NSArray array];
    self.cellHeightDict = [NSMutableDictionary dictionary];
    
    [self setupNavigtion];
    [self setupUI];
    
    self.pageNumber = 0;
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kSort]) {
        
        self.pageNumber = 0;
        [self loadData];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSort];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.userList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"BlockCell";
    
    BlockCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[BlockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    BlockModel *userModel = [BlockModel mj_objectWithKeyValues:[self.userList objectAtIndex:indexPath.section]];
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
        
        static BlockCell *cell = nil;
        static dispatch_once_t predicate;
        
        dispatch_once(&predicate, ^{
            cell = [[BlockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserCell"];
        });
        
        BlockModel *userModel = [BlockModel mj_objectWithKeyValues:[self.userList objectAtIndex:indexPath.section]];
        [cell setupData:userModel];
        
        cellHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1.0;
        
        [self.cellHeightDict setObject:[NSString stringWithFormat:@"%f", cellHeight] forKey:key];
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

- (void)back:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 自定义

/**
 *  设定UI
 */
- (void)setupUI {
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:kBackgroundColor];

    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
}

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
    titleLabel.text = @"黑名单管理";
    titleLabel.frame = CGRectMake(0, 7, 50, 30);
    
    // 导航栏右侧
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.titleView = titleLabel;
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
    cacheUrl = [NSString stringWithFormat:@"%@?page=%@", url, @"Block"];
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
                         u.userid \
                     from \
                         user u \
                     where \
                        %@ \
                     order by \
                        u.updatetime desc \
                     limit \
                        %ld, 10;",
                     [NSString stringWithFormat:@" u.userid IN (SELECT target_userid FROM user_target WHERE userid = '%@' AND type = '0') ", self.userid], // 拉黑
                     self.pageNumber * 10];
    
    return sql;
}

@end
