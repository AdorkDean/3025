//
//  ProfileViewController.m
//  3025
//
//  Created by ld on 2017/3/27.
//
//

#import "ProfileViewController.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {

}

@property (nonatomic, copy) NSArray *menuArray;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ProfileViewController

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

#pragma mark - UIScrollViewDelegate

#pragma mark - UI

/**
 *  设定UI
 */
- (void)setupUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
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


#pragma mark - setter & getter

- (NSArray *)menuArray {
    
    if (!_menuArray) {
        
        _menuArray = @[
                       @"实名认证",
                       @"我的基本资料",
                       @"我的择偶标准",
                       @"免打扰设置",
                       @"我的真实性验证",
                       @"关于门当户对",
                       @"黑名单管理",
                       @"系统问题反馈与改进建议"
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
        posterImageView.layer.cornerRadius = 30;
        posterImageView.layer.masksToBounds = YES;
        posterImageView.contentMode = UIViewContentModeScaleToFill;
        [posterImageView sd_setImageWithURL:[NSURL URLWithString:self.me.poster] placeholderImage:[UIImage imageNamed:@"poster"]];
        
        // ID
        UILabel *idLabel = [[UILabel alloc] init];
        idLabel.textAlignment = NSTextAlignmentLeft;
        idLabel.numberOfLines = 1;
        idLabel.textColor = kNavigationTitleColor;
        idLabel.font = [UIFont systemFontOfSize:14.0f];
        idLabel.text = [NSString stringWithFormat:@"ID: %@", self.me.userid];
        
        // 昵称
        UILabel *nicknameLabel = [[UILabel alloc] init];
        nicknameLabel.textAlignment = NSTextAlignmentLeft;
        nicknameLabel.numberOfLines = 1;
        nicknameLabel.textColor = kNavigationTitleColor;
        nicknameLabel.font = [UIFont systemFontOfSize:14.0f];
        nicknameLabel.text = [NSString stringWithFormat:@"%@", self.me.nickname];
        
        // 职业
        UILabel *careerLabel = [[UILabel alloc] init];
        careerLabel.textAlignment = NSTextAlignmentLeft;
        careerLabel.numberOfLines = 1;
        careerLabel.textColor = kNavigationTitleColor;
        careerLabel.font = [UIFont systemFontOfSize:14.0f];
        careerLabel.text = [NSString stringWithFormat:@"职业: %@ %@", self.me.unitNature, self.me.position];
        
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
    }
    
    return _headView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

@end
