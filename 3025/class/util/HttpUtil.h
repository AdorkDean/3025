//
//  HttpUtil.h
//  3025
//
//  Created by ld on 2017/5/4.
//
//

#import <Foundation/Foundation.h>

@interface HttpUtil : NSObject

+ (void)query:(NSString *)url parameter:(NSDictionary *)parameterDict success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
