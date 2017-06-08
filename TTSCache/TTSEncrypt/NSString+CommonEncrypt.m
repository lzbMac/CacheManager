//
//  NSString+CommonEncrypt.m
//  TTSCacher
//
//  Created by 李正兵 on 2017/6/7.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import "NSString+CommonEncrypt.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData-AES.h"
#import "TTSEncryptDefine.h"
#import "NSData+CommonEncrypt.h"

@implementation NSString (CommonEncrypt)
- (NSString *)md5 {
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

- (NSString *)base64 {
    NSData *data = [self dataUsingEncoding:NSASCIIStringEncoding];
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}
- (NSData *)base64Decode {
    NSString *string = self;
    return [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

- (NSData *)aesVector {
    if (self.length < 16) { return nil; }
    static char AES_IV[16];
    memcpy(AES_IV, [self cStringUsingEncoding:NSASCIIStringEncoding], [self length]);
    return [NSData dataWithBytes:AES_IV length:sizeof(AES_IV)];
}

- (NSString *)AESEncryptAndBase64Encode {
    return [self AESEncryptAndBase64EncodeWithKey:TTSDefaultAESKey];
}

- (NSString *)AESDecryptAndBase64Decode {
    return [self AESDecryptAndBase64DecodeWithKey:TTSDefaultAESKey];
}

- (NSString *)AESEncryptAndBase64EncodeWithKey:(NSString *)key {
    NSString *aeskey = key ?: TTSDefaultAESKey;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *iv = [NSData dataWithBytes:AES_IV length:sizeof(AES_IV)];
    NSData *encrypt = [data tcc_AES128EncryptWithKey:aeskey initVector:iv];
    NSString *secret = nil;
    if (encrypt) secret = [encrypt base64];
    return [secret stringByReplacingOccurrencesOfString:@"\\" withString:@""];
}

- (NSString *)AESDecryptAndBase64DecodeWithKey:(NSString *)key {
    NSString *aeskey = key ?: TTSDefaultAESKey;
    NSData *data = [self base64Decode];
    NSData *iv = [NSData dataWithBytes:AES_IV length:sizeof(AES_IV)];
    NSData *decrypt = [data tcc_AES128DecryptWithKey:aeskey initVector:iv];
    NSString *secret = nil;
    if (decrypt) secret = [[NSString alloc] initWithData:decrypt encoding:NSUTF8StringEncoding];
    return secret;
}

- (NSString*)sha1 {
    const char* string = [self UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];   // 20
    CC_SHA1(string, @(strlen(string)).unsignedIntValue, result);
    NSString* hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15],
                      result[16], result[17], result[18], result[19]];
    
    return [hash lowercaseString];
}

- (NSData*)sha1_data {
    const char* string = [self UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];   // 20
    CC_SHA1(string, @(strlen(string)).unsignedIntValue, result);
    NSData *data = [NSData dataWithBytes:result length:20];
    return data;
}

@end
