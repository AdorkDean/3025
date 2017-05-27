//
//  ConversionUtil.m
//  3025
//
//  Created by ld on 2017/5/4.
//
//

#import "ConversionUtil.h"
#import "Constant.h"

@interface ConversionUtil () {

}

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ConversionUtil

- (instancetype)init {
    if (self = [super init]) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
    }
    return self;
}

+ (ConversionUtil *)util {
    
    static dispatch_once_t predicate;
    static ConversionUtil *util;
    
    dispatch_once(&predicate, ^{
        util = [[ConversionUtil alloc] init];
    });
    
    return util;
}

+ (NSString *)activityCategory:(NSString *)code {
    
    if (code.length == 4) {
        NSString *prefix = [code substringWithRange:NSMakeRange(0, 2)];
        NSString *suffix = [code substringWithRange:NSMakeRange(2, 2)];
        return kActivityCategorys[prefix.intValue][suffix.intValue];
    }
    
    return code;
}

+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat {
    
    NSDateFormatter *dateFormatter = [ConversionUtil util].dateFormatter;
    dateFormatter.dateFormat = dateFormat;

    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)str dateFormat:(NSString *)dateFormat {
    
    NSDateFormatter *dateFormatter = [ConversionUtil util].dateFormatter;
    dateFormatter.dateFormat = dateFormat;
    
    return [dateFormatter dateFromString:str];
}

+ (BOOL)isEmpty:(NSString *)str {
    if (!str) {
        return YES;
    }
    return ([str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0);
}


+ (BOOL)isNotEmpty:(NSString *)str {
    if (!str) {
        return NO;
    }
    return ([str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0);
}

@end
