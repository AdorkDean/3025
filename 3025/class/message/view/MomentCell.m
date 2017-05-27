//
//  MomentCell.m
//  3025
//
//  Created by ld on 2017/5/27.
//
//

#import "MomentCell.h"
#import "Constant.h"
#import "ConversionUtil.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface MomentCell () {
    
}

@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *extendButton;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation MomentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    
    UIImageView *posterImageView = [[UIImageView alloc] init];
    posterImageView.contentMode = UIViewContentModeScaleToFill;
    posterImageView.layer.borderColor = kKeyColor.CGColor;
    posterImageView.layer.borderWidth = 1;
    posterImageView.layer.cornerRadius = 20;
    posterImageView.layer.masksToBounds = YES;
    
    UILabel *nicknameLabel = [[UILabel alloc] init];
    nicknameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    nicknameLabel.textColor = [UIColor blackColor];
    nicknameLabel.numberOfLines = 1;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:12.0f];
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.numberOfLines = 0;
    contentLabel.preferredMaxLayoutWidth = (kScreenWidth - 70);
    
    UIButton *extendButton = [[UIButton alloc] init];
    [extendButton setTitle:@"全文" forState:UIControlStateNormal];
    [extendButton setTitleColor:kKeyColor forState:UIControlStateNormal];
    [extendButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.contentMode = UIViewContentModeScaleToFill;
    imageView1.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.contentMode = UIViewContentModeScaleToFill;
    imageView2.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *imageView3 = [[UIImageView alloc] init];
    imageView3.contentMode = UIViewContentModeScaleToFill;
    imageView3.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12.0f];
    timeLabel.textColor = [UIColor grayColor];
    [timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    UIButton *deleteButton = [[UIButton alloc] init];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:kKeyColor forState:UIControlStateNormal];
    [deleteButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    
    [self.contentView addSubview:posterImageView];
    [self.contentView addSubview:nicknameLabel];
    [self.contentView addSubview:contentLabel];
    [self.contentView addSubview:extendButton];
    [self.contentView addSubview:imageView1];
    [self.contentView addSubview:imageView2];
    [self.contentView addSubview:imageView3];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:deleteButton];
    
    self.posterImageView = posterImageView;
    self.nicknameLabel = nicknameLabel;
    self.contentLabel = contentLabel;
    self.extendButton = extendButton;
    self.imageView1 = imageView1;
    self.imageView2 = imageView2;
    self.imageView3 = imageView3;
    self.timeLabel = timeLabel;
    self.deleteButton = deleteButton;
    
    
    MASAttachKeys(posterImageView, nicknameLabel, contentLabel, extendButton, imageView1, imageView2, imageView3, timeLabel, deleteButton);
}

- (void)setupData:(MomentModel *)momentModel {
    
    NSUInteger category = 0;
    if ([ConversionUtil isEmpty:momentModel.image1]) {
        if ([ConversionUtil isEmpty:momentModel.image2]) {
            if ([ConversionUtil isEmpty:momentModel.image3]) {
                momentModel.image1 = nil;
                momentModel.image2 = nil;
                momentModel.image3 = nil;
                category = 0;
            } else {
                momentModel.image1 = momentModel.image3;
                momentModel.image2 = nil;
                momentModel.image3 = nil;
                category = 1;
            }
        } else {
            if ([ConversionUtil isEmpty:momentModel.image3]) {
                momentModel.image1 = momentModel.image2;
                momentModel.image2 = nil;
                momentModel.image3 = nil;
                category = 1;
            } else {
                momentModel.image1 = momentModel.image2;
                momentModel.image2 = momentModel.image3;
                momentModel.image3 = nil;
                category = 2;
            }
        }
    } else {
        if ([ConversionUtil isEmpty:momentModel.image2]) {
            if ([ConversionUtil isEmpty:momentModel.image3]) {
                momentModel.image2 = nil;
                momentModel.image3 = nil;
                category = 1;
            } else {
                momentModel.image2 = momentModel.image3;
                momentModel.image3 = nil;
                category = 2;
            }
        } else {
            if ([ConversionUtil isEmpty:momentModel.image3]) {
                momentModel.image3 = nil;
                category = 2;
            } else {
                category = 3;
            }
        }
    }
    
    BOOL needExtend = NO;
    BOOL hasContent = [ConversionUtil isNotEmpty:momentModel.content];
    BOOL hasImage = (category > 0);
    
    // 头像
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:momentModel.poster] placeholderImage:[UIImage imageNamed:@"poster"]];
    
    // 昵称
    self.nicknameLabel.text = momentModel.nickname;
    
    // 内容
    if (hasContent) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.lineSpacing = 5.0;
        
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:@"内容" attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        float rowHeight = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.preferredMaxLayoutWidth, MAXFLOAT)].height;
        
        momentModel.content = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@", momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content, momentModel.content];
        
        self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:momentModel.content attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        
        float totalHeight = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.preferredMaxLayoutWidth, MAXFLOAT)].height;
        
        needExtend = (totalHeight > (3 * rowHeight - 5));
    }
    self.contentLabel.hidden = !hasContent;
    
    // 全文／收起按钮
    self.extendButton.hidden = !needExtend;
    
    float imageWidth = 0;
    float imageHeight = 0;
    
    // 图片
    if (hasImage) {
        switch (category) {
            case 1:
                [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:momentModel.image1]];
                self.imageView1.hidden = NO;
                self.imageView2.hidden = YES;
                self.imageView3.hidden = YES;
                break;
            case 2:
                [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:momentModel.image1]];
                [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:momentModel.image2]];
                self.imageView1.hidden = NO;
                self.imageView2.hidden = NO;
                self.imageView3.hidden = YES;
                break;
            case 3:
                [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:momentModel.image1]];
                [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:momentModel.image2]];
                [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:momentModel.image3]];
                self.imageView1.hidden = NO;
                self.imageView2.hidden = NO;
                self.imageView3.hidden = NO;
                break;
            default:
                break;
        }
        imageWidth = (self.contentLabel.preferredMaxLayoutWidth - (category - 1) * 10) / category;
        imageHeight = imageWidth * 9 / 16;
    }
    
    // 时间
    self.timeLabel.text = momentModel.displaytime;
    
    // 删除
    self.deleteButton.hidden = !self.isMine;
    
    // 布局
    [self.posterImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.contentView).mas_offset(10);
        make.width.height.mas_equalTo(40);
    }];
    [self.nicknameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.posterImageView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.posterImageView);
        make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-10);
    }];
    if (hasContent) {
        if (self.isExtend) {
            self.contentLabel.numberOfLines = 0;
        } else {
            self.contentLabel.numberOfLines = 3;
        }
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nicknameLabel);
            make.top.mas_equalTo(self.nicknameLabel.mas_bottom).mas_offset(10);
            make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-10);
        }];
        if (needExtend) {
            [self.extendButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.nicknameLabel);
                make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(10);
            }];
        }
    }
    if (hasImage) {
        [self.imageView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nicknameLabel);
            if (self.extendButton.hidden) {
                if (self.contentLabel.hidden) {
                    make.top.mas_equalTo(self.nicknameLabel.mas_bottom).mas_offset(10);
                } else {
                    make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(10);
                }
            } else {
                make.top.mas_equalTo(self.extendButton.mas_bottom).mas_offset(10);
            }
            make.width.mas_equalTo(imageWidth);
            make.height.mas_equalTo(imageHeight);
        }];
        if (!self.imageView2.hidden) {
            [self.imageView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.imageView1.mas_right).mas_offset(10);
                make.top.width.height.mas_equalTo(self.imageView1);
            }];
        }
        if (!self.imageView3.hidden) {
            [self.imageView3 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.imageView2.mas_right).mas_offset(10);
                make.top.width.height.mas_equalTo(self.imageView1);
            }];
        }
    }
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nicknameLabel);
        if (hasImage) {
            make.top.mas_equalTo(self.imageView1.mas_bottom).mas_offset(10);
        } else {
            if (self.extendButton.hidden) {
                if (self.contentLabel.hidden) {
                    make.top.mas_equalTo(self.nicknameLabel.mas_bottom).mas_offset(10);
                } else {
                    make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(10);
                }
            } else {
                make.top.mas_equalTo(self.extendButton.mas_bottom).mas_offset(10);
            }
        }
        make.bottom.mas_equalTo(self.contentView).mas_offset(-10);
    }];
    [self.deleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-10);
        make.centerY.mas_equalTo(self.timeLabel);
    }];
}

@end
