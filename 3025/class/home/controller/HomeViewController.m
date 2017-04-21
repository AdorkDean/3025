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
@property (nonatomic, assign) NSUInteger pageNumber;
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

- (void)click:(UIButton *)button {
    
    self.isAttentive = (button.tag == 1);
    self.pageNumber = 0;
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
    
    UIView *customView = [[UIView alloc] init];

    UILabel *locationLabel = [[UILabel alloc] init];
    locationLabel.font = [UIFont systemFontOfSize:14.0f];
    locationLabel.textColor = kNavigationTitleColor;
    locationLabel.text = @"上海";
    
    UIImageView *locationImageView = [[UIImageView alloc] init];
    locationImageView.contentMode = UIViewContentModeScaleToFill;
    locationImageView.image = [UIImage imageNamed:@"location"];
    
    [customView addSubview:locationLabel];
    [customView addSubview:locationImageView];
    
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(customView);
        make.centerY.mas_equalTo(customView);
    }];
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(locationLabel.mas_right).offset(0);
        make.centerY.mas_equalTo(customView);
        make.height.width.mas_equalTo(16);
    }];
    
    // 导航栏左侧
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
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
    
    // 导航栏右侧
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

/**
 *  加载数据
 */
- (void)loadData {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"userListPerPage.html"];
    NSString *interest = (self.isAttentive ? @"1" : @"0");
    NSString *cacheUrl = [NSString stringWithFormat:@"%@?interest=%@", url, interest];
    
    // 初次加载数据或者刷新
    if (self.pageNumber == 0) {
        
        // 取缓存数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *response = [DatabaseUtil response:cacheUrl effective:60];
            if (response) {
                
                self.userList = [NSArray mj_objectArrayWithKeyValuesArray:response];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                });
            }
        });
    }

    //获取网络数据
    NSDictionary *patamterDict = @{@"pageNumber":[NSString stringWithFormat:@"%ld", self.pageNumber],
                                   @"interest":interest,
                                   @"userid":self.userid};
    
    AFHTTPSessionManager *httpSessionManager = [AFHTTPSessionManager manager];
    httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [httpSessionManager POST:url parameters:patamterDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *json = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *array = [NSArray mj_objectArrayWithKeyValuesArray:json];
        
        if (array.count > 0) {
            
            if (self.pageNumber == 0) {
                
                self.userList = array;
                
                // 缓存网络请求数据到本地
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    [DatabaseUtil cacheResponse:json forURL:cacheUrl];
                });
            } else {
                
                NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.userList];
                [mArray addObjectsFromArray:array];
                self.userList = [NSArray arrayWithArray:mArray];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            });
        } else {
            
            [SVProgressHUD showImage:nil status:@"已加载全部数据"];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD dismissWithDelay:1.5];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"*** failure %@ ***", error.description);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.pageNumber > 0) {
            self.pageNumber--;
        }
        [SVProgressHUD showImage:nil status:@"加载失败"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.5];
    }];
}

@end
