//
//  QiniuUtil.m
//  3025
//
//  Created by ld on 2017/5/24.
//
//

#import "QiniuUtil.h"
#import "QiniuSDK.h"
#import "MJExtension.h"
#import "ConversionUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

#define kAccessKey @"472jehVqzM6ug9DT_MX6jIXitXWruC6mFlcp9IXS"
#define kSecretKey @"v9rM1s-EtvEG3gnC00myMxN9QGxvTcm57P2ZDZjd"
#define kScope @"3025"
#define kDeadline @"2020/01/01 00:00:00"
#define kDomain @"http://oqauefc7p.bkt.clouddn.com/"

@implementation QiniuUtil

+ (void)upload:(NSData *)uploadData key:(NSString *)filename {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    // 获取界面输入数据
    NSString *accessKey = kAccessKey;
    NSString *secretKey = kSecretKey;
    NSString *key       = filename;
    NSString *scope     = kScope;
    NSString *deadline  = kDeadline;
    
    // scope
    scope = [NSString stringWithFormat:@"%@:%@", scope, key];
    
    // deadline
    NSDate *date = [dateFormatter dateFromString:deadline];
    deadline = [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]];
    
    // 要上传的图片
    NSData *data = uploadData;
    
    // 上传策略  注意：deadline是Unix时间戳，一定不能设置成NSString型
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:scope forKey:@"scope"];
    [dict setValue:[NSNumber numberWithInteger:[deadline integerValue]] forKey:@"deadline"];
    
    NSString *putPolicy = [dict mj_JSONString];
    
    // 上传token
    NSString *token = [QiniuUtil uploadTokenWithPutPolicy:putPolicy accessKey:accessKey secretKey:secretKey];
    // 上传
    QNUploadOption *option = nil;
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@" *** upload: %@ *** ", resp);
    } option:option];
}

/*!
 *    @brief 生成七牛上传Token
 *
 *    @param putPolicy [上传策略](http://developer.qiniu.com/article/developer/security/upload-token.html)
 *    @param accessKey accessKey
 *    @param secretKey secretKey
 *
 *    @return 上传Token
 */
+ (NSString *)uploadTokenWithPutPolicy:(NSString *)putPolicy accessKey:(NSString *)accessKey secretKey:(NSString *)secretKey {
    
    NSString *uploadToken = nil;
    
    // base64 encode putPolicy
    NSData *putPolicyData = [putPolicy dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedPutPolicy = [putPolicyData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    // HMAC
    NSString *encodedSign = [self encrypt2HMAC:encodedPutPolicy key:secretKey];
    
    // qiniu uploadTpken
    uploadToken = [NSString stringWithFormat:@"%@:%@:%@", accessKey, encodedSign, encodedPutPolicy];
    
    return uploadToken;
}

/**
 *  HMAC加密
 *
 *  @param text text
 *  @param key  key
 *
 *  @return HMAC string
 */
+ (NSString *)encrypt2HMAC:(NSString *)text key:(NSString *)key {
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [text cStringUsingEncoding:NSASCIIStringEncoding];
    
    //sha1
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    // base64
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *hash = [HMAC base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    return hash;
}

@end
