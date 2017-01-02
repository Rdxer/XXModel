//
//  NSObject+XXProperty.h
//  Pods
//
//  Created by Rdxer on 2017/1/2.
//
//

#import <Foundation/Foundation.h>

// 默认需要忽略的
#define xx_ignore_name_array @[@"hash",@"superclass",@"description",@"debugDescription"]

@protocol XXProperty <NSObject>

/// 当前类有哪些需要过滤的再次返回即可
+ (NSArray<NSString *> *)xx_ignorePropertyNameArray;

@end




@interface NSObject (XXProperty)

/**
 设置 所有的,需要忽略掉的Property

 @param propertyNameArray
 */
+ (void)xx_setDefaultIgnorePropertyNameArray:(NSArray<NSString *> *)propertyNameArray;
+ (NSArray<NSString *> *)xx_DefaultIgnorePropertyNameArray;
+ (void)xx_filterIgnoreProperty:(NSMutableArray<NSString *> *)source;

/**
 获取类的所有属性名称,包括父类,过滤完毕的
 
 @return 属性名称字符串数组
 */
+ (NSMutableArray<NSString *> *)xx_allClassPropertyNameArray_filtered;

/**
 获取当前类的所有属性名称,不包括父类,过滤完毕的
 
 @return 属性名称字符串数组
 */
+ (NSMutableArray<NSString *> *)xx_currentyClassPropertyNameArray_filtered;

/**
 清空缓存,过滤完毕的
 */
+ (void)xx_clearPropertyNameArrayCache_filtered;

@end


@interface NSObject (XXGetProperty)

/**
 获取类的所有属性名称,包括父类
 
 @return 属性名称字符串数组
 */
+ (NSMutableArray<NSString *> *)xx_allClassPropertyNameArray;

/**
 获取当前类的所有属性名称,不包括父类
 
 @return 属性名称字符串数组
 */
+ (NSMutableArray<NSString *> *)xx_currentyClassPropertyNameArray;

/**
 清空缓存
 */
+ (void)xx_clearPropertyNameArrayCache;
@end
