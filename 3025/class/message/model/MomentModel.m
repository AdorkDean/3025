//
//  MomentModel.m
//  3025
//
//  Created by ld on 2017/5/27.
//
//

#import "MomentModel.h"
#import "MJExtension.h"
#import "ConversionUtil.h"

@implementation MomentModel

- (void)setCreatetime:(NSString *)createtime {
    _createtime = createtime;
    if (_createtime) {
        double second = 1;
        double minite = (60 * second);
        double hour = (60 * minite);
        double day = (24 * hour);
        double month = (31 * day);

        NSDate *momentDate = [ConversionUtil dateFromString:_createtime dateFormat:@"yyyy/MM/dd HH:mm:ss"];
        double timeInterval = [[NSDate date] timeIntervalSinceDate:momentDate];
        
        if (timeInterval <= minite) {
            _displaytime = @"刚刚";
        } else if (timeInterval <= hour) {
            _displaytime = [NSString stringWithFormat:@"%d分钟前", (int)(timeInterval / minite)];
        } else if (timeInterval <= day) {
            _displaytime = [NSString stringWithFormat:@"%d小时前", (int)(timeInterval / hour)];
        } else if (timeInterval <= month) {
            _displaytime = [NSString stringWithFormat:@"%d天前", (int)(timeInterval / day)];
        } else {
            _displaytime = [ConversionUtil stringFromDate:momentDate dateFormat:@"yyyy/M/d"];
        }
    }
}

@end
