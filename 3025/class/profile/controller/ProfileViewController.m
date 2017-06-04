//
//  ProfileViewController.m
//  3025
//
//  Created by ld on 2017/3/27.
//
//

#import "ProfileViewController.h"
#import "WXApi.h"
#import "BaseViewController.h"
#import "MateViewController.h"
#import "TruthViewController.h"
#import "MatchViewController.h"
#import "BlockViewController.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {

}

@property (nonatomic, copy) NSArray *menuArray;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *careerLabel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:kBackgroundColor];
    
    [self setupNavigtion];
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxAuthNotification:) name:kWXAuthNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = self.menuArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.me.userid) {
        [self login:nil];
    } else {
        if (indexPath.row == 4) {
            
            BlockViewController *vc = [[BlockViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 3) {
            
            MatchViewController *vc = [[MatchViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
            
            TruthViewController *vc = [[TruthViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            
            MateViewController *vc = [[MateViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 0) {
            
            BaseViewController *vc = [[BaseViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y < 0) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
        }
    }
}

#pragma mark - UI

/**
 *  设定UI
 */
- (void)setupUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];

    self.headView.frame = CGRectMake(0, 0, kScreenWidth, [self.headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height);
    [self.tableView setTableHeaderView:self.headView];
}

- (void)setupNavigtion {
    
    // 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = kNavigationTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"设置";
    titleLabel.frame = CGRectMake(0, 7, 50, 30);
    
    // 导航栏右侧
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    
    UIButton *previewButton = [[UIButton alloc] init];
    previewButton.frame = CGRectMake(5, 0, 60, 30);
    [previewButton setTitle:@"预览资料" forState:UIControlStateNormal];
    [previewButton setTitleColor:kNavigationTitleColor forState:UIControlStateNormal];
    [previewButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    [customView addSubview:previewButton];
    
    // 导航栏右侧
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark - 事件处理

- (void)login:(UITapGestureRecognizer *)gestureRecognizer {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    if (self.me.userid) {
        
        alertController.title = @"退出帐号";
        alertController.message = @"确定要退出账号吗？";
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];

            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginUser];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self refreshHeadView];
        }]];
    } else {
        
        alertController.title = @"登录帐号";
        alertController.message = @"目前仅支持微信授权登陆";
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self wxLogin];
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)wxLogin {
    
    SendAuthReq *authReq =[[SendAuthReq alloc] init];
    authReq.scope = @"snsapi_userinfo" ;
    authReq.state = @"123" ;
    
    [WXApi sendReq:authReq];
}

- (void)wxAuthNotification:(NSNotification *)notification {
    
    NSDictionary *dict = notification.userInfo;
    self.me = [UserModel mj_objectWithKeyValues:dict];
    
    [self refreshHeadView];
}

- (void)refreshHeadView {
    
    if (self.me.userid) {
        [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:self.me.poster] placeholderImage:[UIImage imageNamed:@"poster"]];
        self.idLabel.text = [NSString stringWithFormat:@"ID: %@", self.me.userid];
        self.nicknameLabel.text = [NSString stringWithFormat:@"%@", self.me.nickname];
        self.careerLabel.text = [NSString stringWithFormat:@"职业: %@ %@", self.me.unitNature, self.me.position];
    } else {
        [self.posterImageView setImage:[UIImage imageNamed:@"poster"]];
        self.idLabel.text = @"";
        self.nicknameLabel.text = @"点击登录";
        self.nicknameLabel.userInteractionEnabled = YES;
        self.careerLabel.text = @"";
    }
}

#pragma mark - setter & getter

- (NSArray *)menuArray {
    
    if (!_menuArray) {
        
        _menuArray = @[
                       @"我的基本资料",
                       @"我的择偶条件",
                       @"我的真实性验证",
                       @"关于门当户对",
                       @"黑名单管理"
                       ];
    }
    
    return _menuArray;
}

- (UIView *)headView {
    
    if (!_headView) {
        
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        backgroundImageView.image = [UIImage imageNamed:@"header"];
        
        UIImageView *posterImageView = [[UIImageView alloc] init];
        posterImageView.layer.borderColor = kKeyColor.CGColor;
        posterImageView.layer.borderWidth = 1;
        posterImageView.layer.cornerRadius = 30;
        posterImageView.layer.masksToBounds = YES;
        posterImageView.contentMode = UIViewContentModeScaleToFill;
        self.posterImageView = posterImageView;
        
        // ID
        UILabel *idLabel = [[UILabel alloc] init];
        idLabel.textAlignment = NSTextAlignmentLeft;
        idLabel.numberOfLines = 1;
        idLabel.textColor = kNavigationTitleColor;
        idLabel.font = [UIFont systemFontOfSize:14.0f];
        self.idLabel = idLabel;
        
        // 昵称
        UILabel *nicknameLabel = [[UILabel alloc] init];
        nicknameLabel.textAlignment = NSTextAlignmentLeft;
        nicknameLabel.numberOfLines = 1;
        nicknameLabel.textColor = kNavigationTitleColor;
        nicknameLabel.font = [UIFont systemFontOfSize:14.0f];
        nicknameLabel.userInteractionEnabled = YES;
        [nicknameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login:)]];
        self.nicknameLabel = nicknameLabel;
        
        // 职业
        UILabel *careerLabel = [[UILabel alloc] init];
        careerLabel.textAlignment = NSTextAlignmentLeft;
        careerLabel.numberOfLines = 1;
        careerLabel.textColor = kNavigationTitleColor;
        careerLabel.font = [UIFont systemFontOfSize:14.0f];
        self.careerLabel = careerLabel;
        
        [_headView addSubview:backgroundImageView];
        [_headView addSubview:posterImageView];
        [_headView addSubview:idLabel];
        [_headView addSubview:nicknameLabel];
        [_headView addSubview:careerLabel];
        
        [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_headView);
        }];
        [posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headView).offset(10);
            make.centerX.mas_equalTo(_headView);
            make.height.width.mas_equalTo(60);
        }];
        [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headView).offset(10);
            make.right.mas_equalTo(_headView).offset(-15);
        }];
        [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(posterImageView.mas_bottom).offset(10);
            make.centerX.mas_equalTo(_headView);
        }];
        [careerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nicknameLabel.mas_bottom).offset(0);
            make.centerX.mas_equalTo(_headView);
            make.bottom.mas_equalTo(_headView).offset(-10);
        }];
        
        [self refreshHeadView];
    }
    
    return _headView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

@end
