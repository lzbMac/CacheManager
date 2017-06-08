//
//  NSData-AES.h
//  Encryption
//
//  Created by Jeff LaMarche on 2/12/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

// Supported keybit values are 128, 192, 256
//#define KEYBITS		256
typedef enum {
	eKeyBits128 = 0,
	eKeyBits192,
	eKeyBits256
} AESKeyBits;

@interface NSData(AES)
- (NSData *)tcc_AESEncryptWithPassphrase:(NSString *)pass keybits:(AESKeyBits)kbs;
- (NSData *)tcc_AESDecryptWithPassphrase:(NSString *)pass keybits:(AESKeyBits)kbs;

- (NSData*)tcc_AES128EncryptWithKey:(NSString*)key initVector:(NSData*)iv;
- (NSData*)tcc_AES128DecryptWithKey:(NSString*)key initVector:(NSData*)iv;
@end