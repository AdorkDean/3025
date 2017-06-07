//
//  MateViewController.m
//  3025
//
//  Created by WangErdong on 2017/6/4.
//
//

#import "MateViewController.h"
#import "SortCell.h"

@interface MateViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, SortCellDelegate, UITextViewDelegate>

@property (nonatomic, copy) NSArray *titleList;
@property (nonatomic, copy) NSArray *pickerList;
@property (nonatomic, copy) NSArray *provinceList;
@property (nonatomic, copy) NSArray *cityList;
@property (nonatomic, assign) NSUInteger currentRow;
@property (nonatomic, copy) NSString *conditionid;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UILabel *inputTitleLabel;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation MateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigtion];
    [self setupUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 设定UI

- (void)setupNavigtion {
    
    // 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = kNavigationTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"择偶条件";
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
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit:)]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = kBackgroundColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = self.footerView;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.borderColor = kLineColor.CGColor;
    bottomView.layer.borderWidth = 0.5;
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = kButtonColor;
    button.layer.cornerRadius = 5;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tableView];
    [self.view addSubview:bottomView];
    [self.view addSubview:button];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
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

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    return YES;
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

- (UIView *)footerView {

    if (!_footerView) {
        
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = kBackgroundColor;
        _footerView.frame = CGRectMake(0, 0, kScreenWidth, 219);
        
        // 添加标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"补充说明：";
        
        // 内容输入框
        UITextView *textView = [[UITextView alloc] init];
        textView.font = [UIFont systemFontOfSize:16.0f];
        textView.textColor = [UIColor blackColor];
        textView.layer.borderColor = kLineColor.CGColor;
        textView.layer.borderWidth = 1.0;
        textView.delegate = self;
        
        [_footerView addSubview:titleLabel];
        [_footerView addSubview:textView];
        
        [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_footerView).mas_offset(15);
            make.top.mas_equalTo(_footerView);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(kScreenWidth-15);
        }];
        [textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel);
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth-30);
            make.height.mas_equalTo(120);
        }];
        
        self.textView = textView;
    }

    return _footerView;
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

- (void)endEdit:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    [self.view endEditing:YES];
}

- (void)submit:(UIButton *)button {
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    [activityIndicatorView startAnimating];
    
    // 筛选条件
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/save.html"];
    NSDictionary *parameterDict = [self saveParameters];
    
    //获取网络数据
    [HttpUtil query:url parameter:parameterDict success:^(id responseObject) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"*** success %@ ***", responseDict);
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
        
        [SVProgressHUD showImage:nil status:@"提交成功"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.5];
    } failure:^(NSError *error) {
        
        NSLog(@"*** failure %@ ***", error.description);
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
        
        [SVProgressHUD showImage:nil status:@"提交失败"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.5];
    }];
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

- (void)keyboardWillShow:(NSNotification *)notification {
    
    float duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *aValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [aValue CGRectValue];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide).mas_offset(-frame.size.height);
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).mas_offset(-frame.size.height);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    float duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
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

#pragma mark - 数据处理

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
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
    NSDictionary *parameterDict = @{ @"sql": [self sql] };
    
    //获取网络数据
    [HttpUtil query:url parameter:parameterDict success:^(id responseObject) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = responseDict[@"list"];
        
        if (array.count == 1) {
                
            NSDictionary *dict = [array firstObject];
            
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.titleList];
            NSMutableDictionary *mDict;
            
            NSString *sex = dict[@"sex"];
            if (![sex isEqualToString:@"0"]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[0]];
                [mDict setObject:sex forKey:@"value"];
                
                [mArr replaceObjectAtIndex:0 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *ageFrom = dict[@"ageFrom"];
            if (![ageFrom isEqualToString:@"0"]) {
                
                NSString *nowYear = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyy"];
                NSUInteger diff = nowYear.integerValue - ageFrom.integerValue;
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[1]];;
                [mDict setObject:[NSString stringWithFormat:@"%ld岁及以下", diff] forKey:@"value2"];
                
                [mArr replaceObjectAtIndex:1 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *ageTo = dict[@"ageTo"];
            if (![ageTo isEqualToString:@"0"]) {
                
                NSString *nowYear = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyy"];
                NSUInteger diff = nowYear.integerValue - ageTo.integerValue;
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[1]];;
                [mDict setObject:[NSString stringWithFormat:@"%ld岁及以上", diff] forKey:@"value"];
                
                [mArr replaceObjectAtIndex:1 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *heightFrom = dict[@"heightFrom"];
            if (![heightFrom isEqualToString:@"0"]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[2]];;
                [mDict setObject:[NSString stringWithFormat:@"%@cm及以上", heightFrom] forKey:@"value"];
                
                [mArr replaceObjectAtIndex:2 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *domicileprovince = dict[@"domicileprovince"];
            if (![domicileprovince isEqualToString:@"不限"]) {
                
                NSString *domicilecity = dict[@"domicilecity"];
                
                if ([domicilecity isEqualToString:domicileprovince]) {
                    
                    mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[3]];;
                    [mDict setObject:[NSString stringWithFormat:@"%@市", domicileprovince] forKey:@"value"];
                } else {
                    
                    mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[3]];;
                    [mDict setObject:[NSString stringWithFormat:@"%@省-%@市", domicileprovince, domicilecity] forKey:@"value"];
                }
                
                [mArr replaceObjectAtIndex:3 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *residenceprovince = dict[@"residenceprovince"];
            if (![residenceprovince isEqualToString:@"不限"]) {
                
                NSString *residencecity = dict[@"residencecity"];
                
                if ([residencecity isEqualToString:residenceprovince]) {
                    
                    mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[4]];;
                    [mDict setObject:[NSString stringWithFormat:@"%@市", residenceprovince] forKey:@"value"];
                } else {
                    
                    mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[4]];;
                    [mDict setObject:[NSString stringWithFormat:@"%@省-%@市", residenceprovince, residencecity] forKey:@"value"];
                }
                
                [mArr replaceObjectAtIndex:4 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *educationFrom = dict[@"educationFrom"];
            if (![educationFrom isEqualToString:@"0"]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[5]];;
                [mDict setObject:[NSString stringWithFormat:@"%@及以上", [kEducation objectAtIndex:(educationFrom.integerValue - 1)]] forKey:@"value"];
                
                [mArr replaceObjectAtIndex:5 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *salaryFrom = dict[@"salaryFrom"];
            if (![salaryFrom isEqualToString:@"0"]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[6]];;
                [mDict setObject:[NSString stringWithFormat:@"%@及以上", salaryFrom] forKey:@"value"];
                
                [mArr replaceObjectAtIndex:6 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *unitnature = dict[@"unitnature"];
            if (![unitnature isEqualToString:@"0"] && [ConversionUtil isNotEmpty:unitnature]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[7]];;
                [mDict setObject:[NSString stringWithFormat:@"%@", [kUnitNature objectAtIndex:(unitnature.integerValue - 1)]] forKey:@"value"];
                
                [mArr replaceObjectAtIndex:7 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *maritalstatus = dict[@"maritalstatus"];
            if (![maritalstatus isEqualToString:@"0"]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[8]];;
                [mDict setObject:[NSString stringWithFormat:@"%@", [kMaritalStatus objectAtIndex:(maritalstatus.integerValue - 1)]] forKey:@"value"];
                
                [mArr replaceObjectAtIndex:8 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *house = dict[@"house"];
            if (![house isEqualToString:@"0"]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[9]];;
                [mDict setObject:[NSString stringWithFormat:@"%@", [kHouseStatus objectAtIndex:(house.integerValue - 1)]] forKey:@"value"];
                
                [mArr replaceObjectAtIndex:9 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            _titleList = [NSArray arrayWithArray:mArr];
            self.conditionid = [dict[@"conditionid"] description];
            
            self.textView.text = dict[@"addition"];
        }
        
        [self.tableView reloadData];
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
    } failure:^(NSError *error) {
        
        NSLog(@"*** failure %@ ***", error.description);
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
    }];
}

// 获取数据
- (NSString *)sql {
    
    NSString *sql = [NSString stringWithFormat:@"\
                     select \
                         conditionid, \
                         sex, \
                         ageFrom, \
                         ageTo, \
                         heightFrom, \
                         domicileprovince, \
                         domicilecity, \
                         residenceprovince, \
                         residencecity, \
                         educationFrom, \
                         salaryFrom, \
                         unitnature, \
                         maritalstatus, \
                         house, \
                         addition \
                     FROM \
                         conditions \
                     WHERE \
                             userid = %@ \
                         AND category = '01'", self.userid];
    
    return sql;
}

// 保存数据
- (NSDictionary *)saveParameters {
    
    NSString *sex = @"0";
    NSString *ageFrom = @"0";
    NSString *ageTo = @"0";
    NSString *heightFrom = @"0";
    NSString *domicileprovince = @"不限";
    NSString *domicilecity = @"";
    NSString *residenceprovince = @"不限";
    NSString *residencecity = @"";
    NSString *educationFrom = @"0";
    NSString *salaryFrom = @"0";
    NSString *unitnature = @"0";
    NSString *maritalstatus = @"0";
    NSString *house = @"0";
    NSString *addition = @"";
    
    // 数据
    NSArray *arr = self.titleList;
    for (int i = 0; i < arr.count; i++) {
        
        NSDictionary *dict = arr[i];
        NSString *value = dict[@"value"];
        NSString *value2 = dict[@"value2"];
        
        if ([value isEqualToString:@"不限"] && (!value2 || [value2 isEqualToString:@"不限"])) {
            continue;
        }
        // 性别
        if (i == 0) {
            
            sex = value;
        }
        // 年龄
        if (i == 1) {
            
            if (![value isEqualToString:@"不限"]) {
                
                int age = [[value substringWithRange:NSMakeRange(0, 2)] intValue];
                int year = [[ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyy"] intValue];
                
                ageTo = [NSString stringWithFormat:@"%d", (year - age)];
            }
            if (![value2 isEqualToString:@"不限"]) {
                
                int age = [[value2 substringWithRange:NSMakeRange(0, 2)] intValue];
                int year = [[ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyy"] intValue];
                
                ageFrom = [NSString stringWithFormat:@"%d", (year - age)];
            }
        }
        // 身高
        if (i == 2) {
            
            heightFrom = [value substringWithRange:NSMakeRange(0, 3)];
        }
        // 户籍
        if (i == 3) {
            
            value = [value stringByReplacingOccurrencesOfString:@"省" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"市" withString:@""];
            if (![value containsString:@"-"]) {
                
                domicileprovince = value;
                domicilecity = value;
            } else {
                
                domicileprovince = [value componentsSeparatedByString:@"-"][0];
                domicilecity = [value componentsSeparatedByString:@"-"][1];
            }
        }
        // 常住城市
        if (i == 4) {
            
            value = [value stringByReplacingOccurrencesOfString:@"省" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"市" withString:@""];
            if (![value containsString:@"-"]) {
                
                residenceprovince = value;
                residencecity = value;
            } else {
                
                residenceprovince = [value componentsSeparatedByString:@"-"][0];
                residencecity = [value componentsSeparatedByString:@"-"][1];
            }
        }
        // 最高学历
        if (i == 5) {
            
            value = [value stringByReplacingOccurrencesOfString:@"及以上" withString:@""];
            NSUInteger index = [kEducation indexOfObject:value];
            
            educationFrom = [NSString stringWithFormat:@"0%ld", (index + 1)];
        }
        // 月收入
        if (i == 6) {
            
            value = [value stringByReplacingOccurrencesOfString:@"及以上" withString:@""];
            
            salaryFrom = value;
        }
        // 单位性质
        if (i == 7) {
            
            unitnature = [NSString stringWithFormat:@"0%ld", ([kUnitNature indexOfObject:value] + 1)];
        }
        // 婚姻状态
        if (i == 8) {
            
            maritalstatus = [NSString stringWithFormat:@"0%ld", ([kMaritalStatus indexOfObject:value] + 1 )];
        }
        // 婚房
        if (i == 9) {
            
            house = [NSString stringWithFormat:@"0%ld", ([kHouseStatus indexOfObject:value] + 1)];
        }
    }
    
    addition = self.textView.text;
    
    NSDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setValue:@"conditions" forKey:@"table"];
    
    [parametersDict setValue:sex forKey:@"sex"];
    [parametersDict setValue:ageFrom forKey:@"ageFrom"];
    [parametersDict setValue:ageTo forKey:@"ageTo"];
    [parametersDict setValue:heightFrom forKey:@"heightFrom"];
    [parametersDict setValue:domicileprovince forKey:@"domicileprovince"];
    [parametersDict setValue:domicilecity forKey:@"domicilecity"];
    [parametersDict setValue:residenceprovince forKey:@"residenceprovince"];
    [parametersDict setValue:residencecity forKey:@"residencecity"];
    [parametersDict setValue:educationFrom forKey:@"educationFrom"];
    [parametersDict setValue:salaryFrom forKey:@"salaryFrom"];
    [parametersDict setValue:unitnature forKey:@"unitnature"];
    [parametersDict setValue:maritalstatus forKey:@"maritalstatus"];
    [parametersDict setValue:house forKey:@"house"];
    [parametersDict setValue:addition forKey:@"addition"];
    
    if ([ConversionUtil isNotEmpty:self.conditionid]) {
        
        [parametersDict setValue:[NSString stringWithFormat:@"id is null and conditionid = '%@' ", self.conditionid] forKey:@"id"];
    } else {
        
        [parametersDict setValue:self.userid forKey:@"userid"];
        [parametersDict setValue:@"01" forKey:@"category"];
    }
    
    return [NSDictionary dictionaryWithDictionary:parametersDict];
}

@end
