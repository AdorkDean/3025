//
//  ConversionUtil.h
//  3025
//
//  Created by ld on 2017/5/4.
//
//

#import <Foundation/Foundation.h>

@interface ConversionUtil : NSObject

+ (NSString *)activityCategory:(NSString *)code;
+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;
+ (NSDate *)dateFromString:(NSString *)str dateFormat:(NSString *)dateFormat;

@end
