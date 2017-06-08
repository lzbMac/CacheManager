//
//  NSJSONSerialization+PublicJSONString.m
//  TTSCacher
//
//  Created by 李正兵 on 2017/6/7.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import "NSJSONSerialization+PublicJSONString.h"

@implementation NSJSONSerialization (PublicJSONString)
+ (NSString *)stringWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError **)error {
    NSData *JSONData = [self dataWithJSONObject:obj options:opt error:error];
    NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    return JSONString;
}

//NSJSONReadingAllowFragments
+ (id)objectWithJSONString:(NSString *)string options:(NSJSONReadingOptions)opt error:(NSError **)error {
    NSData *JSONData = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:JSONData options:opt error:error];
}

@end
