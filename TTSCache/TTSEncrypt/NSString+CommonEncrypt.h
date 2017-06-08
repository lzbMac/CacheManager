//
//  NSString+CommonEncrypt.h
//  TTSCacher
//
//  Created by 李正兵 on 2017/6/7.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CommonEncrypt)
#pragma mark - MD5
/** 字符串的MD5 */
- (NSString *)md5;

#pragma mark - BASE64
/** 加密为base64 */
- (NSString *)base64;
/** 解密base64 */
- (NSData *)base64Decode;

#pragma mark - AES
/** 转aes128向量Data */
- (NSData *)aesVector;

/** aes128加密后转换为base64，使用默认Key，默认Iv */
- (NSString *)AESEncryptAndBase64Encode;
/** aes128加密后转换为base64，使用默认Iv */
- (NSString *)AESEncryptAndBase64EncodeWithKey:(NSString *)key;

/** 解密base64并解密aes128，使用默认Key，默认Iv */
- (NSString *)AESDecryptAndBase64Decode;
/** 解密base64并解密aes128，使用默认Iv */
- (NSString *)AESDecryptAndBase64DecodeWithKey:(NSString *)key;

#pragma mark - SHA1
/** return the sha1 digest of the string */
- (NSString*)sha1;

/** return the sha1 digest of the data */
- (NSData*)sha1_data;

@end
