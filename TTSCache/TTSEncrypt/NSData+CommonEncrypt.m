//
//  NSData+CommonEncrypt.m
//  TTSCacher
//
//  Created by 李正兵 on 2017/6/7.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import "NSData+CommonEncrypt.h"
#import "NSData-AES.h"
#import "TTSEncryptDefine.h"

@implementation NSData (CommonEncrypt)

- (NSString *)base64 {
    NSData *data = self;
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

- (NSData *)AESEncrypt {
    return [self tcc_AES128EncryptWithKey:TTSDefaultAESKey initVector:[NSData dataWithBytes:AES_IV length:sizeof(AES_IV)]];
}
- (NSData *)AESDecrypt {
    return [self tcc_AES128DecryptWithKey:TTSDefaultAESKey initVector:[NSData dataWithBytes:AES_IV length:sizeof(AES_IV)]];
}

- (NSData *)AESEncryptWithKey:(NSString *)key initVector:(NSData *)iv {
    return [self tcc_AES128EncryptWithKey:key initVector:iv];
}
- (NSData *)AESDecryptWithKey:(NSString *)key initVector:(NSData *)iv {
    return [self tcc_AES128DecryptWithKey:key initVector:iv];
}

@end
