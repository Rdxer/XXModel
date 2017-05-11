//
//  NSObject+XXParseModel.h
//  PodsTest
//
//  Created by Rdxer on 2016/12/4.
//  Copyright © 2016年 LXF. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XXParseModel <NSObject>

@optional

/**
 key <=> key 转化
 */
+(NSDictionary *)xx_convertKeys;

/**
 需要将指定的key转化为对应的对象
 */
+(NSDictionary *)xx_ModelKeys;

/**
 需要将指定的key转化为对应的对象array
 */
+(NSDictionary *)xx_ArrayModelKeys;

@end

@interface NSObject (XXParseModel)


/**
 单字典->单模型

 @param dict 字典
 @return 模型
 */
+(id)xx_modelWithDict:(NSDictionary *)dict;

/**
 字典数组->模型数组
 
 @param dicts 字典数组
 @return 模型数组
 */
+(NSArray *)xx_modelsWithDicts:(NSArray *)dicts;

/**
 jsonString -> Model
 
 @param jsonStr JSON字符串
 @return 模型
 */
+(id)xx_modelWithJSONString:(NSString *)jsonStr;

/**
 键值转化
 */
+(NSDictionary *)xx_convertKeys;

// -(NSString *)xx_toJsonString;

@end
