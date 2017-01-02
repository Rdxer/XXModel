//
//  NSObject+XXParseModel.m
//  PodsTest
//
//  Created by Rdxer on 2016/12/4.
//  Copyright © 2016年 LXF. All rights reserved.
//

#import "NSObject+XXParseModel.h"
#import "JRSwizzle.h"
#import "NSObject+XXProperty.h"

@interface NSObject (XXParseModel)


/////////////////////////////////////////////////////////////
//////////////////     能够直接调用,协议已经实现    //////////////

//-----------------------  dict -> model   ----------------
/**
 单字典->单模型
 
 @param dict 字典
 @return 模型
 */
+(nullable instancetype)xx_modelWithDictionary:(nullable NSDictionary *)dict;

/**
 字典数组->模型数组
 
 @param dicts 字典数组
 @return 模型数组
 */
+(nullable NSArray *)xx_modelArrayWithDictionaryArray:(nullable NSArray *)dicts;



//-----------------------  json -> model  ----------------
/**
 jsonString -> Model
 
 @param jsonStr JSON字符串
 @return 模型
 */
+(nullable instancetype)xx_modelWithJSONString:(nonnull NSString *)jsonStr;

/**
 jsonString -> ModelArray
 
 @param jsonStr JSON字符串
 @return 模型数组
 */
+(nullable NSArray *)xx_modelArrayWithJSONString:(nonnull NSString *)jsonStr;


/////////////////////////////////////////////////////////////////
//////////////////////////   默认进行键值映射转化   /////////////////

//-----------------------  model -> json  ----------------
/**
 模型转成json字符串
 
 @return JSON字符串
 */
-(nullable NSString *)xx_toJsonString;

//-----------------------  model -> dict  ----------------
/**
 模型转成字典
 
 @return dict
 */
-(nonnull NSMutableDictionary<NSString *,id> *)xx_toDictionary;

/////////////////////////////////////////////////////////////////
//////////////////////////  不进行键值映射转化   //////////////////////////

//-----------------------  model -> json  ----------------
/**
 模型转成json字符串
 
 @return JSON字符串
 */
-(nullable NSString *)xx_toJsonString_Dont_Map;

//-----------------------  model -> dict  ----------------
/**
 模型转成字典
 
 @return dict
 */
-(nonnull NSMutableDictionary<NSString *,id> *)xx_toDictionary_Dont_Map;

@end


@implementation NSObject (XXParseModel_ExchangeMethod)
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

/// 交换掉NSObject自带的
-(void)xx_setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([self conformsToProtocol:@protocol(XXParseModel)]) {
        if ([[self class] xx_propertyMapDictionary][key]) {
            [self setValue:value forKey:[[self class] xx_propertyMapDictionary][key]];
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



@implementation NSObject (XXParseModel_Dictionary2Model)

+(id)xx_modelWithDictionary:(NSDictionary *)dict{
    
    if ([dict isKindOfClass:[NSDictionary class]] == false) {
        return nil;
    }
    
    id clazz = self;
    id instence = [[clazz alloc] init];
    
    if (dict.count < 1) {
        return instence;
    }
    
    if ([self respondsToSelector:@selector(xx_ModelPropertyDictionary)]) {
        NSDictionary *modelKeys = [(id)self xx_ModelPropertyDictionary];
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
    
    if ([self respondsToSelector:@selector(xx_ArrayModelPropertyDictionary)]) {
        NSDictionary *modelKeys = [(id)self xx_ArrayModelPropertyDictionary];
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
    NSMutableArray * arrayM = [NSMutableArray array];
    if ([dicts isKindOfClass:[NSArray class]] == false) {
        return arrayM;
    }
    for (NSDictionary *dict in dicts) {
        id obj = [self xx_modelWithDictionary:dict];
        if (obj == nil) {
            NSLog(@"NSArray<NSDictionary>中混进了奇怪的东西...");
            return nil;
        }
        [arrayM addObject:obj];
    }
    return arrayM;
}

@end

@implementation NSObject (XXParseModel_Json2Model)

//// -------- json --------

+(instancetype)xx_modelWithJSONString:(NSString *)jsonStr{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (result == nil || [result isKindOfClass:[NSDictionary class]] == NO) {
        NSLog(@"此 JSONString 不是 字典的 JSON 字符串 %@, error: %@", jsonStr, error);
        return nil;
    }
    return [self xx_modelWithDictionary:result];
}


+(NSArray *)xx_modelArrayWithJSONString:(NSString *)jsonStr{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (result == nil || [result isKindOfClass:[NSArray class]] == NO) {
        NSLog(@"此 JSONString 不是 数组的 JSON 字符串 %@, error: %@", jsonStr, error);
        return nil;
    }
    return [self xx_modelArrayWithDictionaryArray:result];
}

@end


static NSDictionary *_xx_setDefaultConvertKeys = nil;

@implementation NSObject (XXParseModel_ConvertKeys)

/// key <=> key
+(void)xx_setDefaultPropertyMapDictionary:(NSDictionary<NSString *,NSString *> *)keys;{
    _xx_setDefaultConvertKeys = keys;
}

+(NSDictionary *)xx_propertyMapDictionary{
    return _xx_setDefaultConvertKeys ?: @{};
}

@end

@implementation NSObject (XXParseModel_Model2Dictionary)
//-----------------------  model -> json  ----------------
/**
 模型转成字典
 
 @return JSON字符串
 */
-(nonnull NSMutableDictionary<NSString *,id> *)xx_toDictionary_Dont_Map{
    NSArray *pNameArray = [[self class]xx_allClassPropertyNameArray_filtered];
    NSMutableDictionary<NSString *,id> *dict = [self dictionaryWithValuesForKeys:pNameArray].mutableCopy;
    NSDictionary *temp = dict.copy;
    [temp enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj conformsToProtocol:@protocol(XXParseModel)]) {
            [dict setObject:[obj xx_toDictionary_Dont_Map] forKey:key];
        }else if([obj isKindOfClass:[NSArray class]]){
            NSArray *array = obj;
            if ([array.firstObject conformsToProtocol:@protocol(XXParseModel)]) {
                NSMutableArray *arrayM = [array xx_toDictionaryArray_Dont_Map];
                [dict setObject:arrayM forKey:key];
            }
        }
    }];
    return dict;
}

-(NSMutableDictionary<NSString *,id> *)xx_toDictionary{
    NSArray *pNameArray = [[self class]xx_allClassPropertyNameArray_filtered];
    NSMutableDictionary<NSString *,id> *dict = [self dictionaryWithValuesForKeys:pNameArray].mutableCopy;
    NSDictionary *temp = dict.copy;
    [temp enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj conformsToProtocol:@protocol(XXParseModel)]) {
            [dict setObject:[obj xx_toDictionary] forKey:key];
        }else if([obj isKindOfClass:[NSArray class]]){
            NSArray *array = obj;
            if ([array.firstObject conformsToProtocol:@protocol(XXParseModel)]) {
                NSMutableArray *arrayM = [array xx_toDictionaryArray];
                [dict setObject:arrayM forKey:key];
            }
        }
    }];
    
    if ([self conformsToProtocol:@protocol(XXParseModel)]) {
        [dict xx_keyConvertFromKeys:[[self class] xx_propertyMapDictionary].xx_dictionaryKeyValueConvert];
    }
    
    return dict;
}

@end

@implementation NSObject (XXParseModel_Model2Json)

//-----------------------  model -> json  ----------------
/**
 模型转成json字符串
 
 @return JSON字符串
 */
-(nullable NSString *)xx_toJsonString_Dont_Map{
    NSDictionary<NSString *,id> *dict = [self xx_toDictionary_Dont_Map];
    
    if ([NSJSONSerialization isValidJSONObject:dict] == false) {
        NSLog(@"不是有效的json对象");
        return nil;
    }
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
    if (error) {
        NSLog(@"转化为json失败 error->%@",error);
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//-----------------------  model -> json  ----------------
/**
 模型转成json字符串
 
 @return JSON字符串
 */
-(nullable NSString *)xx_toJsonString{
    NSDictionary<NSString *,id> *dict = [self xx_toDictionary];
    
    if ([NSJSONSerialization isValidJSONObject:dict] == false) {
        NSLog(@"不是有效的json对象");
        return nil;
    }
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
    if (error) {
        NSLog(@"转化为json失败 error->%@",error);
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


@end


@implementation NSArray (XXParseModel)

//-----------------------  modelArray -> json  ----------------
/**
 模型转成json字符串
 
 @return JSON字符串
 */
-(nullable NSString *)xx_toJsonString_Dont_Map{
    NSArray *dictArray = [self xx_toDictionaryArray_Dont_Map];
    
    if ([NSJSONSerialization isValidJSONObject:dictArray] == false) {
        NSLog(@"不是有效的json对象");
        return nil;
    }
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictArray options:kNilOptions error:&error];
    if (error) {
        NSLog(@"转化为json失败 error->%@",error);
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//-----------------------  modelArray -> dictArray  ----------------
/**
 模型转成字典
 
 @return dict
 */
-(nonnull NSMutableArray<NSDictionary<NSString *,id> *>*)xx_toDictionaryArray_Dont_Map{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (id item in self) {
        NSDictionary *dict = [item xx_toDictionary_Dont_Map];
        [arrayM addObject:dict];
    }
    return arrayM;
}


/////////////////////////////////////////////////////////////////
//////////////////////////   进行键值映射转化   /////////////////
//-----------------------  modelArray -> json  ----------------
/**
 模型转成json字符串
 
 @return JSON字符串
 */
-(nullable NSString *)xx_toJsonString{
    NSArray *dictArray = [self xx_toDictionaryArray];
    
    if ([NSJSONSerialization isValidJSONObject:dictArray] == false) {
        NSLog(@"不是有效的json对象");
        return nil;
    }
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictArray options:kNilOptions error:&error];
    if (error) {
        NSLog(@"转化为json失败 error->%@",error);
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//-----------------------  modelArray -> dictArray  ----------------
/**
 模型转成字典
 
 @return dict
 */
-(nonnull NSMutableArray<NSDictionary<NSString *,id> *>*)xx_toDictionaryArray{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (id item in self) {
        NSDictionary *dict = [item xx_toDictionary];
        [arrayM addObject:dict];
    }
    return arrayM;
}

@end






/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


@implementation NSMutableDictionary (XXParseModel)

-(void)xx_keyConvertFromKeys:(NSDictionary<NSString *,NSString *> *)keys{
    [keys enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        id dictV = [self objectForKey:key];
        if (dictV) {
            [self removeObjectForKey:key];
            [self setObject:dictV forKey:obj];
        }
    }];
}

@end

@implementation NSDictionary (XXParseModel)

/**
 字典,键值转换
 */
-(nullable NSDictionary *)xx_dictionaryKeyValueConvert{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj conformsToProtocol:@protocol(NSCopying)]) {
            [dict setObject:key forKey:obj];
        }else{
            NSLog(@"想要进行转化,值得必须准守NSCopying协议");
            *stop = YES;
        }
    }];
    if (dict.count == self.count) {
        return dict;
    }
    return nil;
}

@end
