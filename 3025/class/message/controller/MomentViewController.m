//
//  MomentViewController.m
//  3025
//
//  Created by ld on 2017/5/27.
//
//

#import "MomentViewController.h"
#import "MomentCell.h"
#import "MomentModel.h"
#import "ImageBrowser.h"
#import "PublishViewController.h"

@interface MomentViewController () <UITableViewDataSource, UITableViewDelegate, MomentCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshBackNormalFooter *refreshFooter;

@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, copy) NSArray *momentList;
@property (nonatomic, strong) NSMutableDictionary *contentStateDict;

@end

@implementation MomentViewController

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
    titleLabel.text = @[@"生活圈", @"我的生活圈"][self.category];
    titleLabel.frame = CGRectMake(0, 7, 50, 30);
    
    UIButton *rightButton = [[UIButton alloc] init];
    rightButton.backgroundColor = kKeyColor;
    rightButton.layer.cornerRadius = 5;
    rightButton.frame = CGRectMake(0, 7, 50, 30);
    [rightButton setTitle:@[@"我的", @"生活圈"][self.category] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [rightButton addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    
    // 导航栏右侧
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    // 导航栏右侧
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)setupUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:@"camera"];
    imageView.backgroundColor = kKeyColor;
    imageView.layer.cornerRadius = 20;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toPublishMoment:)]];
    
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.height.width.mas_equalTo(40);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).mas_offset(-20);
    }];
}

#pragma mark - 事件处理

- (void)toPublishMoment:(UITapGestureRecognizer *)tapGestureRecognizer {

    PublishViewController *vc = [[PublishViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

- (void)back:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)change:(UIButton *)button {
    
    // 跳转到我的生活圈
    if (self.category == 0) {
        if ([self goLogin:nil message:@"请先登录帐号"]) {
            return;
        }
    }
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([[viewControllers objectAtIndex:(viewControllers.count - 2)] isKindOfClass:[MomentViewController class]]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {

        MomentViewController *vc = [[MomentViewController alloc] init];
        vc.category = (self.category == 0) ? 1 : 0;
    
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
        _tableView.mj_header = self.refreshHeader;
        _tableView.mj_footer = self.refreshFooter;
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

- (NSArray *)momentList {
    if (!_momentList) {
        _momentList = [NSArray array];
    }
    return _momentList;
}

- (NSMutableDictionary *)contentStateDict {
    if (!_contentStateDict) {
        _contentStateDict = [NSMutableDictionary dictionary];
    }
    return _contentStateDict;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.momentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"MomentCell";
    MomentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    MomentModel *momentModel = [MomentModel mj_objectWithKeyValues:[self.momentList objectAtIndex:indexPath.row]];
    cell.delegate = self;
    cell.isMine = (self.category == 1);
    cell.isExtend = [[self.contentStateDict objectForKey:indexPath] isEqualToString:@"1"];
    [cell setupData:momentModel];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"MomentCell";
    static dispatch_once_t predicate;
    static MomentCell *cell;
    
    dispatch_once(&predicate, ^{
        cell = [[MomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    });
    
    MomentModel *momentModel = [MomentModel mj_objectWithKeyValues:[self.momentList objectAtIndex:indexPath.row]];
    cell.isMine = (self.category == 1);
    cell.isExtend = [[self.contentStateDict objectForKey:indexPath] isEqualToString:@"1"];
    [cell setupData:momentModel];
    
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - MomentCellDelegate

- (void)showContent:(UIEvent *)event {

    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    
    NSString *isExtend = [self.contentStateDict objectForKey:indexPath];
    isExtend = [isExtend isEqualToString:@"1"] ? @"0" : @"1";
    
    [self.contentStateDict setObject:isExtend forKey:indexPath];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)showImages:(NSUInteger)currentIndex gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {

    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath =[self.tableView indexPathForRowAtPoint:point];
    
    MomentModel *momentModel = [MomentModel mj_objectWithKeyValues:[self.momentList objectAtIndex:indexPath.row]];
    
    NSMutableArray *mArr = [NSMutableArray array];
    if ([ConversionUtil isNotEmpty:momentModel.image1]) {
        [mArr addObject:momentModel.image1];
    }
    if ([ConversionUtil isNotEmpty:momentModel.image2]) {
        [mArr addObject:momentModel.image2];
    }
    if ([ConversionUtil isNotEmpty:momentModel.image3]) {
        [mArr addObject:momentModel.image3];
    }
    
    [ImageBrowser show:[NSArray arrayWithArray:mArr] currentIndex:gestureRecognizer.view.tag];
}

- (void)deleteMoment:(UIEvent *)event {

    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath =[self.tableView indexPathForRowAtPoint:currentTouchPosition];
    
    [self removeMoment:indexPath];
}

#pragma mark - 加载数据

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
    cacheUrl = [NSString stringWithFormat:@"%@?page=%@&category=%ld", url, @"Moment", self.category];
    parameterDict = @{ @"sql": sql };
    
    // 初次加载数据或者刷新
    if (self.pageNumber == 0 && !self.refreshHeader.isRefreshing) {

        // 取缓存数据
        NSString *response = [DatabaseUtil response:cacheUrl effective:0];
        if (response) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            NSArray *arr = responseDict[@"list"];
            self.momentList = [NSArray arrayWithArray:arr];

            [self.tableView reloadData];
        }
    }
    
    //获取网络数据
    [HttpUtil query:url parameter:parameterDict success:^(id responseObject) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = responseDict[@"list"];

        if (self.pageNumber == 0) {
            
            self.momentList = [NSArray arrayWithArray:arr];
            
            // 缓存网络请求数据到本地
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [DatabaseUtil cacheResponse:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] forURL:cacheUrl];
            });
        } else {
            if (arr.count > 0) {
                
                NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.momentList];
                [mArr addObjectsFromArray:arr];
                self.momentList = [NSArray arrayWithArray:mArr];
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

- (void)removeMoment:(NSIndexPath *)indexPath {
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    [activityIndicatorView startAnimating];
    
    NSString *url;
    NSDictionary *parameterDict;
    MomentModel *momentModel = [MomentModel mj_objectWithKeyValues:[self.momentList objectAtIndex:indexPath.row]];
    
    // 筛选条件
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM moment WHERE momentid = %@", momentModel.momentid];
    
    url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
    parameterDict = @{ @"sql": sql };

    //获取网络数据
    [HttpUtil query:url parameter:parameterDict success:^(id responseObject) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"*** success %@ ***", responseDict);
        
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.momentList];
        [mArr removeObjectAtIndex:indexPath.row];
        self.momentList = [NSArray arrayWithArray:mArr];

        [self.contentStateDict removeObjectForKey:indexPath];

        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
    } failure:^(NSError *error) {
        
        NSLog(@"*** failure %@ ***", error.description);

        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
        
        [SVProgressHUD showImage:nil status:@"删除失败"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.5];
    }];
}

- (NSString *)sql {

    NSString *sql = [NSString stringWithFormat:@"SELECT \
                                                     u.poster, \
                                                     u.nickname, \
                                                     m.content, \
                                                     m.image1, \
                                                     m.image2, \
                                                     m.image3, \
                                                     DATE_FORMAT(m.createtime, '%@') AS createtime, \
                                                     m.momentid, \
                                                     m.userid \
                                                 FROM \
                                                     moment m, \
                                                     user u \
                                                 WHERE \
                                                     u.userid = m.userid \
                                                     %@ \
                                                     AND m.userid NOT IN (SELECT userid FROM user_target WHERE target_userid = '%@' AND type = '0') \
                                                 ORDER BY \
                                                     m.createtime DESC \
                                                 LIMIT %ld, %ld"
                     , @"%Y/%m/%d %H:%i:%s"
                     , (self.category == 0) ? [NSString stringWithFormat:@" AND u.userid != '%@' ", self.userid] : [NSString stringWithFormat:@" AND u.userid = '%@' ", self.userid]
                     , self.userid
                     , self.pageNumber * 10
                     , self.pageNumber * 10 + 10
                     ];
    
    return sql;
}

@end
