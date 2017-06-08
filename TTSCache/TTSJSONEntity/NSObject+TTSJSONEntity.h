//
//  NSObject+TTSJSONEntity.h
//  TTSCacher
//
//  Created by 李正兵 on 2017/6/7.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTSJSONEntityPropertyProtocol.h"
#import "TTSJSONEntityElementProtocol.h"

@interface NSObject (TTSJSONEntity)<TTSJSONEntityElementProtocol, TTSJSONEntityPropertyProtocol>
/** 获取当前对象的属性集合 */
- (NSDictionary *)tts_propertyDictionary;

/**
 *  根据数据集合&类型，获取对象
 *
 *  @param dictionary 数据集合
 *
 *  @return 对象实例
 */
+ (id)tts_objectWithDictionary:(id)dictionary;

/** 获取当前对象的属性列表，截至NSObject */
+ (NSArray *)tts_propertyNamesUntilClass:(Class)cls usingBlock:(void (^)(NSString *propertyName, NSString *propertyType))block;

@end
