//
//  TTSJSONEntityPropertyProtocol.h
//  TTSCacher
//
//  Created by 李正兵 on 2017/6/7.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTSJSONEntityPropertyProtocol <NSObject>
@optional
/** 获取到指定父类的属性列表 */
- (Class)ownPropertysUntilClass;

@end
