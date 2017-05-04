//
//  HttpUtil.m
//  3025
//
//  Created by ld on 2017/5/4.
//
//

#import "HttpUtil.h"
#import "AFNetworking.h"

@interface HttpUtil () {

}

@end

@implementation HttpUtil

+ (void)query:(NSString *)url
    parameter:(NSDictionary *)parameterDict
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *httpSessionManager = [AFHTTPSessionManager manager];
    httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [httpSessionManager POST:url parameters:parameterDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }
    }];
}

@end
