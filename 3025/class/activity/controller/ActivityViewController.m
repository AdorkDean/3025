//
//  ActivityViewController.m
//  3025
//
//  Created by ld on 2017/3/27.
//
//

#import "ActivityViewController.h"
#import "DetailViewController.h"
#import "ActivityCell.h"
#import "ActivityModel.h"

#define kHasTa (@[@"不限", @"有TA"])

@interface ActivityViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    
}

@property (nonatomic, strong) UIWindow *keyWindow;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *shadowView2;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *pickerView;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *filterView;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIView *joinView;
@property (nonatomic, strong) UIButton *joinButton;
@property (nonatomic, strong) UIImageView *joinImageView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJRefreshNormalHeader *refreshNormalHeader;
@property (nonatomic, strong) MJRefreshBackNormalFooter *refreshNormalFooter;

@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, copy) NSArray *activityArray;

@property (nonatomic, copy) NSArray *provinceList;
@property (nonatomic, copy) NSArray *cityList;
@property (nonatomic, copy) NSArray *districtList;

@property (nonatomic, copy) NSString *filer_nameOrID;
@property (nonatomic, copy) NSString *filer_location;
@property (nonatomic, copy) NSString *filer_timeFrom;
@property (nonatomic, copy) NSString *filer_timeTo;
@property (nonatomic, copy) NSString *filer_category;
@property (nonatomic, assign) BOOL filer_hasTa;
@property (nonatomic, assign) NSInteger filer_join;

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
    
    self.pageNumber = 0;
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 键盘弹出／收起通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
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
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightCustomView];
    
    self.navigationItem.titleView = titleLabel;
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.text = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.view endEditing:YES];
    
    self.filer_nameOrID = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.filer_nameOrID.length > 0) {
        
        self.pageNumber = 0;
        [self loadData];
        
        self.filer_nameOrID = nil;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.textField = textField;
    if (textField.tag == 1 || textField.tag == 11) { // 日期
        
        if (!self.datePicker) {
            
            self.datePicker = [[UIDatePicker alloc] init];
            self.datePicker.backgroundColor = kBackgroundColor;
            self.datePicker.datePickerMode = UIDatePickerModeDate;
            [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        }
        
        // 设定日期约束
        self.datePicker.date = [NSDate date];
        self.datePicker.minimumDate = nil;
        self.datePicker.maximumDate = nil;
        
        if (textField.tag == 1) {
            
            for (UIView *subview in textField.superview.subviews) {
                if ([subview isKindOfClass:[UITextField class]] && subview.tag == 11) {
                    
                    UITextField *textField = (UITextField *)subview;
                    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([text containsString:@"/"]) {
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        dateFormatter.dateFormat = @"yyyy/MM/dd";
                        self.datePicker.maximumDate = [dateFormatter dateFromString:text];
                    }
                }
            }
        } else if (textField.tag == 11) {
            
            for (UIView *subview in textField.superview.subviews) {
                if ([subview isKindOfClass:[UITextField class]] && subview.tag == 1) {
                    
                    UITextField *textField = (UITextField *)subview;
                    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([text containsString:@"/"]) {
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        dateFormatter.dateFormat = @"yyyy/MM/dd";
                        self.datePicker.minimumDate = [dateFormatter dateFromString:text];
                    }
                }
            }
        }
        
        NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([text containsString:@"/"]) {

            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy/MM/dd";
            self.datePicker.date = [dateFormatter dateFromString:text];
        }
        
        [self.pickerView removeFromSuperview];
        self.pickerView = self.datePicker;
        
        self.pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
        [self.keyWindow addSubview:self.pickerView];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.pickerView.frame = CGRectMake(0, kScreenHeight-216, kScreenWidth, 216);
        }];
    } else {
        
        if (textField.tag == 3) {
            if ([self goLogin:nil message:@"该操作需要您先登录"]) {
                
                [self shadowViewTapped:[self.shadowView.gestureRecognizers firstObject]];
                return NO;
            }
        }
        
        if (!self.picker) {
            
            self.picker = [[UIPickerView alloc] init];
            self.picker.backgroundColor = kBackgroundColor;
            self.picker.showsSelectionIndicator = YES;
            self.picker.dataSource = self;
            self.picker.delegate = self;
        }

        [self.pickerView removeFromSuperview];
        self.pickerView = self.picker;
        
        self.pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
        [self.keyWindow addSubview:self.pickerView];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.pickerView.frame = CGRectMake(0, kScreenHeight-216, kScreenWidth, 216);
        }];
        
        [self.picker reloadAllComponents];
        if (self.textField.tag == 0) {
            
            NSInteger row = 0;
            NSInteger row1 = 0;
            NSInteger row2 = 0;
            
            NSString *text = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSArray *arr = [text componentsSeparatedByString:@"-"];
            if (arr.count == 3) {
                
                NSString *province = arr[0];
                NSString *city = arr[1];
                NSString *district = arr[2];
                
                row = [self.provinceList indexOfObject:province];
                row1 = [self.cityList[row] indexOfObject:city];
                row2 = [self.districtList[row][row1] indexOfObject:district];
            }
            
            [self.picker reloadComponent:0];
            [self.picker selectRow:row inComponent:0 animated:YES];
            
            [self.picker reloadComponent:1];
            [self.picker selectRow:row1 inComponent:1 animated:YES];
            
            [self.picker reloadComponent:2];
            [self.picker selectRow:row2 inComponent:2 animated:YES];
        } else if (self.textField.tag == 2) {
            
            NSInteger row = 0;
            NSInteger row1 = 0;
            
            NSString *text = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSArray *arr = [text componentsSeparatedByString:@"-"];
            if (arr.count == 2) {
                
                NSString *category = arr[0];
                NSString *subCategory = arr[1];
                if ([subCategory isEqualToString:@"其他"]) {
                    subCategory = category;
                }
                
                row = [kActivityCategory indexOfObject:category];
                row1 = [kActivityCategorys[row] indexOfObject:subCategory];
            }
            
            [self.picker reloadComponent:0];
            [self.picker selectRow:row inComponent:0 animated:YES];
            
            [self.picker reloadComponent:1];
            [self.picker selectRow:row1 inComponent:1 animated:YES];
        } else if (self.textField.tag == 3) {
            
            NSInteger row = 0;
            
            NSString *text = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([text isEqualToString:kHasTa[1]]) {
                
                row = 1;
            }
            
            [self.picker reloadComponent:0];
            [self.picker selectRow:row inComponent:0 animated:YES];
        }
    }
    
    return NO;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    if (self.textField.tag == 0) { // 活动地址

        return 3;
    } else if (self.textField.tag == 2) { // 活动类型

        return 2;
    } else if (self.textField.tag == 3) { // TA已报名

        return 1;
    }

    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (self.textField.tag == 0) { // 活动地址
        
        if (component == 0) { // 省
            
            return self.provinceList.count;
        } else if (component == 1) { // 市
            
            NSInteger selectedRow = [pickerView selectedRowInComponent:0];
            
            return [self.cityList[selectedRow] count];
        } else if (component == 2) { // 区
            
            NSInteger selectedRow = [pickerView selectedRowInComponent:0];
            NSInteger selectedRow1 = [pickerView selectedRowInComponent:1];
            
            return [self.districtList[selectedRow][selectedRow1] count];
        }
    } else if (self.textField.tag == 2) { // 活动类型

        if (component == 0) { // 大分类

            return kActivityCategory.count;
        } else if (component == 1) { // 小分类

            NSInteger selectedRow = [pickerView selectedRowInComponent:0];
            
            return [kActivityCategorys[selectedRow] count];
        }
    } else if (self.textField.tag == 3) { // TA已报名

        return kHasTa.count;
    }

    return 0;
}

#pragma mark - UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (self.textField.tag == 0) { // 活动地址
        
        if (component == 0) { // 省
            
            return self.provinceList[row];
        } else if (component == 1) { // 市
            
            NSInteger selectedRow = [pickerView selectedRowInComponent:0];
            
            return self.cityList[selectedRow][row];
        } else if (component == 2) { // 区
            
            NSInteger selectedRow = [pickerView selectedRowInComponent:0];
            NSInteger selectedRow1 = [pickerView selectedRowInComponent:1];
            
            return self.districtList[selectedRow][selectedRow1][row];
        }
    } else if (self.textField.tag == 2) { // 活动类型

        if (component == 0) { // 大分类

            return kActivityCategory[row];
        } else if (component == 1) { // 小分类

            NSInteger selectedRow = [pickerView selectedRowInComponent:0];
            if (row >0 && row == ([kActivityCategorys[selectedRow] count] - 1)) {
                return @"其他";
            }
            return [kActivityCategorys[selectedRow] objectAtIndex:row];
        }
    } else if (self.textField.tag == 3) { // TA已报名

        return kHasTa[row];
    }

    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *title;
    
    if (self.textField.tag == 0) { // 活动地址
        
        if (component == 0) { // 省
            
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        } else if (component == 1) { // 市
            
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        } else if (component == 2) { // 区
            
        }
        
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        NSInteger selectedRow1 = [pickerView selectedRowInComponent:1];
        NSInteger selectedRow2 = [pickerView selectedRowInComponent:2];
        
        NSString *province = self.provinceList[selectedRow];
        NSString *city = self.cityList[selectedRow][selectedRow1];
        NSString *district = self.districtList[selectedRow][selectedRow1][selectedRow2];
        
        title = [NSString stringWithFormat:@"%@-%@-%@", province, city, district];
    } else if (self.textField.tag == 2) { // 活动类型
        
        if (component == 0) { // 大分类
            
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        } else if (component == 1) { // 小分类
            
        }
        
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        NSInteger selectedRow1 = [pickerView selectedRowInComponent:1];
        if (selectedRow1 == ([kActivityCategorys[selectedRow] count] - 1)) {
            title = [NSString stringWithFormat:@"%@-%@", kActivityCategory[selectedRow], @"其他"];
        } else {
            title = [NSString stringWithFormat:@"%@-%@", kActivityCategory[selectedRow], [kActivityCategorys[selectedRow] objectAtIndex:selectedRow1]];
        }
    } else if (self.textField.tag == 3) { // TA已报名
        
        title = kHasTa[row];
    }
    
    if (title) {
        self.textField.text = [NSString stringWithFormat:@"  %@", [title containsString:@"不限-"] ? @"不限" : title];
    }
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
    ActivityModel *activityModel = [ActivityModel mj_objectWithKeyValues:self.activityArray[indexPath.row]];
    [cell setupData:activityModel];
    
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
    
    ActivityModel *activityModel = [ActivityModel mj_objectWithKeyValues:self.activityArray[indexPath.row]];
    [cell setupData:activityModel];
    
    return [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityModel *activityModel = [ActivityModel mj_objectWithKeyValues:self.activityArray[indexPath.row]];
    
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.activityModel = activityModel;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 事件处理

- (void)showFilter:(UIButton *)button {

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
            [self.pickerView removeFromSuperview];
            
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
    
    if (self.pickerView.superview) {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
        } completion:^(BOOL finished) {
            
            [self.pickerView removeFromSuperview];
        }];
    }
}

- (void)joinLabelTapped:(UITapGestureRecognizer *)gestureRecognizer {
    
    UILabel *titleLabel = (UILabel *)gestureRecognizer.view;
    
    if (titleLabel.tag == 1 || titleLabel.tag == 2) {
        if ([self goLogin:nil message:@"该操作需要您先登录"]) {
            
            [self shadowViewTapped:[self.shadowView.gestureRecognizers firstObject]];
            return;
        }
    }

    self.joinImageView.hidden = NO;
    [self.joinImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel);
        make.right.mas_equalTo(_joinView).mas_offset(-20);
    }];
    
    [self shadowViewTapped:[self.shadowView.gestureRecognizers firstObject]];
    
    self.filer_join = titleLabel.tag;
    self.pageNumber = 0;
    [self loadData];
}

- (void)reset:(UIButton *)button {
    for (UIView *subviw in button.superview.subviews) {
        if ([subviw isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subviw;
            textField.text = @"";
        }
    }
    self.filer_location = nil;
    self.filer_timeFrom = nil;
    self.filer_timeTo = nil;
    self.filer_category = nil;
    self.filer_hasTa = NO;
}

- (void)filter:(UIButton *)button {

    // 收起检索条件区域
    [self shadowViewTapped:[self.shadowView.gestureRecognizers firstObject]];
    
    for (UIView *subviw in button.superview.subviews) {
        if ([subviw isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subviw;
            NSInteger tag = textField.tag;
            NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (tag == 0) {
                self.filer_location = nil;
                if (![text isEqualToString:@""] && ![text isEqualToString:@"不限"]) {
                    text = [text stringByReplacingOccurrencesOfString:@"省" withString:@""];
                    text = [text stringByReplacingOccurrencesOfString:@"市" withString:@""];
                    self.filer_location = text;
                }
            } else if (tag == 1) {
                self.filer_timeFrom = nil;
                if (![text isEqualToString:@""] && ![text isEqualToString:@"不限"]) {
                    self.filer_timeFrom = text;
                }
            } else if (tag == 11) {
                self.filer_timeTo = nil;
                if (![text isEqualToString:@""] && ![text isEqualToString:@"不限"]) {
                    self.filer_timeTo = text;
                }
            } else if (tag == 2) {
                self.filer_category = nil;
                if (![text isEqualToString:@""] && ![text isEqualToString:@"不限"]) {
                    NSArray *arr = [text componentsSeparatedByString:@"-"];
                    if (arr.count == 2) {
                        NSString *category = arr[0];
                        NSString *subCategory = [arr[1] isEqualToString:@"其他"] ? arr[0] : arr[1];
                        NSInteger idx = [kActivityCategory indexOfObject:category];
                        if ([subCategory isEqualToString:@"全部"]) {
                            self.filer_category = [NSString stringWithFormat:@"0%ld", idx];
                        } else {
                            NSInteger idx2 = [kActivityCategorys[idx] indexOfObject:subCategory];
                            self.filer_category = [NSString stringWithFormat:@"0%ld0%ld", idx, idx2];
                        }
                    }
                }
            } else if (tag == 3) {
                self.filer_hasTa = [text isEqualToString:kHasTa[1]];
            }
        }
    }

    // 检索数据
    self.pageNumber = 0;
    [self loadData];
}

- (void)dateChanged:(UIDatePicker *)datePicker {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    self.textField.text = [NSString stringWithFormat:@"  %@", [dateFormatter stringFromDate:datePicker.date]];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    if (self.shadowView.superview == self.keyWindow) {
        
        [self shadowViewTapped:[self.shadowView.gestureRecognizers firstObject]];
    }

    float duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.shadowView2.frame = CGRectMake(0, 108, kScreenWidth, kScreenHeight-108);
    
    [self.view addSubview:self.shadowView2];
    [UIView animateWithDuration:duration animations:^{
        
        self.shadowView2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (self.shadowView.superview == self.keyWindow) {
        
        [self shadowViewTapped:[self.shadowView.gestureRecognizers firstObject]];
    }

    float duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        self.shadowView2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        
        [self.shadowView2 removeFromSuperview];
    }];
}

- (void)hideKeyboard:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
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
        
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.backgroundImage = [[UIImage alloc] init];
        searchBar.placeholder = @"搜索活动名称/活动ID";
        searchBar.returnKeyType = UIReturnKeySearch;
        searchBar.delegate = self;
        searchBar.subviews.firstObject.subviews[1].backgroundColor = [UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1.0f];
        
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
        
        [_headView addSubview:searchBar];
        [_headView addSubview:middleLineView];
        [_headView addSubview:filterButton];
        [_headView addSubview:vLineView];
        [_headView addSubview:joinButton];
        [_headView addSubview:bottomLineView];
        
        [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headView);
            make.left.mas_equalTo(_headView).mas_offset(10);
            make.right.mas_equalTo(_headView).mas_offset(-10);
        }];
        [middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.mas_equalTo(_headView);
            make.bottom.mas_equalTo(searchBar);
            make.height.mas_equalTo(0.5);
        }];
        [filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(searchBar);
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
            textField.tag = i;
            textField.delegate = self;
            
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
                endTextField.tag = i*10+i;
                endTextField.delegate = self;
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
        
        UIButton *resetButton = [[UIButton alloc] init];
        resetButton.layer.borderWidth = 0.5;
        resetButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        resetButton.layer.masksToBounds = YES;
        [resetButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [resetButton setTitle:@"重置" forState:UIControlStateNormal];
        [resetButton addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];

        UIButton *submitButton = [[UIButton alloc] init];
        submitButton.layer.borderWidth = 0.5;
        submitButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        submitButton.layer.masksToBounds = YES;
        submitButton.backgroundColor = [UIColor colorWithRed:228.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f];
        [submitButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [submitButton setTitle:@"确定" forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
        
        [_filterView addSubview:resetButton];
        [_filterView addSubview:submitButton];
        
        [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(layoutLabel.mas_bottom);
            make.bottom.mas_equalTo(_filterView);
            make.left.mas_equalTo(_filterView);
            make.right.mas_equalTo(_filterView.mas_centerX);
        }];
        [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(resetButton);
            make.left.mas_equalTo(resetButton.mas_right);
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

- (UIView *)shadowView2 {
    
    if (!_shadowView2) {
        
        _shadowView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 108, kScreenWidth, kScreenHeight-108)];
        _shadowView2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        [_shadowView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)]];
    }
    
    return _shadowView2;
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
        joinImageView.hidden = NO;
        self.joinImageView = joinImageView;
        
        [_joinView addSubview:joinImageView];
        
        [joinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(layoutLabel).offset(-120);
            make.right.mas_equalTo(_joinView).mas_offset(-20);
        }];
    }
    
    return _joinView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
        _tableView.mj_header = self.refreshNormalHeader;
        _tableView.mj_footer = self.refreshNormalFooter;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

- (MJRefreshNormalHeader *)refreshNormalHeader {
    
    if (!_refreshNormalHeader) {
        
        _refreshNormalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

            self.pageNumber = 0;
            [self loadData];
        }];
    }
    
    return _refreshNormalHeader;
}

- (MJRefreshBackNormalFooter *)refreshNormalFooter {
    
    if (!_refreshNormalFooter) {
        
        _refreshNormalFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            self.userid ? (self.pageNumber = 0) : self.pageNumber++;
            [self loadData];
        }];
    }
    
    return _refreshNormalFooter;
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

- (NSArray *)districtList {

    if (!_districtList) {

        NSString *path = [[NSBundle mainBundle] pathForResource:@"pcd" ofType:@"plist"];
        NSDictionary *pcdDict = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        _districtList = [pcdDict objectForKey:@"district"];
    }

    return _districtList;
}

#pragma mark - 数据处理

- (void)loadData {
    
    NSString *url;
    NSDictionary *parameterDict;
    
    if (self.userid) {

        url = [NSString stringWithFormat:@"%@%@", kDomain, @"activity/filter.html"];
        parameterDict = @{
                          @"conditionUserid": self.userid,
                          @"myUserid": self.userid
                        };
        NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:parameterDict];
        if (self.filer_nameOrID) {
            
            [mDict setObject:self.filer_nameOrID forKey:@"activityid"];
            [mDict setObject:self.filer_nameOrID forKey:@"activityname"];
        } else {
            
            switch (self.filer_join) {
                case 1:
                    [mDict setObject:self.userid forKey:@"userid"];
                    break;
                case 2:
                    [mDict setObject:self.userid forKey:@"registered"];
                    break;
                case 3:
                    [mDict setObject:@"1" forKey:@"history"];
                    break;
                default:
                    break;
            }
            // 活动地址
            if (self.filer_location) {
                NSArray *arr = [self.filer_location componentsSeparatedByString:@"-"];
                [mDict setObject:arr[0] forKey:@"province"];
                [mDict setObject:arr[1] forKey:@"city"];
                [mDict setObject:arr[2] forKey:@"district"];
            }
            // 活动时间
            if (self.filer_timeFrom) {
                NSDate *date = [ConversionUtil dateFromString:self.filer_timeFrom dateFormat:@"yyyy/MM/dd"];
                [mDict setObject:[ConversionUtil stringFromDate:date dateFormat:@"yyyy-MM-dd"] forKey:@"activitytimeFrom"];
            }
            if (self.filer_timeTo) {
                NSDate *date = [ConversionUtil dateFromString:self.filer_timeTo dateFormat:@"yyyy/MM/dd"];
                [mDict setObject:[ConversionUtil stringFromDate:date dateFormat:@"yyyy-MM-dd"] forKey:@"activitytimeTo"];
            }
            // 活动类别
            if (self.filer_category) {
                [mDict setObject:self.filer_category forKey:@"category"];
            }
            // 有TA
            if (self.filer_hasTa) {
                [mDict setObject:@"01" forKey:@"other"];
            }
        }
        parameterDict = [NSDictionary dictionaryWithDictionary:mDict];
    } else {
        NSMutableString *filter = [NSMutableString stringWithFormat:@""];
        
        if (self.filer_nameOrID) {
            
            [filter appendString:[NSString stringWithFormat:@" and (a.activityid = '%@' or a.activityname like '%@%@%@') ", self.filer_nameOrID, @"%", self.filer_nameOrID, @"%"]];
        } else {
        
            if (self.filer_join == 3) {
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
                
                [filter appendString:[NSString stringWithFormat:@" and a.activitytime < '%@' ", [dateFormatter stringFromDate:[NSDate date]]]];
            }
            // 活动地址
            if (self.filer_location) {
                NSArray *arr = [self.filer_location componentsSeparatedByString:@"-"];
                [filter appendString:[NSString stringWithFormat:@" and a.province = '%@' and a.city = '%@' and a.district = '%@' ", arr[0], arr[1], arr[2]]];
            }
            // 活动时间
            if (self.filer_timeFrom) {
                [filter appendString:[NSString stringWithFormat:@" and a.activitytime >= '%@ 00:00' ", self.filer_timeFrom]];
            }
            if (self.filer_timeTo) {
                [filter appendString:[NSString stringWithFormat:@" and a.activitytime <= '%@ 23:59' ", self.filer_timeTo]];
            }
            // 活动类别
            if (self.filer_category) {
                [filter appendString:[NSString stringWithFormat:@" and a.category like '%@' ", self.filer_category]];
            }
        }
        NSString *sql = [NSString stringWithFormat:@"\
                     select \
                         u.userid, \
                         u.poster, \
                         a.activityid, \
                         a.activityname, \
                         a.capacityTo, \
                         a.category, \
                         a.content, \
                         a.province, \
                         a.city, \
                         a.district \
                     from \
                         activity a \
                     left join \
                         user u \
                     on \
                         a.userid = u.userid \
                     where \
                         a.status != '00' %@ \
                     order by \
                         a.updatetime desc \
                     limit \
                         %ld, 10;", filter, self.pageNumber*10];
        
        url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
        parameterDict = @{ @"sql": sql };
    }

    [HttpUtil query:url parameter:parameterDict success:^(id responseObject) {
        
        NSString *json = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (self.userid) {

            NSArray *arr = [NSArray mj_objectArrayWithKeyValuesArray:json];
            arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([obj1[@"updatetime"] integerValue] > [obj2[@"updatetime"] integerValue]) {
                    return NSOrderedAscending;
                }
                return NSOrderedDescending;
            }];
            if (self.pageNumber > 0) {

                NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.activityArray];
                [mArr addObjectsFromArray:arr];
                self.activityArray = [NSArray arrayWithArray:mArr];
            } else {
                self.activityArray = [NSArray arrayWithArray:arr];
            }
        } else {
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *arr = responseDict[@"list"];
            if (self.pageNumber > 0) {

                NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.activityArray];
                [mArr addObjectsFromArray:arr];
                self.activityArray = [NSArray arrayWithArray:mArr];
            } else {
                self.activityArray = [NSArray arrayWithArray:arr];
            }
        }

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"*** %@ ***", error);
    }];
}

@end
