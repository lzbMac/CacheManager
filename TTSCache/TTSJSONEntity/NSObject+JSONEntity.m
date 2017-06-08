//
//  NSObject+JSONEntity.m
//  TTSCacher
//
//  Created by 李正兵 on 2017/6/7.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import "NSObject+JSONEntity.h"
#import "NSObject+TTSJSONEntity.h"

@implementation NSObject (JSONEntity)
- (NSDictionary *)propertyDictionary
{
    return [self tts_propertyDictionary];
}

+ (id)objectWithDictionary:(NSDictionary *)dictionary
{
    return [self tts_objectWithDictionary:dictionary];
}

+ (id)objectWithArray:(NSArray *)array
{
    NSMutableArray *ret_Array = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id dict, NSUInteger idx, BOOL *stop) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            id obj = [self objectWithDictionary:dict];
            if (obj) [ret_Array addObject:obj];
        } else {
            [ret_Array removeAllObjects];
            [ret_Array addObjectsFromArray:array];
            *stop = YES;
        }
    }];
    return ret_Array;
}

+ (NSArray *)propertyNames
{
    return [self propertyNamesUntilClass:[self class]];
}

+ (NSArray *)propertyNamesUntilClass:(Class)cls
{
    return [self propertyNamesUntilClass:cls usingBlock:nil];
}

+ (NSArray *)propertyNamesUntilClass:(Class)cls usingBlock:(void (^)(NSString *propertyName))block
{
    return [self tts_propertyNamesUntilClass:cls usingBlock:^(NSString *propertyName, NSString *propertyType) {
        if (block) block(propertyName);
    }];
}

@end
