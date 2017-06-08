//
//  TTSCacheManager.m
//  TTSCacher
//
//  Created by 李正兵 on 2017/6/7.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import "TTSCacheManager.h"
#import "TTSCacheStorage.h"

NSString * const TTSCacheManagerObject = @"TTSCacheManagerObject";
NSString * const TTSCacheManagerSetObjectNotification = @"TTSCacheManagerSetObjectNotification";
NSString * const TTSCacheManagerGetObjectNotification = @"TTSCacheManagerGetObjectNotification";
NSString * const TTSCacheManagerRemoveObjectNotification = @"TTSCacheManagerRemoveObjectNotification";

@interface TTSCacheManager ()

@property (nonatomic, strong) NSString *suiteName;
@property (nonatomic, strong) TTSCacheStorage *fileStorage;

@end

@implementation TTSCacheManager
+ (TTSCacheManager *)defaultManager {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = self.new; });
    return instance;
}

- (instancetype)initWithSuiteName:(NSString *)suitename {
    if (self = [self init]) {
        self.suiteName = suitename;
    }
    return self;
}

- (TTSCacheStorage *)fileStorage {
    return _fileStorage ?: ({ TTSCacheStorage *fileStorage = TTSCacheStorage.new; fileStorage.suiteName = self.suiteName; _fileStorage = fileStorage; });
}

#pragma mark -
- (void)setObject:(id)aObject forKey:(NSString *)aKey {
    [self setObject:aObject forKey:aKey duration:0];
}
- (void)setObject:(id)aObject forKey:(NSString *)aKey duration:(NSTimeInterval)duration {
    if (!aKey) return;
    if (!aObject) {
        [self removeObjectForKey:aKey]; return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:TTSCacheManagerSetObjectNotification object:@{TTSCacheManagerObject:@{aKey : aObject}}];
    TTSCacheStoreObject *object = [[TTSCacheStoreObject alloc] initWithObject:aObject];
    object.timeoutInterval = duration;
    if (object.storageString) [self.fileStorage setObject:object forKey:aKey];
}

- (void)setObject:(id)aObject forKey:(NSString *)aKey toDisk:(BOOL)toDisk {
    if (!aKey) return;
    if (!aObject) {
        [self removeObjectForKey:aKey]; return;
    }
    if (toDisk) {
        [self setObject:aObject forKey:aKey];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:TTSCacheManagerSetObjectNotification object:@{TTSCacheManagerObject:@{aKey : aObject}}];
        TTSCacheStoreObject *object = [[TTSCacheStoreObject alloc] initWithObject:aObject];
        if (object.storageString) [self.fileStorage setObject:object forKey:aKey type:TTSCacheStorageCache];
    }
}

#pragma mark -
- (id)objectForKey:(NSString *)aKey {
    if (!aKey) return nil;
    TTSCacheStoreObject *object = [self.fileStorage objectForKey:aKey];
    id returnObject = [object storageObject];
    if (!returnObject) return nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:TTSCacheManagerGetObjectNotification object:@{TTSCacheManagerObject:@{aKey : returnObject}}];
    return returnObject;
}
/** 异步根据Key获取缓存对象 */
- (void)objectKey:(NSString *)aKey completion:(void (^)(id obj))block {
    if (!aKey) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id obj = [self objectForKey:aKey];
        if (block) dispatch_async(dispatch_get_main_queue(), ^{ block(obj); });
    });
}

#pragma mark -
- (void)removeObjectForKey:(NSString *)aKey {
    if (!aKey) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:TTSCacheManagerRemoveObjectNotification object:aKey];
    [self.fileStorage removeObjectForKey:aKey];
}

- (void)removeObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock {
    [self.fileStorage removeDefaultObjectsWithCompletionBlock:completionBlock];
}
- (void)removeExpireObjects {
    [self.fileStorage removeExpireObjects];
}

+ (void)removeObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock {
    [TTSCacheStorage removeDefaultObjectsWithCompletionBlock:completionBlock];
}
+ (void)removeExpireObjects {
    [TTSCacheStorage removeExpireObjects];
}

@end
