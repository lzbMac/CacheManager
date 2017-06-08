//
//  NSObject+TTSJSONEntity.m
//  TTSCacher
//
//  Created by 李正兵 on 2017/6/7.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import "NSObject+TTSJSONEntity.h"
#import <objc/runtime.h>

@implementation NSObject (TTSJSONEntity)
#pragma mark - 根据数据集合&类型，获取对象
+ (id)tts_objectWithDictionary:(NSDictionary *)dictionary
{
    if (![dictionary isKindOfClass:[NSDictionary class]]) return nil;
    Class rspClass = [self class];
    id responseObject = [[rspClass alloc] init];
    
    NSAssert(responseObject, @"ttS_对象创建失败:验证%@类是否存在或@implementation是否实现", NSStringFromClass(rspClass));
    
    if ([dictionary count] <= 0) return responseObject;
    [rspClass tts_propertyNamesUntilClass:[NSObject class] usingBlock:^(NSString *propertyName, NSString *propertyType) {
        id propertyValue = dictionary[propertyName];
        if (propertyValue) {
            if ([propertyValue isKindOfClass:[NSDictionary class]]) {
                id propertyObject = nil;
                NSString *propertyClassName = nil;
                if ([self respondsToSelector:@selector(replacedElementDictionary)]) {
                    NSDictionary *replacedDictionary = [self performSelector:@selector(replacedElementDictionary)];
                    propertyClassName = replacedDictionary[propertyName];
                }
                propertyClassName = propertyClassName ?: propertyType;
                if (propertyClassName) {
                    Class cls = NSClassFromString(propertyClassName);
                    if ([cls isSubclassOfClass:[NSDictionary class]]) { propertyObject = propertyValue; }
                    else { propertyObject = cls ? [cls tts_objectWithDictionary:propertyValue] : propertyValue; }
                }
                else {  //propertyType为nil代表类型可能是id
                    Class cls = NSClassFromString(propertyName);
                    propertyObject = cls ?[cls tts_objectWithDictionary:propertyValue] : propertyValue;
                }
                [responseObject setValue:propertyObject forKey:propertyName];
            }
            else if ([propertyValue isKindOfClass:[NSArray class]]) {
                NSString *propertyClassName = nil;
                if ([self respondsToSelector:@selector(replacedElementDictionary)]) {
                    NSDictionary *replacedDictionary = [self performSelector:@selector(replacedElementDictionary)];
                    propertyClassName = replacedDictionary[propertyName];
                }
                propertyClassName = propertyClassName ?: propertyName;
                Class cls = NSClassFromString(propertyClassName);
                id propertyObject = cls ? [cls p_tts_objectWithArray:propertyValue] : propertyValue;
                [responseObject setValue:propertyObject forKey:propertyName];
            }
            else if ([propertyValue isKindOfClass:[NSNull class]]) { }
            else {
                [responseObject setValue:propertyValue forKey:propertyName];
            }
        }
    }];
    return responseObject;
}

+ (id)p_tts_objectWithArray:(NSArray *)array
{
    NSMutableArray *propertyArray = [NSMutableArray array];
    if ([array isKindOfClass:[NSArray class]]) {
        for (id obj in array) {
            id propertyValue = nil;
            if ([obj isKindOfClass:[NSDictionary class]]) {
                propertyValue = [self tts_objectWithDictionary:obj];
            }
            else if ([obj isKindOfClass:[NSArray class]]) {
                propertyValue = [self p_tts_objectWithArray:obj];
            }
            else propertyValue = obj;
            if (propertyValue) [propertyArray addObject:propertyValue];
        }
    }
    return propertyArray;
}

#pragma mark - 获取当前对象的属性集合
- (NSDictionary *)tts_propertyDictionary
{
    __block NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    Class cls = Nil;
    if ([((id<TTSJSONEntityPropertyProtocol>)self) respondsToSelector:@selector(ownPropertysUntilClass)]) {
        cls = [((id<TTSJSONEntityPropertyProtocol>)self) ownPropertysUntilClass];
    }
    if (!cls) cls = [self class];
    [[self class] tts_propertyNamesUntilClass:cls usingBlock:^(NSString *propertyName, NSString *propertyType) {
        id propertyValue = [self valueForKey:propertyName];
        if(propertyValue) {
            id value = nil;
            if ([propertyValue isKindOfClass:[NSObject class]]) {
                if ([propertyValue isKindOfClass:[NSArray class]]) {
                    value = [propertyValue p_tts_propertyArray];
                }
                else if ([propertyValue isKindOfClass:[NSDictionary class]]) {
                    value = [propertyValue p_tts_propertyDictionary];
                }
                else if ([propertyValue isKindOfClass:[NSNumber class]] ||
                         [propertyValue isKindOfClass:[NSString class]] ||
                         [propertyValue isKindOfClass:[NSNull class]]) {
                    value = propertyValue;
                }
                else {
                    value = [propertyValue tts_propertyDictionary];
                }
            }
            if (value) [dictionary setValue:value forKey:propertyName];
        }
    }];
    return dictionary;
}

- (NSDictionary *)p_tts_propertyDictionary
{
    __block NSMutableDictionary *propertyDictionary = [NSMutableDictionary dictionary];
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary *)self];
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            id propertyValue = [self tts_propertyValueWithObject:obj];
            if (propertyValue) [propertyDictionary setObject:propertyValue forKey:key];
        }];
    }
    return propertyDictionary;
}

- (NSArray *)p_tts_propertyArray
{
    __block NSMutableArray *propertyArray = [NSMutableArray array];
    if ([self isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)self;
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id propertyValue = [self tts_propertyValueWithObject:obj];
            if (propertyValue) [propertyArray addObject:propertyValue];
        }];
    }
    return propertyArray;
}

- (id)tts_propertyValueWithObject:(id)obj
{
    id propertyValue = nil;
    if ([obj isKindOfClass:[NSArray class]]) {
        propertyValue = [obj p_tts_propertyArray];
    }
    else if ([obj isKindOfClass:[NSDictionary class]]) {
        propertyValue = [obj p_tts_propertyDictionary];
    }
    else if ([obj isKindOfClass:[NSString class]] ||
             [obj isKindOfClass:[NSNumber class]]) {
        propertyValue = obj;
    }
    else {
        propertyValue = [obj tts_propertyDictionary];
    }
    return propertyValue;
}

#pragma mark - 对象的属性列表
+ (NSArray *)tts_propertyNamesUntilClass:(Class)sCls usingBlock:(void (^)(NSString *propertyName, NSString *propertyType))block
{
    Class cls = [self class];
    NSMutableArray *mArray = [NSMutableArray array];
    while ((cls != [NSObject class]) && (cls != [sCls superclass])) {
        unsigned propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
        for ( int i = 0 ; i < propertyCount ; i++ ) {
            objc_property_t property = properties[i];
            const char *propertyAttributes = property_getAttributes(property);
            BOOL isReadWrite = (strstr(propertyAttributes, ",V") != NULL);
            if (isReadWrite) {
                NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
                if (propertyName) [mArray addObject:propertyName];
                NSString *propertyType = nil;
                char *propertyAttributeValue = property_copyAttributeValue(property, "T");
                if ((propertyAttributeValue != NULL) && (propertyAttributeValue[0] == '@') && (strlen(propertyAttributeValue) >= 3)) {
                    char *cString = strndup(propertyAttributeValue+2, strlen(propertyAttributeValue)-3);
                    propertyType = [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
                    free(cString);
                }
                free(propertyAttributeValue);
                if (block) block(propertyName, propertyType);
            }
        }
        cls = [cls superclass];
        free(properties);
    }
    return mArray;
}

@end
