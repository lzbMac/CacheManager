//
//  NSData+CommonEncrypt.h
//  TTSCacher
//
//  Created by 李正兵 on 2017/6/7.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CommonEncrypt)

#pragma mark - BASE64
/** data转为base64字符串 */
- (NSString *)base64;

#pragma mark - AES
/** aes128加密，使用默认Key，默认Iv */
- (NSData *)AESEncrypt;
/** 解密aes128，使用默认Key，默认Iv */
- (NSData *)AESDecrypt;

/** 对当前data进行AES加密 */
- (NSData *)AESEncryptWithKey:(NSString *)key initVector:(NSData *)iv;
/** AES解密 */
- (NSData *)AESDecryptWithKey:(NSString *)key initVector:(NSData *)iv;

@end
