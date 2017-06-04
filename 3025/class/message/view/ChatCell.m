//
//  ChatCell.m
//  3025
//
//  Created by WangErdong on 2017/6/3.
//
//

#import "ChatCell.h"
#import "Constant.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "ConversionUtil.h"

@interface ChatCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    
    self.backgroundColor = kBackgroundColor;
    self.contentView.backgroundColor = kBackgroundColor;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12.0f];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.numberOfLines = 1;
    [timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    UIImageView *posterImageView = [[UIImageView alloc] init];
    posterImageView.contentMode = UIViewContentModeScaleToFill;
    posterImageView.layer.borderColor = kKeyColor.CGColor;
    posterImageView.layer.borderWidth = 1;
    posterImageView.layer.cornerRadius = 20;
    posterImageView.layer.masksToBounds = YES;
    
    UIView *shadowView = [[UIView alloc] init];
    shadowView.backgroundColor = kKeyColor;
    shadowView.layer.masksToBounds = YES;
    shadowView.layer.cornerRadius = 5;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:14.0f];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.numberOfLines = 0;
    contentLabel.preferredMaxLayoutWidth = (kScreenWidth - 130);
    
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:posterImageView];
    [self.contentView addSubview:shadowView];
    [self.contentView addSubview:contentLabel];
    
    self.timeLabel = timeLabel;
    self.posterImageView = posterImageView;
    self.shadowView = shadowView;
    self.contentLabel = contentLabel;
}

- (void)setupData:(NSDictionary *)msgDict preData:(NSDictionary *)previousDict {
    
    NSString *createtime = [self displaytime:previousDict[@"createtime"] currenttime:msgDict[@"createtime"]];
    
    BOOL displaytime = createtime;
    BOOL me = ([msgDict[@"action"] intValue] == 1);
    
    self.timeLabel.hidden = !displaytime;
    
    if (me) {
        
        if (displaytime) {
            
            [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView).mas_offset(0);
                make.centerX.mas_equalTo(self.contentView);
                make.height.mas_equalTo(20);
            }];
            [self.posterImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView).mas_offset(-10);
                make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(10);
                make.width.height.mas_equalTo(40);
                make.bottom.mas_lessThanOrEqualTo(self.contentView).mas_offset(-10);
            }];
        } else {

            [self.posterImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView).mas_offset(-10);
                make.top.mas_equalTo(self.contentView).mas_offset(10);
                make.width.height.mas_equalTo(40);
                make.bottom.mas_lessThanOrEqualTo(self.contentView).mas_offset(-10);
            }];
        }
        [self.shadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.posterImageView.mas_left).mas_offset(-10);
            make.top.mas_equalTo(self.posterImageView).mas_offset(5);
            make.left.mas_greaterThanOrEqualTo(self.contentView).mas_offset(10);
            make.bottom.mas_lessThanOrEqualTo(self.contentView).mas_offset(-10);
        }];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.shadowView).mas_offset(5);
            make.top.mas_equalTo(self.shadowView).mas_offset(5);
            make.right.mas_equalTo(self.shadowView).mas_offset(-5);
            make.bottom.mas_equalTo(self.shadowView).mas_offset(-5);
        }];
    } else {
        
        if (displaytime) {
            
            [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView).mas_offset(0);
                make.centerX.mas_equalTo(self.contentView);
                make.height.mas_equalTo(20);
            }];
            [self.posterImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).mas_offset(10);
                make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(10);
                make.width.height.mas_equalTo(40);
                make.bottom.mas_lessThanOrEqualTo(self.contentView).mas_offset(-10);
            }];
        } else {
            
            [self.posterImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).mas_offset(10);
                make.top.mas_equalTo(self.contentView).mas_offset(10);
                make.width.height.mas_equalTo(40);
                make.bottom.mas_lessThanOrEqualTo(self.contentView).mas_offset(-10);
            }];
        }
        [self.shadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.posterImageView.mas_right).mas_offset(10);
            make.top.mas_equalTo(self.posterImageView).mas_offset(5);
            make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-10);
            make.bottom.mas_lessThanOrEqualTo(self.contentView).mas_offset(-10);
        }];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.shadowView).mas_offset(5);
            make.top.mas_equalTo(self.shadowView).mas_offset(5);
            make.right.mas_equalTo(self.shadowView).mas_offset(-5);
            make.bottom.mas_equalTo(self.shadowView).mas_offset(-5);
        }];
    }
    
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:msgDict[me?@"me_poster":@"other_poster"]] placeholderImage:[UIImage imageNamed:@"poster"]];
    
    self.timeLabel.text = createtime;
    
    self.contentLabel.text = msgDict[@"content"];
}

- (NSString *)displaytime:(NSString *)previoustime currenttime:(NSString *)currenttime {
    
    NSString *displaytime;
    NSDate *nowDate = [NSDate date];
    NSDate *currentDate = [ConversionUtil dateFromString:currenttime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if (previoustime) {
        
        NSDate *previousDate = [ConversionUtil dateFromString:previoustime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
        double previousTimeInterval = [nowDate timeIntervalSinceDate:previousDate];
        double currentTimeInterval = [nowDate timeIntervalSinceDate:currentDate];
        
        // 一分钟以内
        if ((previousTimeInterval - currentTimeInterval) <= 60) {
            
            return nil;
        }
    }
        
    NSString *nowDay = [ConversionUtil stringFromDate:nowDate dateFormat:@"yyyy-MM-dd"];
    NSString *nowYear = [ConversionUtil stringFromDate:nowDate dateFormat:@"yyyy"];
    
    if ([currenttime hasPrefix:nowDay]) {

        displaytime = [ConversionUtil stringFromDate:currentDate dateFormat:@"HH:mm"];
    } else if ([currenttime hasPrefix:nowYear]) {
        
        displaytime = [ConversionUtil stringFromDate:currentDate dateFormat:@"M/d HH:mm"];
    } else {
        
        displaytime = [ConversionUtil stringFromDate:currentDate dateFormat:@"yyyy/M/d HH:mm"];
    }
    
    return displaytime;
}

@end
