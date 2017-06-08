//
//  TTSCacheStoreObject.h
//  TTSCacher
//
//  Created by 李正兵 on 2017/6/7.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, TTSCacheStorageObjectTimeOutInterval) {
    TTSCacheStorageObjectIntervalDefault,
    TTSCacheStorageObjectIntervalTiming,     //定时
    TTSCacheStorageObjectIntervalAllTime     //永久
};

@interface TTSCacheStoreObject : NSObject<NSCoding>
/** 数据String */
@property (nonatomic, copy, readonly) NSString *storageString;
/** 数据类名 */
@property (nonatomic, strong, readonly) id storageObject;
/** 数据的存储时效性 */
@property (nonatomic, assign, readonly) TTSCacheStorageObjectTimeOutInterval storageInterval;

/** 当前对象的标识符（KEY），默认会自动生成，可自定义*/
@property (nonatomic, copy) NSString *objectIdentifier;

/** 存储文件的过期时间
 *  -1表示永久文件，慎用 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/** 根据（String,URL,Data,Number,Dictionary,Array,Null,实体）初始化对象 */
- (instancetype)initWithObject:(id)object;

@end
