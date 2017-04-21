//
//  ActivityViewController.m
//  3025
//
//  Created by ld on 2017/3/27.
//
//

#import "ActivityViewController.h"
#import "ActivityCell.h"

@interface ActivityViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    
}

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *filterView;
@property (nonatomic, strong) UIView *joinView;
@property (nonatomic, strong) UIView *tabBarShadowView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *activityArray;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setAutoresizesSubviews:NO];
    [self.view setBackgroundColor:kBackgroundColor];
    
    [self setupNavigtion];
    [self setupUI];
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

    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.filterView];
    [self.view addSubview:self.joinView];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.width.mas_equalTo(self.view);
        make.height.mas_equalTo(84);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.mas_bottom);
        make.left.width.bottom.mas_equalTo(self.view);
    }];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.mas_bottom);
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
    [self.joinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.mas_bottom);
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
    
    self.filterView.hidden = YES;
    self.joinView.hidden = YES;
}

/**
 *  设定导航栏
 */
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
    titleLabel.text = @"活动";
    titleLabel.frame = CGRectMake(0, 0, 50, 30);
    
    UIButton *filterButton = [[UIButton alloc] init];
    filterButton.backgroundColor = kKeyColor;
    filterButton.layer.cornerRadius = 5;
    filterButton.frame = CGRectMake(0, 0, 75, 30);
    [filterButton setTitle:@"发起活动" forState:UIControlStateNormal];
    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [filterButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    // 导航栏右侧
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.activityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"ActivityCell";

    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

#pragma mark - 事件处理

- (void)showFilter:(UIButton *)button {
    
    if (button.tag != 0 && button.tag != 1) {
        return;
    }
    
    BOOL hidden;
    if (button.tag == 0) {
        
        hidden = self.filterView.hidden;
        
        self.joinView.hidden = YES;
        self.filterView.hidden = !hidden;
    } else {
        
        hidden = self.joinView.hidden;
        
        self.filterView.hidden = YES;
        self.joinView.hidden = !hidden;
    }
    
    button.imageView.transform = CGAffineTransformMakeRotation(hidden ? -M_PI_2 : M_PI_2);
    if (hidden) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!keyWindow) {
            keyWindow = [UIApplication sharedApplication].windows.firstObject;
        }
        [keyWindow addSubview:self.tabBarShadowView];
        [self.tabBarShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.bottom.mas_equalTo(keyWindow);
            make.height.mas_equalTo(49);
        }];
    } else {
        [self.tabBarShadowView removeFromSuperview];
    }
}

#pragma mark - setter & getter

- (UIView *)headView {

    if (!_headView) {

        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *notificationImageView = [[UIImageView alloc] init];
        notificationImageView.image = [UIImage imageNamed:@"notification"];
        
        UIView *redDotView = [[UIView alloc] init];
        redDotView.backgroundColor = [UIColor redColor];
        redDotView.layer.cornerRadius = 4;
        redDotView.layer.masksToBounds = YES;
        
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.backgroundImage = [[UIImage alloc] init];
        searchBar.placeholder = @"搜索活动名称/活动AID";
        searchBar.returnKeyType = UIReturnKeyDone;
        searchBar.delegate = self;
        searchBar.subviews.firstObject.subviews[1].backgroundColor = [UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1.0f];
        
        UIButton *searchButton = [[UIButton alloc] init];
        searchButton.backgroundColor = [UIColor colorWithRed:228.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f];
        searchButton.layer.cornerRadius = 5;
        searchButton.layer.masksToBounds = YES;
        [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [searchButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        
        UIView *middleLineView = [[UIView alloc] init];
        middleLineView.backgroundColor = [UIColor lightGrayColor];
        
        UIButton *filterButton = [[UIButton alloc] init];
        [filterButton setTitle:@"活动筛选" forState:UIControlStateNormal];
        [filterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [filterButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [filterButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateHighlighted];
        [filterButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        filterButton.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        filterButton.tag = 0;
        // https://www.douban.com/note/318508127/
        [filterButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
        [filterButton setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, -70)];
        [filterButton addTarget:self action:@selector(showFilter:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *vLineView = [[UIView alloc] init];
        vLineView.backgroundColor = [UIColor lightGrayColor];
        
        UIButton *joinButton = [[UIButton alloc] init];
        [joinButton setTitle:@"活动参与" forState:UIControlStateNormal];
        [joinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [joinButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [joinButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateHighlighted];
        [joinButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        joinButton.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        joinButton.tag = 1;
        [joinButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
        [joinButton setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, -70)];
        [joinButton addTarget:self action:@selector(showFilter:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *bottomLineView = [[UIView alloc] init];
        bottomLineView.backgroundColor = [UIColor lightGrayColor];
        
        [_headView addSubview:notificationImageView];
        [_headView addSubview:redDotView];
        [_headView addSubview:searchBar];
        [_headView addSubview:searchButton];
        [_headView addSubview:middleLineView];
        [_headView addSubview:filterButton];
        [_headView addSubview:vLineView];
        [_headView addSubview:joinButton];
        [_headView addSubview:bottomLineView];
        
        [notificationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headView).mas_offset(10);
            make.centerY.mas_equalTo(searchBar);
            make.height.width.mas_equalTo(20);
        }];
        [redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(notificationImageView);
            make.height.width.mas_equalTo(8);
        }];
        [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headView);
            make.left.mas_equalTo(notificationImageView.mas_right).mas_offset(0);
        }];
        [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(searchBar);
            make.left.mas_equalTo(searchBar.mas_right).mas_offset(0);
            make.right.mas_equalTo(_headView).mas_offset(-10);
            make.width.mas_equalTo(50);
        }];
        [middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.mas_equalTo(_headView);
            make.bottom.mas_equalTo(searchBar);
            make.height.mas_equalTo(0.5);
        }];
        [filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(notificationImageView);
            make.top.mas_equalTo(middleLineView.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(_headView.mas_centerX).mas_offset(-10);
        }];
        [vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.top.bottom.mas_equalTo(filterButton);
            make.centerX.mas_equalTo(_headView);
        }];
        [joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(filterButton);
            make.left.mas_equalTo(_headView.mas_centerX).mas_offset(10);
            make.right.mas_equalTo(_headView).mas_offset(-10);
        }];
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.mas_equalTo(_headView);
            make.bottom.mas_equalTo(filterButton).mas_offset(10);
            make.height.mas_equalTo(0.5);
        }];
    }

    return _headView;
}

- (UIView *)filterView {
    
    if (!_filterView) {
        
        _filterView = [[UIView alloc] init];
        _filterView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        
    }
    
    return _filterView;
}

- (UIView *)tabBarShadowView {
    
    if (!_tabBarShadowView) {
        
        _tabBarShadowView = [[UIView alloc] init];
        _tabBarShadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    }
    
    return _tabBarShadowView;
}

- (UIView *)joinView {
    
    if (!_joinView) {
        
        _joinView = [[UIView alloc] init];
        _joinView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];

        NSArray *titleArray = @[@"全部活动", @"我发起的", @"我报名的", @"往届回顾"];
        UILabel *layoutLabel;
        for (int i=0; i<titleArray.count; i++) {
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.font = [UIFont systemFontOfSize:14.0f];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.text = [NSString stringWithFormat:@"     %@", [titleArray objectAtIndex:i]];
            titleLabel.backgroundColor = [UIColor whiteColor];
            
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor lightGrayColor];
            
            [_joinView addSubview:titleLabel];
            [_joinView addSubview:lineView];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(layoutLabel?layoutLabel.mas_bottom:_joinView);
                make.left.mas_equalTo(_joinView);
                make.right.mas_equalTo(_joinView);
                make.height.mas_equalTo(40);
            }];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(titleLabel);
                make.left.mas_equalTo(_joinView).offset(20);
                make.right.mas_equalTo(_joinView);
                make.height.mas_equalTo(0.5);
            }];
            
            layoutLabel = titleLabel;
        }

        layoutLabel = nil;
    }
    
    return _joinView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

@end
