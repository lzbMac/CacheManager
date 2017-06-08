//
//  MFSJSONEntityElementProtocol.h
//  TTSCacher
//
//  Created by 李正兵 on 2017/6/7.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTSJSONEntityElementProtocol <NSObject>
@optional
/*  帮助你快速设置JSON和对象属性的映射表(解决接口返回相同对象的问题)
 key:   JSON字段命名
 value: 客户端对象命名
 */
+ (NSDictionary *)replacedElementDictionary;

@end
