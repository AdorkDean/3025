//
//  DatabaseUtil.h
//  3025
//
//  Created by ld on 2017/3/29.
//
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DatabaseUtil : NSObject

/**
 *  本地缓存，网络请求数据
 *
 *  @param response 网络请求数据
 *  @param url      网络请求url
 *
 *  @return 缓存结果
 */
+ (BOOL)cacheResponse:(NSString *)response forURL:(NSString *)url;

/**
 *  获取本地缓存
 *
 *  @param url      网络请求url
 *  @param duration 本地缓存有效期，超过有效期返回nil
 *
 *  @return 本地缓存的网络数据
 */
+ (NSString *)response:(NSString *)url effective:(NSUInteger)duration;

@end
