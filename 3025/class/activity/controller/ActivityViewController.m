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

@property (nonatomic, strong) UIWindow *keyWindow;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *filterView;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIView *joinView;
@property (nonatomic, strong) UIButton *joinButton;
@property (nonatomic, strong) UIImageView *joinImageView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJRefreshNormalHeader *refreshNormalHeader;

@property (nonatomic, copy) NSArray *activityArray;

@property (nonatomic, strong) MASConstraint *filterTopConstraint;
@property (nonatomic, strong) MASConstraint *filterBottomConstraint;
@property (nonatomic, strong) MASConstraint *joinTopConstraint;
@property (nonatomic, strong) MASConstraint *joinBottomConstraint;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:kBackgroundColor];
    
    [self setupNavigtion];
    [self setupUI];
    [self loadData];
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
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.filterTopConstraint = make.top.mas_equalTo(self.headView.mas_bottom);
        make.left.width.mas_equalTo(self.view);
        make.height.mas_equalTo(200);
        self.filterBottomConstraint = make.bottom.mas_equalTo(self.headView.mas_bottom);
    }];
    [self.joinView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.joinTopConstraint = make.top.mas_equalTo(self.headView.mas_bottom);
        make.left.width.mas_equalTo(self.view);
        make.height.mas_equalTo(160);
        self.joinBottomConstraint = make.bottom.mas_equalTo(self.headView.mas_bottom);
    }];
    
    [self.view bringSubviewToFront:self.headView];
    
    self.filterView.hidden = YES;
    self.joinView.hidden = YES;
    
    [self.filterTopConstraint deactivate];
    [self.filterBottomConstraint activate];
    
    [self.joinTopConstraint deactivate];
    [self.joinBottomConstraint activate];
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
    
    // 自定义导航栏右侧 - 发起活动
    UIButton *createButton = [[UIButton alloc] init];
    createButton.backgroundColor = kKeyColor;
    createButton.layer.cornerRadius = 5;
    createButton.frame = CGRectMake(7, 0, 75, 30);
    [createButton setTitle:@"发起活动" forState:UIControlStateNormal];
    [createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    // 自定义导航栏右侧
    UIView *rightCustomView = [[UIView alloc] init];
    rightCustomView.frame = CGRectMake(0, 0, 75, 30);
    [rightCustomView addSubview:createButton];
    
    // 导航栏右侧
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightCustomView];
    
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
    }
    [cell setupData:self.activityArray[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"ActivityCell";
    static ActivityCell *cell;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        cell = [[ActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    });
    
    [cell setupData:self.activityArray[indexPath.row]];
    
    return [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
}

#pragma mark - 事件处理

- (void)showFilter:(UIButton *)button {
    
    [self.view endEditing:YES];
    
    if (button.tag == 0) {
        
        if (!self.joinView.hidden) {

            self.joinView.hidden = YES;
            
            [self.joinTopConstraint deactivate];
            [self.joinBottomConstraint activate];
            
            self.joinButton.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
            
            [self.shadowView removeFromSuperview];
        }
        if (self.filterView.hidden) {
            
            self.filterView.hidden = NO;
            
            self.shadowView.frame = CGRectMake(0, 148, kScreenWidth, kScreenHeight - 148);
            self.shadowView.tag = 0;
            [self.shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewTapped:)]];
            [self.keyWindow addSubview:self.shadowView];
            
            [self.filterTopConstraint activate];
            [self.filterBottomConstraint deactivate];
            
            [UIView animateWithDuration:0.25 animations:^{
                
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
                
                self.shadowView.frame = CGRectMake(0, 348, kScreenWidth, kScreenHeight - 348);
                self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            } completion:^(BOOL finished) {
                if (finished) {
                    
                    button.imageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
                }
            }];
        } else {
            
            [self.filterTopConstraint deactivate];
            [self.filterBottomConstraint activate];
            
            [self.view bringSubviewToFront:self.headView];
            
            [UIView animateWithDuration:0.25 animations:^{
                
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
                
                self.shadowView.frame = CGRectMake(0, 148, kScreenWidth, kScreenHeight - 148);
                self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
            } completion:^(BOOL finished) {
                if (finished) {
                    
                    self.filterView.hidden = YES;
                    self.shadowView.gestureRecognizers = [NSArray array];
                    [self.shadowView removeFromSuperview];
                    
                    button.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
                }
            }];
        }
    } else if (button.tag == 1) {
        
        if (!self.filterView.hidden) {

            self.filterView.hidden = YES;
            
            [self.filterTopConstraint deactivate];
            [self.filterBottomConstraint activate];
            
            [self.shadowView removeFromSuperview];
            
            self.filterButton.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
        if (self.joinView.hidden) {
            
            self.joinView.hidden = NO;
            
            self.shadowView.frame = CGRectMake(0, 148, kScreenWidth, kScreenHeight - 148);
            self.shadowView.tag = 1;
            [self.shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewTapped:)]];
            [self.keyWindow addSubview:self.shadowView];
            
            [self.joinTopConstraint activate];
            [self.joinBottomConstraint deactivate];
            
            [UIView animateWithDuration:0.25 animations:^{

                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
                
                self.shadowView.frame = CGRectMake(0, 308, kScreenWidth, kScreenHeight - 308);
                self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            } completion:^(BOOL finished) {
                if (finished) {
                    
                    button.imageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
                }
            }];
        } else {
            
            [self.joinTopConstraint deactivate];
            [self.joinBottomConstraint activate];
            
            [self.view bringSubviewToFront:self.headView];

            [UIView animateWithDuration:0.25 animations:^{

                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
                
                self.shadowView.frame = CGRectMake(0, 148, kScreenWidth, kScreenHeight - 148);
                self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
            } completion:^(BOOL finished) {
                if (finished) {
                    
                    self.joinView.hidden = YES;
                    self.shadowView.gestureRecognizers = [NSArray array];
                    [self.shadowView removeFromSuperview];
                    
                    button.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
                }
            }];
        }
    }
}

- (void)shadowViewTapped:(UITapGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.view.tag == 0) {
        
        [self showFilter:self.filterButton];
    } else if (gestureRecognizer.view.tag == 1) {
        
        [self showFilter:self.joinButton];
    }
}

- (void)joinLabelTapped:(UITapGestureRecognizer *)gestureRecognizer {
    
    UILabel *titleLabel = (UILabel *)gestureRecognizer.view;

    self.joinImageView.hidden = NO;
    
    [self.joinImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel);
        make.right.mas_equalTo(_joinView).mas_offset(-20);
    }];
}

#pragma mark - setter & getter

- (UIWindow *)keyWindow {
    
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!_keyWindow) {
        
        _keyWindow = [UIApplication sharedApplication].windows.firstObject;
    }
    
    return _keyWindow;
}

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
        self.filterButton = filterButton;
        
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
        self.joinButton = joinButton;
        
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
        _filterView.backgroundColor = [UIColor whiteColor];

        NSArray *titleArray = @[@"活动地址", @"活动日期", @"活动类型", @"TA已报名"];
        UILabel *layoutLabel;
        for (int i=0; i<titleArray.count; i++) {
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.font = [UIFont systemFontOfSize:14.0f];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.text = [NSString stringWithFormat:@"%@", [titleArray objectAtIndex:i]];
            titleLabel.backgroundColor = [UIColor whiteColor];
            
            UITextField *textField = [[UITextField alloc] init];
            textField.layer.cornerRadius = 5;
            textField.layer.borderWidth = 0.5;
            textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
            textField.layer.masksToBounds = YES;
            textField.textColor = [UIColor blackColor];
            textField.font = [UIFont systemFontOfSize:14.0f];
            textField.placeholder = [NSString stringWithFormat:@"  请选择"];
            
            UIView *hLineView;
            UITextField *endTextField;
            if (i == 1) {
                
                hLineView = [[UIView alloc] init];
                hLineView.backgroundColor = [UIColor lightGrayColor];
                
                endTextField = [[UITextField alloc] init];
                endTextField.layer.cornerRadius = 5;
                endTextField.layer.borderWidth = 0.5;
                endTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
                endTextField.layer.masksToBounds = YES;
                endTextField.textColor = [UIColor blackColor];
                endTextField.font = [UIFont systemFontOfSize:14.0f];
                endTextField.placeholder = [NSString stringWithFormat:@"  请选择"];
            }
            
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor lightGrayColor];
            
            [_filterView addSubview:titleLabel];
            [_filterView addSubview:textField];
            if (i == 1) {
                [_filterView addSubview:hLineView];
                [_filterView addSubview:endTextField];
            }
            [_filterView addSubview:lineView];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(layoutLabel?layoutLabel.mas_bottom:_filterView);
                make.left.mas_equalTo(_filterView).mas_offset(20);
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(40);
            }];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(titleLabel);
                make.left.mas_equalTo(titleLabel.mas_right).mas_offset(20);
                make.height.mas_equalTo(30);
                if (i == 1) {
                    make.width.mas_equalTo((kScreenWidth-150)/2);
                } else {
                    make.right.mas_equalTo(_filterView).mas_offset(-20);
                }
            }];
            if (i == 1) {
                [hLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(titleLabel);
                    make.left.mas_equalTo(textField.mas_right).mas_offset(10);
                    make.height.mas_equalTo(1);
                    make.width.mas_equalTo(10);
                }];
                [endTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(titleLabel);
                    make.left.mas_equalTo(hLineView.mas_right).mas_offset(10);
                    make.right.mas_equalTo(_filterView).mas_offset(-20);
                    make.height.width.mas_equalTo(textField);
                }];
            }
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(titleLabel).mas_offset((i == (titleArray.count - 1)) ? 0.5 : 0);
                make.left.mas_equalTo(titleLabel);
                make.right.mas_equalTo(_filterView);
                make.height.mas_equalTo(0.5);
            }];
            
            layoutLabel = titleLabel;
        }
        
        UIButton *cancelButton = [[UIButton alloc] init];
        cancelButton.layer.borderWidth = 0.5;
        cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cancelButton.layer.masksToBounds = YES;
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];

        UIButton *submitButton = [[UIButton alloc] init];
        submitButton.layer.borderWidth = 0.5;
        submitButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        submitButton.layer.masksToBounds = YES;
        submitButton.backgroundColor = [UIColor colorWithRed:228.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f];
        [submitButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [submitButton setTitle:@"确定" forState:UIControlStateNormal];
        
        [_filterView addSubview:cancelButton];
        [_filterView addSubview:submitButton];
        
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(layoutLabel.mas_bottom);
            make.bottom.mas_equalTo(_filterView);
            make.left.mas_equalTo(_filterView);
            make.right.mas_equalTo(_filterView.mas_centerX);
        }];
        [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(cancelButton);
            make.left.mas_equalTo(cancelButton.mas_right);
            make.right.mas_equalTo(_filterView);
        }];
    }
    
    return _filterView;
}

- (UIView *)shadowView {
    
    if (!_shadowView) {
        
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
    }
    
    return _shadowView;
}

- (UIView *)joinView {
    
    if (!_joinView) {
        
        _joinView = [[UIView alloc] init];
        _joinView.backgroundColor = [UIColor whiteColor];
        
        NSArray *titleArray = @[@"全部活动", @"我发起的", @"我报名的", @"往届回顾"];
        UILabel *layoutLabel;
        for (int i=0; i<titleArray.count; i++) {
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.font = [UIFont systemFontOfSize:14.0f];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.text = [NSString stringWithFormat:@"     %@", [titleArray objectAtIndex:i]];
            titleLabel.backgroundColor = [UIColor whiteColor];
            titleLabel.tag = i;
            titleLabel.userInteractionEnabled = YES;
            [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(joinLabelTapped:)]];
            
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
                make.bottom.mas_equalTo(titleLabel).mas_offset((i == (titleArray.count - 1)) ? 0.25 : 0);
                make.left.mas_equalTo(_joinView).offset(20);
                make.right.mas_equalTo(_joinView);
                make.height.mas_equalTo(0.5);
            }];
            
            layoutLabel = titleLabel;
        }
        
        UIImageView *joinImageView = [[UIImageView alloc] init];
        joinImageView.image = [UIImage imageNamed:@"checked"];
        joinImageView.hidden = YES;
        self.joinImageView = joinImageView;
        
        [_joinView addSubview:joinImageView];
        
        [joinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(layoutLabel);
            make.right.mas_equalTo(_joinView).mas_offset(-20);
        }];
    }
    
    return _joinView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.mj_header = self.refreshNormalHeader;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

- (MJRefreshNormalHeader *)refreshNormalHeader {
    
    if (!_refreshNormalHeader) {
        
        _refreshNormalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

            [self loadData];
        }];
    }
    
    return _refreshNormalHeader;
}

#pragma mark - 数据处理

- (void)loadData {
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@", kDomain, @"activity/filter.html"];
    NSDictionary *parameters = @{
                                 @"conditionUserid": self.me.userid,
                                 @"myUserid": self.me.userid
                                 };
    
    AFHTTPSessionManager *httpSessionManager = [AFHTTPSessionManager manager];
    httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [httpSessionManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"*** %@ ***", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *json = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        self.activityArray = [NSArray mj_objectArrayWithKeyValuesArray:json];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
        NSLog(@"*** %@ ***", error);
    }];
}

@end
