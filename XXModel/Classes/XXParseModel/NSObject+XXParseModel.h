//
//  NSObject+XXParseModel.h
//  PodsTest
//
//  Created by Rdxer on 2016/12/4.
//  Copyright © 2016年 LXF. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+XXProperty.h"

@protocol XXParseModel <NSObject>

@optional

///----- 字典转模型过程中需要实现其他功能 -----
    
/**
 jsonkey <=> modelkey 转换,如果父类实现了,请同父类的一起返回
 属性映射字典
 */
+(nonnull NSDictionary<NSString *,NSString *> *)xx_propertyMapDictionary;

/**
 需要将指定的key转化为对应的对象,如果父类实现了,请同父类的一起返回
 */
+(nonnull NSDictionary *)xx_ModelPropertyDictionary;

/**
 需要将指定的key转化为对应的对象列表,如果父类实现了,请同父类的一起返回
 */
+(nonnull NSDictionary *)xx_ArrayModelPropertyDictionary;
    
    
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
 模型转成json字符串,不进行键值映射转化
 
 @return JSON字符串
 */
-(nullable NSString *)xx_toJsonString_Dont_Map;

//-----------------------  model -> dict  ----------------
/**
 模型转成字典,,不进行键值映射转化
 
 @return dict
 */
-(nonnull NSMutableDictionary<NSString *,id> *)xx_toDictionary_Dont_Map;


@end

@interface NSObject (XXParseModel)

/**
 默认为空 可以在 appdelegate 中设置为这个
 
@{
    @"id" : @"identity",
    @"description":@"desc"
}
 
 */
+(void)xx_setDefaultPropertyMapDictionary:(NSDictionary<NSString *,NSString *> * _Nonnull )keys;
    
@end


@interface NSObject (XXParseModel_protocol)


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

@interface NSArray (XXParseModel)
/////////////////////////////////////////////////////////////////
//////////////////////////   进行键值映射转化   /////////////////
//-----------------------  modelArray -> json  ----------------
/**
 模型数组转成json字符串
 
 @return JSON字符串
 */
-(nullable NSString *)xx_toJsonString;

//-----------------------  modelArray -> dictArray  ----------------
/**
 模型数组转成字典数组
 
 @return dict
 */
-(nonnull NSMutableArray<NSDictionary<NSString *,id> *>*)xx_toDictionaryArray;


/////////////////////////////////////////////////////////////////
//////////////////////////   不进行键值映射转化   /////////////////
//-----------------------  modelArray -> json  ----------------
/**
 模型数组转成json字符串,不进行键值映射转化
 
 @return JSON字符串
 */
-(nullable NSString *)xx_toJsonString_Dont_Map;

//-----------------------  modelArray -> dictArray  ----------------
/**
 模型数组转成字典数组,不进行键值映射转化
 
 @return dict
 */
-(nonnull NSMutableArray<NSDictionary<NSString *,id> *>*)xx_toDictionaryArray_Dont_Map;


@end


@interface NSMutableDictionary (XXParseModel)

/**
 字典键名称转换

 @param keys 旧key <=> 新key
 */
-(void)xx_keyConvertFromKeys:(NSDictionary<NSString *,NSString *> * _Nonnull)keys;

@end

@interface NSDictionary (XXParseModel)

/**
 字典,键值转换
 */
-(nullable NSDictionary *)xx_dictionaryKeyValueConvert;

@end
