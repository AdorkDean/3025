//
//  MessageModel.m
//  3025
//
//  Created by ld on 2017/5/4.
//
//

#import "MessageModel.h"

@interface MessageModel () {

}

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSString *today;
@property (nonatomic, strong) NSString *yestoday;

@end

@implementation MessageModel

- (void)setCreatetime:(NSString *)createtime {

    if (createtime) {

        self.dateFormatter.dateFormat = @"yyyy/MM/dd";
        
        NSInteger timestamp = [createtime integerValue] / 1000;
        NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSString *messageDay = [self.dateFormatter stringFromDate:messageDate];

        if ([messageDay isEqualToString:self.today]) {

            self.dateFormatter.dateFormat = @"HH:mm";
            _createtime = [self.dateFormatter stringFromDate:messageDate];
        } else if ([messageDay isEqualToString:self.yestoday]) {

            _createtime = @"昨天";
        } else {
            
            self.dateFormatter.dateFormat = @"M/d";
            _createtime = [self.dateFormatter stringFromDate:messageDate];
        }
    }
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (NSString *)today {
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";
    return [self.dateFormatter stringFromDate:[NSDate date]];
}

- (NSString *)yestoday {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    dateComponents.day -= 1;
    NSDate *yestoday = [calendar dateFromComponents:dateComponents];
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";
    return [self.dateFormatter stringFromDate:yestoday];
}

@end
