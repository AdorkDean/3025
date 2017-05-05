//
//  ConversionUtil.m
//  3025
//
//  Created by ld on 2017/5/4.
//
//

#import "ConversionUtil.h"
#import "Constant.h"

@interface ConversionUtil ()

@end

@implementation ConversionUtil

+ (NSString *)activityCategory:(NSString *)code {
    
    if (code.length == 4) {
        NSString *prefix = [code substringWithRange:NSMakeRange(0, 2)];
        NSString *suffix = [code substringWithRange:NSMakeRange(2, 2)];
        return kActivityCategorys[prefix.intValue][suffix.intValue];
    }
    
    return code;
}

@end
