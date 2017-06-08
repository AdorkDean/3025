//
//  PropertyCell.m
//  3025
//
//  Created by ld on 2017/6/8.
//
//

#import "PropertyCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "Constant.h"
#import "ConversionUtil.h"

@interface PropertyCell () <UITextFieldDelegate> {
    
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *vLineView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *posterImageView;

@end

@implementation PropertyCell

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
    
    UIImageView *posterImageView = [[UIImageView alloc] init];
    posterImageView.layer.borderWidth = 1.0;
    posterImageView.layer.borderColor = kKeyColor.CGColor;
    posterImageView.layer.cornerRadius = 20;
    posterImageView.layer.masksToBounds = YES;
    posterImageView.image = [UIImage imageNamed:@"poster"];
    posterImageView.userInteractionEnabled = YES;
    [posterImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(posterTapped:)]];
    
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:vLineView];
    [self.contentView addSubview:textField];
    [self.contentView addSubview:posterImageView];
    
    self.titleLabel = titleLabel;
    self.vLineView = vLineView;
    self.textField = textField;
    self.posterImageView = posterImageView;
}

- (void)setupData:(NSDictionary *)dict {
    
    self.titleLabel.text = dict[@"title"];
    if (self.multi) {
        if (dict[@"image"]) {
            self.posterImageView.image = dict[@"image"];
        } else {
            [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"value"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }
    } else {
        self.textField.text = [NSString stringWithFormat:@"  %@", dict[@"value"]];
    }
}

- (void)setMulti:(BOOL)multi {
    
    self.posterImageView.hidden = !multi;
    _multi = multi;
    
    if (multi) {
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(15);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_equalTo(60);
        }];
        [self.vLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(20);
        }];
        [self.posterImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).mas_offset(-15);
            make.centerY.mas_equalTo(self.contentView);
            make.width.height.mas_equalTo(40);
        }];
    } else {
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(15);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_equalTo(60);
        }];
        [self.vLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(20);
        }];
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.vLineView.mas_right).mas_offset(15);
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView).mas_offset(-15);
            make.height.mas_equalTo(25);
        }];
    }
}

- (void)posterTapped:(UITapGestureRecognizer *)tapGestureRecognizer {

    if ([self.delegate respondsToSelector:@selector(input:)]) {
        
        [self.delegate input:self.indexPath];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([self.delegate respondsToSelector:@selector(input:)]) {
        
        [self.delegate input:self.indexPath];
    }
    
    // 昵称 || 职位
    if (self.indexPath.row == 1 || self.indexPath.row == 10) {
        return YES;
    }
    
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    // 昵称 || 职位
    if (self.indexPath.row == 1 || self.indexPath.row == 10) {
        if ([self.delegate respondsToSelector:@selector(inputComplete:)]) {
            
            [self.delegate inputComplete:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
    }
}

@end
