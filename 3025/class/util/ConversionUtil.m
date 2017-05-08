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

@end

@implementation ConversionUtil

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

@end
