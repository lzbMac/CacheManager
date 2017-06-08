//
//  ViewController.m
//  CachLib
//
//  Created by 李正兵 on 2017/3/15.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import "ViewController.h"
#import "TTSCacheManager.h"
#import "NSObject+JSONEntity.h"

@interface Category: NSObject
@property (nonatomic, copy)NSString * cname;
@property (nonatomic, copy)NSString * gold;

@end

@implementation Category

@end

@interface StudentZZ : NSObject
@property (nonatomic, copy)NSString * name;

@property (nonatomic, assign)NSInteger sex;

@property (nonatomic, copy)NSString * className;

@property (nonatomic, strong)Category *cty;

@property (nonatomic, strong)NSArray<Category *> *arrCategory;

@end

@implementation StudentZZ

+ (NSDictionary *)replacedElementDictionary {
    //类名映射
    return @{@"arrCategory":@"Category"};
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StudentZZ *std = [StudentZZ new];
    std.name = @"lzb";
    std.sex = 1;
    std.className = @"one";
    
    Category *cty = [Category new];
    cty.cname = @"yuwen";
    cty.gold = @"80";
    std.cty = cty;
    
    Category *cty2 = [Category new];
    cty2.cname = @"shuxue";
    cty2.gold = @"100";
    
    std.arrCategory = @[cty,cty2];
    
    //测试用
    NSDictionary *dict = [std propertyDictionary];
    
    
    StudentZZ *store = [[TTSCacheManager defaultManager] objectForKey:@"women"];
    if (!store) {
        [[TTSCacheManager defaultManager] setObject:std forKey:@"women"];
    }else{
        NSLog(@"12 has been stored!");
        //        NSLog(@"%@",store.description);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
