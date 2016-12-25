//
//  NSObject+XXParseModel.m
//  PodsTest
//
//  Created by Rdxer on 2016/12/4.
//  Copyright © 2016年 LXF. All rights reserved.
//

#import "NSObject+XXParseModel.h"
#import "JRSwizzle.h"

@implementation NSObject (XXParseModel)

+ (void)load
{
    if (self == [NSObject class]) {
        NSError *error = NULL;
        [self jr_swizzleMethod:@selector(setValue:forUndefinedKey:) withMethod:@selector(xx_setValue:forUndefinedKey:) error:&error];
        if (error) {
            NSLog(@"jr_swizzleMethod <setValue:forUndefinedKey:> error===>%@",error);
        }
        
        error = NULL;
        
        [self jr_swizzleMethod:@selector(setNilValueForKey:) withMethod:@selector(xx_setNilValueForKey:) error:&error];
        if (error) {
            NSLog(@"jr_swizzleMethod <setNilValueForKey:> error===>%@",error);
        }
    }
}

+(id)xx_modelWithDictionary:(NSDictionary *)dict{
    id clazz = self;
    id instence = [[clazz alloc] init];
    
    if (dict.count < 1) {
        return instence;
    }
    
    if ([self respondsToSelector:@selector(xx_ModelKeys)]) {
        NSDictionary *modelKeys = [(id)self xx_ModelKeys];
        if (modelKeys.count) {
            NSMutableDictionary *dictM = [dict mutableCopy];
            [modelKeys enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                id v = [dictM valueForKey:key];
                [dictM removeObjectForKey:key];
                if (v && [v isKindOfClass:[NSDictionary class]]) {
                    Class clazz;
                    
                    if ([obj isKindOfClass:[NSString class]]) {
                        clazz = NSClassFromString(obj);
                    }else{
                        clazz = obj;
                    }
                    
                    id newobj = [clazz xx_modelWithDictionary:v];
                    
                    [instence setValue:newobj forKey:key];
                }else{
                    if (v) {
                        NSLog(@"XXParseModel <xx_modelWithDict:> error===>字典转模型 自动转化到对应模型时失败 -> value = (%@)",v);
                    }
                }
            }];
            dict = dictM.copy;
        }
    }
    
    if ([self respondsToSelector:@selector(xx_ArrayModelKeys)]) {
        NSDictionary *modelKeys = [(id)self xx_ArrayModelKeys];
        if (modelKeys.count) {
            NSMutableDictionary *dictM = [dict mutableCopy];
            [modelKeys enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, Class  _Nonnull obj, BOOL * _Nonnull stop) {
                id v = [dictM valueForKey:key];
                [dictM removeObjectForKey:key];
                if (v && [v isKindOfClass:[NSArray class]]) {
                    id newobjList = [obj xx_modelArrayWithDictionaryArray:v];
                    [instence setValue:newobjList forKey:key];
                }else{
                    if (v) {
                        NSLog(@"XXParseModel <xx_modelWithDict:> error===>字典转模型 自动转化到对应模型列表时失败 -> value = (%@)",v);
                    }
                }
            }];
            dict = dictM.copy;
        }
    }
    
    [instence setValuesForKeysWithDictionary:dict];
    
    
    return instence;
}

+(NSArray *)xx_modelArrayWithDictionaryArray:(NSArray *)dicts{
    NSMutableArray * arrrayM = @[].mutableCopy;
    for (NSDictionary *dict in dicts) {
        id obj = [self xx_modelWithDictionary:dict];
        if (obj == nil) {
            return nil;
        }
        [arrrayM addObject:obj];
    }
    return arrrayM;
}

+(instancetype)xx_modelWithJSONString:(NSString *)jsonStr{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (result == nil || [result isKindOfClass:[NSDictionary class]] == NO) {
        NSLog(@"此 JSONString 不是 字典的 JSON 字符串 %@, error: %@", jsonStr, error);
        return nil;
    }
    return [self xx_modelWithDictionary:result];
}

//
+(NSArray *)xx_modelArrayWithJSONString:(NSString *)jsonStr{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (result == nil || [result isKindOfClass:[NSArray class]] == NO) {
        NSLog(@"此 JSONString 不是 数组的 JSON 字符串 %@, error: %@", jsonStr, error);
        return nil;
    }
    return [self xx_modelArrayWithDictionaryArray:result];
}



+(NSDictionary *)xx_convertKeys{
    return @{
             @"id" : @"identifier"
             };
}

-(void)xx_setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([self conformsToProtocol:@protocol(XXParseModel)]) {
        if ([[self class] xx_convertKeys][key]) {
            [self setValue:value forKey:[[self class] xx_convertKeys][key]];
        }else{
            NSLog(@"forUndefinedKey k(%@)=v(%@) => Class(%@)",key,value,self.class);
        }
    }else{
        [self xx_setValue:value forUndefinedKey:key];
    }
}

-(void)xx_setNilValueForKey:(NSString *)key{
    if ([self conformsToProtocol:@protocol(XXParseModel)]) {
        //        [self setValue:@(0) forKey:[[self class] xx_convertKeys][key]];
        NSLog(@"setNilValueForKey k(%@) => Class(%@)",key,self.class);
    }else{
        [self xx_setNilValueForKey:key];
    }
}

@end

