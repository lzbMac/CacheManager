//
//  TTSCacheStorage.h
//  TTSCacher
//
//  Created by 李正兵 on 2017/6/7.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTSCacheStoreObject.h"

extern NSString * TTSCacheStorageDefaultFinderName;

typedef NS_ENUM(NSUInteger, TTSCacheStorageType) {
    TTSCacheStorageCache         = 0,    //Memory
    TTSCacheStorageArchiver
};
@interface TTSCacheStorage : NSObject
/** 空间，suiteName以.document结尾则数据保存至Document */
@property (nonatomic, strong) NSString *suiteName;

+ (instancetype)defaultStorage;

/** TTSCacheStorageType默认为TTSCacheStorageArchiver */
- (void)setObject:(TTSCacheStoreObject *)aObject forKey:(NSString *)aKey;
- (void)setObject:(TTSCacheStoreObject *)aObject forKey:(NSString *)aKey type:(TTSCacheStorageType)t;

- (TTSCacheStoreObject *)objectForKey:(NSString *)aKey;

- (void)removeObjectForKey:(NSString *)aKey;

//删除所有的默认文件，常用方法
- (void)removeDefaultObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock;
//删除过期的文件
- (void)removeExpireObjects;

/** 对所有空间做操作 */
/** 删除所有的默认文件，谨慎操作 */
+ (void)removeDefaultObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock;
/** 删除过期的文件，谨慎操作 */
+ (void)removeExpireObjects;
@end
