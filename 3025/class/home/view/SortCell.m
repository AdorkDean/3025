//
//  SortCell.m
//  3025
//
//  Created by ld on 2017/5/11.
//
//

#import "SortCell.h"
#import "Masonry.h"
#import "Constant.h"

@interface SortCell () <UITextFieldDelegate> {

}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *vLineView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *hLineView;
@property (nonatomic, strong) UITextField *toTextField;

@end

@implementation SortCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = [UIColor blackColor];
    
    UIView *vLineView = [[UIView alloc] init];
    vLineView.backgroundColor = kLineColor;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = kLineColor.CGColor;
    textField.layer.cornerRadius = 5;
    textField.font = [UIFont systemFontOfSize:14.0f];
    textField.textColor = [UIColor blackColor];
    textField.delegate = self;
    
    UIView *hLineView = [[UIView alloc] init];
    hLineView.backgroundColor = kLineColor;

    UITextField *toTextField = [[UITextField alloc] init];
    toTextField.layer.borderWidth = 0.5;
    toTextField.layer.borderColor = kLineColor.CGColor;
    toTextField.layer.cornerRadius = 5;
    toTextField.font = [UIFont systemFontOfSize:14.0f];
    toTextField.textColor = [UIColor blackColor];
    toTextField.delegate = self;
    
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:vLineView];
    [self.contentView addSubview:textField];
    [self.contentView addSubview:hLineView];
    [self.contentView addSubview:toTextField];
    
    self.titleLabel = titleLabel;
    self.vLineView = vLineView;
    self.textField = textField;
    self.hLineView = hLineView;
    self.toTextField = toTextField;
}

- (void)setupData:(NSDictionary *)dict {
    
    self.titleLabel.text = dict[@"title"];
    self.textField.text = [NSString stringWithFormat:@"  %@", dict[@"value"]];
    self.toTextField.text = [NSString stringWithFormat:@"  %@", dict[@"value2"]];
}

- (void)setMulti:(BOOL)multi {
    
    self.hLineView.hidden = !multi;
    self.toTextField.hidden = !multi;
    _multi = multi;
    
    if (multi) {
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(10);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_equalTo(60);
        }];
        [self.vLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(10);
            make.top.mas_equalTo(self.contentView).mas_offset(10);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-10);
            make.width.mas_equalTo(1);
        }];
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.vLineView.mas_right).mas_offset(15);
            make.centerY.mas_equalTo(self.contentView);
            make.height.mas_equalTo(25);
        }];
        [self.hLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.textField.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_equalTo(10);
            make.height.mas_equalTo(1);
        }];
        [self.toTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.hLineView.mas_right).mas_offset(10);
            make.right.mas_equalTo(self.contentView).mas_offset(-10);
            make.centerY.mas_equalTo(self.contentView);
            make.width.height.mas_equalTo(self.textField);
        }];
    } else {
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(10);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_equalTo(60);
        }];
        [self.vLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(10);
            make.top.mas_equalTo(self.contentView).mas_offset(10);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-10);
            make.width.mas_equalTo(1);
        }];
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.vLineView.mas_right).mas_offset(15);
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView).mas_offset(-10);
            make.height.mas_equalTo(25);
        }];
        [self.hLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        [self.toTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([self.delegate respondsToSelector:@selector(input:multi:)]) {

        [self.delegate input:self.indexPath multi:(textField == self.toTextField)];
    }
    
    return NO;
}

@end
