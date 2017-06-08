//
//  NSObject+JSONEntity.h
//  TTSCacher
//
//  Created by 李正兵 on 2017/6/7.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTSJSONEntityElementProtocol.h"
#import "TTSJSONEntityPropertyProtocol.h"

@interface NSObject (JSONEntity)<TTSJSONEntityElementProtocol,TTSJSONEntityPropertyProtocol>
/** 获取当前对象的属性集合 */
- (NSDictionary *)propertyDictionary;
/** 根据数据集合生成对象 */
+ (id)objectWithDictionary:(NSDictionary *)dictionary;
+ (id)objectWithArray:(NSArray *)array;

/** 获取类属性列表，不包含父类 */
+ (NSArray *)propertyNames;
/** 属性列表截止自己设置的类，一般cls传入类的superClass */
+ (NSArray *)propertyNamesUntilClass:(Class)cls;
/** 每获取propertyName运行Block一次 */
+ (NSArray *)propertyNamesUntilClass:(Class)cls usingBlock:(void (^)(NSString *propertyName))block;
@end
