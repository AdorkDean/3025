//
//  DatabaseUtil.m
//  3025
//
//  Created by ld on 2017/3/29.
//
//

#import "DatabaseUtil.h"

@implementation DatabaseUtil

static FMDatabaseQueue *dbQueue;

+ (void)initialize {
    
    dbQueue = [FMDatabaseQueue databaseQueueWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"3025.sqlite"]];
    [self createtable];
}

+ (void)createtable {
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = @"create table if not exists responseCache(url varchar(255), response text, createtime integer)";
        [db executeUpdate:sql];
    }];
}

/**
 *  本地缓存，网络请求数据
 *
 *  @param response 网络请求数据
 *  @param url      网络请求url
 *
 *  @return 缓存结果
 */
+ (BOOL)cacheResponse:(NSString *)response forURL:(NSString *)url {
    
    __block BOOL result = true;
    
    [dbQueue inDatabase:^(FMDatabase *db) {

        result = [db executeUpdateWithFormat:@"delete from responseCache where url = '%@'", url];
        result = [db executeUpdateWithFormat:@"insert into responseCache(url, response, createtime) values(%@, %@, %@)", url, response, [NSDate date]];
    }];
    
    return result;
}

/**
 *  获取本地缓存
 *
 *  @param url      网络请求url
 *  @param duration 本地缓存有效期(秒)，超过有效期返回nil
 *
 *  @return 本地缓存的网络数据
 */
+ (NSString *)response:(NSString *)url effective:(NSUInteger)duration {
    
    __block NSString *response;
    NSUInteger effectivetime = [[NSDate date] timeIntervalSince1970] - duration * 1000;

    [dbQueue inDatabase:^(FMDatabase *db) {

//      FMResultSet *resultSet = [db executeQueryWithFormat:@"select * from responseCache where url = '%@' and createtime > %ld", url, effectivetime];
        FMResultSet *resultSet = [db executeQueryWithFormat:@"select * from responseCache where url = '%@'", url];
        if ([resultSet next]) {

            response = [resultSet stringForColumn:@"response"];
            NSLog(@"*** %ld, %ld, %@ ***", effectivetime, [resultSet longForColumn:@"createtime"], url);
        }
    }];
    
    return response;
}

@end