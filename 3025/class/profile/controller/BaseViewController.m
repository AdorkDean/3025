//
//  BaseViewController.m
//  3025
//
//  Created by WangErdong on 2017/6/4.
//
//

#import "BaseViewController.h"
#import "SortCell.h"

@interface BaseViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, SortCellDelegate>

@property (nonatomic, copy) NSArray *titleList;
@property (nonatomic, copy) NSArray *pickerList;
@property (nonatomic, copy) NSArray *provinceList;
@property (nonatomic, copy) NSArray *cityList;
@property (nonatomic, assign) NSUInteger currentRow;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UILabel *inputTitleLabel;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigtion];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 设定UI

- (void)setupNavigtion {
    
    // 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = kNavigationTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"基本资料";
    titleLabel.frame = CGRectMake(0, 7, 50, 30);
    
    // 导航栏右侧菜单
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(0, 7, 60, 30);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:kNavigationTitleColor forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    // 导航栏标题
    self.navigationItem.titleView = titleLabel;
    
    // 导航栏右侧菜单
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)setupUI {
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:kBackgroundColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = kBackgroundColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.borderColor = kLineColor.CGColor;
    bottomView.layer.borderWidth = 0.5;
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = kButtonColor;
    button.layer.cornerRadius = 5;
    [button setTitle:@"查询" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sort:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tableView];
    [self.view addSubview:bottomView];
    [self.view addSubview:button];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(bottomView.mas_top);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(-0.5);
        make.right.mas_equalTo(self.view).mas_offset(0.5);
        make.bottom.mas_equalTo(self.view).mas_offset(0.5);
        make.height.mas_equalTo(45.5);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(5);
        make.right.mas_equalTo(self.view).mas_offset(-5);
        make.bottom.mas_equalTo(self.view).mas_offset(-5);
        make.height.mas_equalTo(35);
    }];
    
    self.tableView = tableView;
    
    self.shadeView.hidden = NO;
    self.inputView.hidden = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleList.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = kBackgroundColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = @"请至少选择一项择偶条件";
    
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 0));
    }];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.titleList[indexPath.row];
    static NSString *cellID = @"SortCell";
    
    SortCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[SortCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell setMulti:(indexPath.row == 1)];
    [cell setIndexPath:indexPath];
    [cell setDelegate:self];
    [cell setupData:dict];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    if (self.currentRow == 3 || self.currentRow == 4) {
        
        return 2;
    }
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (self.currentRow == 3 || self.currentRow == 4) {
        if (component == 0) {
            
            return self.provinceList.count;
        } else if (component == 1) {
            
            NSInteger selectedRow = [pickerView selectedRowInComponent:0];
            return [self.cityList[selectedRow] count];
        }
    }
    
    return self.pickerList.count;
}

#pragma mark - UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (self.currentRow == 3 || self.currentRow == 4) {
        if (component == 0) {
            
            return self.provinceList[row];
        } else if (component == 1) {
            
            NSInteger selectedRow = [pickerView selectedRowInComponent:0];
            return self.cityList[selectedRow][row];
        }
    }
    
    return self.pickerList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (self.currentRow == 3 || self.currentRow == 4) {
        if (component == 0) {
            
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:NO];
        }
    }
}

#pragma mark - SortCellDelegate

- (void)input:(NSIndexPath *)indexPath multi:(BOOL)multi {
    
    self.currentRow = (multi ? (1000 + indexPath.row) : indexPath.row);
    
    NSDictionary *dict = self.titleList[indexPath.row];
    self.inputTitleLabel.text = dict[@"title"];
    
    if (self.currentRow == 3 || self.currentRow == 4) {
        
        NSInteger selectedRow = 0;
        NSInteger selectedRow2 = 0;
        
        NSString *selectedTitle = dict[@"value"];
        NSString *province = selectedTitle;
        NSString *city = selectedTitle;
        
        if ([selectedTitle containsString:@"-"]) {
            
            NSArray *arr = [selectedTitle componentsSeparatedByString:@"-"];
            if (arr.count == 2) {
                
                province = arr[0];
                city = arr[1];
            }
        }
        
        selectedRow = [self.provinceList indexOfObject:province];
        selectedRow2 = [self.cityList[selectedRow] indexOfObject:city];
        if (selectedRow < 0 || selectedRow >= self.provinceList.count) {
            selectedRow = 0;
        }
        if (selectedRow2 < 0 || selectedRow2 >= [self.cityList[selectedRow] count]) {
            selectedRow2 = 0;
        }
        
        [self.pickerView reloadAllComponents];
        [self.pickerView reloadComponent:0];
        [self.pickerView selectRow:selectedRow inComponent:0 animated:NO];
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:selectedRow2 inComponent:1 animated:NO];
    } else {
        
        [self setupPickerList:self.currentRow];
        
        NSString *selectedTitle = multi ? dict[@"value2"] : dict[@"value"];
        NSInteger selectedRow = [self.pickerList indexOfObject:selectedTitle];
        if (selectedRow < 0 || selectedRow >= self.pickerList.count) {
            selectedRow = 0;
        }
        
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:selectedRow inComponent:0 animated:NO];
    }
    
    [self.view bringSubviewToFront:self.shadeView];
    [self.shadeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [self.view bringSubviewToFront:self.inputView];
    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom).mas_offset(-246);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.shadeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - getter and setter

- (NSArray *)titleList {
    
    if (!_titleList) {
        
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSort];
        if (arr && [arr isKindOfClass:[NSArray class]]) {
            
            _titleList = arr;
        } else {
            
            _titleList = @[
                           @{ @"title": @"性别", @"value": @"不限" },
                           @{ @"title": @"年龄", @"value": @"不限", @"value2": @"不限"},
                           @{ @"title": @"身高", @"value": @"不限" },
                           @{ @"title": @"户籍", @"value": @"不限" },
                           @{ @"title": @"常住城市", @"value": @"不限" },
                           @{ @"title": @"最高学历", @"value": @"不限" },
                           @{ @"title": @"月收入", @"value": @"不限" },
                           @{ @"title": @"单位性质", @"value": @"不限" },
                           @{ @"title": @"婚姻状态", @"value": @"不限" },
                           @{ @"title": @"婚房", @"value": @"不限" }
                           ];
        }
    }
    
    return _titleList;
}

- (NSArray *)provinceList {
    
    if (!_provinceList) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pcd" ofType:@"plist"];
        NSDictionary *pcdDict = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        _provinceList = [pcdDict objectForKey:@"province"];
    }
    
    return _provinceList;
}

- (NSArray *)cityList {
    
    if (!_cityList) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pcd" ofType:@"plist"];
        NSDictionary *pcdDict = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        _cityList = [pcdDict objectForKey:@"city"];
    }
    
    return _cityList;
}


- (void)setupPickerList:(NSUInteger)type {
    
    NSMutableArray *mArr = [NSMutableArray array];
    [mArr addObject:@"不限"];
    
    if (type == 0) { // 性别
        
        [mArr addObject:@"男"];
        [mArr addObject:@"女"];
    } else if (type == 1) { // 年龄
        
        NSDictionary *dict = self.titleList[1];
        NSString *value = dict[@"value2"];
        int ageTo = 80;
        if (![value isEqualToString:@"不限"]) {
            ageTo = [value intValue];
        }
        
        for (int i=20; i<=ageTo; i++) {
            [mArr addObject:[NSString stringWithFormat:@"%d岁及以上", i]];
        }
    } else if (type == 1001) { // 年龄
        
        NSDictionary *dict = self.titleList[1];
        NSString *value = dict[@"value"];
        int ageFrom = 20;
        if (![value isEqualToString:@"不限"]) {
            ageFrom = [value intValue];
        }
        
        for (int i=ageFrom; i<=80; i++) {
            [mArr addObject:[NSString stringWithFormat:@"%d岁及以下", i]];
        }
    } else if (type == 2) { // 身高
        
        for (int i=140; i<=200; i++) {
            [mArr addObject:[NSString stringWithFormat:@"%dcm及以上", i]];
        }
    } else if (type == 3) { // 户籍
        
    } else if (type == 4) { // 常住城市
        
    } else if (type == 5) { // 最高学历
        
        for (NSString *item in kEducation) {
            [mArr addObject:[NSString stringWithFormat:@"%@及以上", item]];
        }
    } else if (type == 6) { // 月收入
        
        for (int i=3; i<=50; i++) {
            [mArr addObject:[NSString stringWithFormat:@"%d及以上", i*1000]];
        }
    } else if (type == 7) { // 单位性质
        
        [mArr addObjectsFromArray:kUnitNature];
    } else if (type == 8) { // 婚姻状态
        
        [mArr addObjectsFromArray:kMaritalStatus];
    } else if (type == 9) { // 婚房
        
        [mArr addObjectsFromArray:kHouseStatus];
    }
    
    self.pickerList = [NSArray arrayWithArray:mArr];
}

- (UIView *)shadeView {
    
    if (!_shadeView) {
        
        _shadeView = [[UIView alloc] init];
        _shadeView.backgroundColor = [UIColor clearColor];
        [_shadeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelInput:)]];
        
        [self.view addSubview:_shadeView];
        [self.view sendSubviewToBack:_shadeView];
        
        [_shadeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    
    return _shadeView;
}

- (UIView *)inputView {
    
    if (!_inputView) {
        
        _inputView = [[UIView alloc] init];
        _inputView.backgroundColor = kButtonColor;
        
        UIButton *cancelButton = [[UIButton alloc] init];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelInput:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleLabel.text = @"";
        
        UIButton *okButton = [[UIButton alloc] init];
        [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [okButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [okButton setTitle:@"确定" forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(submitInput:) forControlEvents:UIControlEventTouchUpInside];
        
        [_inputView addSubview:cancelButton];
        [_inputView addSubview:titleLabel];
        [_inputView addSubview:okButton];
        [_inputView addSubview:self.pickerView];
        
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_inputView);
            make.left.mas_equalTo(_inputView);
            make.width.mas_equalTo(57);
            make.height.mas_equalTo(30);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.mas_equalTo(cancelButton);
            make.centerX.mas_equalTo(_inputView);
        }];
        [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.width.mas_equalTo(cancelButton);
            make.right.mas_equalTo(_inputView);
        }];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.width.mas_equalTo(_inputView);
            make.height.mas_equalTo(216);
        }];
        
        [self.view addSubview:_inputView];
        [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_bottom).mas_offset(0);
            make.left.width.mas_equalTo(self.view);
            make.height.mas_equalTo(246);
        }];
        
        self.inputTitleLabel = titleLabel;
    }
    
    return _inputView;
}

- (UIPickerView *)pickerView {
    
    if (!_pickerView) {
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = kBackgroundColor;
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    
    return _pickerView;
}

#pragma mark - action

- (void)back:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sort:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelInput:(UITapGestureRecognizer *)gestureRecognizer {
    
    [self.view endEditing:YES];
    
    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom).mas_offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.shadeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [self.view sendSubviewToBack:self.shadeView];
    }];
}

- (void)submitInput:(UIButton *)button {
    
    NSInteger index = (self.currentRow == 1001 ? 1 : self.currentRow);
    NSString *selectedTitle = @"";
    
    if (self.currentRow == 3 || self.currentRow == 4) {
        
        NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
        NSInteger selectedRow2 = [self.pickerView selectedRowInComponent:1];
        
        NSString *province = self.provinceList[selectedRow];
        NSString *city = self.cityList[selectedRow][selectedRow2];
        
        if ([province isEqualToString:city]) {
            
            selectedTitle = [NSString stringWithFormat:@"%@", province];
        } else {
            
            selectedTitle = [NSString stringWithFormat:@"%@-%@", province, city];
        }
    } else {
        
        NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
        selectedTitle = self.pickerList[selectedRow];
    }
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:self.titleList[index]];
    [mDict setObject:selectedTitle forKey:(self.currentRow == 1001 ? @"value2" : @"value")];
    
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.titleList];
    [mArr replaceObjectAtIndex:index withObject:[NSDictionary dictionaryWithDictionary:mDict]];
    
    self.titleList = [NSArray arrayWithArray:mArr];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self cancelInput:self.shadeView.gestureRecognizers.firstObject];
}

@end
