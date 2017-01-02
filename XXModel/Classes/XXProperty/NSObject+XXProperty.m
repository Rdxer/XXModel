//
//  NSObject+XXProperty.m
//  Pods
//
//  Created by Rdxer on 2017/1/2.
//
//

#import "NSObject+XXProperty.h"
#import <objc/runtime.h>



static NSArray * xx_ignorePropertyNameArray_default_value = nil;

/// 二级缓存,过滤完毕之后的
static NSMutableDictionary<NSString *,NSMutableArray<NSString *> *> *xx_allClassFilterIgnorePropertyNameArrayCache_filtered = nil;
static NSMutableDictionary<NSString *,NSMutableArray<NSString *> *> *xx_currentyClassFilterIgnorePropertyNameArrayCache_filtered = nil;

@implementation NSObject (XXProperty)



+ (void)xx_setDefaultIgnorePropertyNameArray:(NSArray *)propertyNameArray{
    xx_ignorePropertyNameArray_default_value = propertyNameArray;
}

+ (NSArray *)xx_DefaultIgnorePropertyNameArray{
    return xx_ignorePropertyNameArray_default_value ?: @[];
}


+ (void)xx_filterIgnoreProperty:(NSMutableArray<NSString *> *)source{
    NSArray *array =  source.copy;
    NSArray *ignoreArray;
    id clazz = self;
    if ([clazz respondsToSelector:@selector(xx_ignorePropertyNameArray)]) {
        ignoreArray = [clazz xx_ignorePropertyNameArray];
    }
    for (NSString *p in array) {
        if ([[self xx_DefaultIgnorePropertyNameArray] containsObject:p]) {
            [source removeObject:p];
        }else if ([ignoreArray containsObject:p]){
            [source removeObject:p];
        }
    }
}

+ (NSMutableArray<NSString *> *)xx_allClassPropertyNameArray_filtered{
    NSMutableArray<NSString *> * array = [xx_allClassFilterIgnorePropertyNameArrayCache_filtered objectForKey:[self description]];
    
    if (array) {
        return array;
    }
    
    
    array = [self xx_currentyClassPropertyNameArray_filtered];
    Class clazz = [self superclass];
    while (clazz != [NSObject class]) {
        [array addObjectsFromArray:[clazz xx_currentyClassPropertyNameArray_filtered]];
        clazz = [clazz superclass];
    }
    
    if (xx_allClassFilterIgnorePropertyNameArrayCache_filtered == nil) {
        xx_allClassFilterIgnorePropertyNameArrayCache_filtered = [NSMutableDictionary<NSString *,NSMutableArray<NSString *> *>  dictionary];
    }
    
    if (array == nil) {
        array = [NSMutableArray array];
    }
    
    [xx_allClassFilterIgnorePropertyNameArrayCache_filtered setObject:array forKey:[self description]];
    
    return array;
}

+ (NSMutableArray<NSString *> *)xx_currentyClassPropertyNameArray_filtered{
    NSMutableArray<NSString *> * array = [xx_currentyClassFilterIgnorePropertyNameArrayCache_filtered objectForKey:[self description]];
    
    if (array) {
        return array;
    }
    
    array = [self xx_currentyClassPropertyNameArray].mutableCopy;
    
    [self xx_filterIgnoreProperty:array];
    
    if (xx_currentyClassFilterIgnorePropertyNameArrayCache_filtered == nil) {
        xx_currentyClassFilterIgnorePropertyNameArrayCache_filtered = [NSMutableDictionary dictionary];
    }
    
    [xx_currentyClassFilterIgnorePropertyNameArrayCache_filtered setObject:array forKey:[self description]];
    
    return array;
}

/**
 清空缓存
 */
+ (void)xx_clearPropertyNameArrayCache_filtered{
    xx_allClassFilterIgnorePropertyNameArrayCache_filtered = nil;
    xx_currentyClassFilterIgnorePropertyNameArrayCache_filtered = nil;
}

@end




/// 一级缓存
static NSMutableDictionary<NSString *,NSMutableArray<NSString *> *> *xx_allClassPropertyNameArrayCache = nil;
static NSMutableDictionary<NSString *,NSMutableArray<NSString *> *> *xx_currentyClassPropertyNameArrayCache = nil;

@implementation NSObject (XXGetProperty)


/**
 清空缓存
 */
+ (void)xx_clearPropertyNameArrayCache{
    xx_allClassPropertyNameArrayCache = nil;
    xx_currentyClassPropertyNameArrayCache = nil;
}

/**
 获取类的所有属性名称,包括父类
 
 @return 属性名称字符串数组
 */
+ (NSMutableArray<NSString *> *)xx_allClassPropertyNameArray{
    
    NSMutableArray<NSString *> * array = [xx_allClassPropertyNameArrayCache objectForKey:[self description]];
    
    if (array) {
        return array;
    }
    
    
    array = [self xx_currentyClassPropertyNameArray];
    Class clazz = [self superclass];
    while (clazz != [NSObject class]) {
        [array addObjectsFromArray:[clazz xx_currentyClassPropertyNameArray]];
        clazz = [clazz superclass];
    }
    
    if (xx_allClassPropertyNameArrayCache == nil) {
        xx_allClassPropertyNameArrayCache = [NSMutableDictionary<NSString *,NSMutableArray<NSString *> *>  dictionary];
    }
    
    if (array == nil) {
        array = [NSMutableArray array];
    }
    
    [xx_allClassPropertyNameArrayCache setObject:array forKey:[self description]];
    
    return array;
}

/**
 获取当前类的所有属性名称,不包括父类
 
 @return 属性名称字符串数组
 */
+ (NSMutableArray<NSString *> *)xx_currentyClassPropertyNameArray{
    
    NSMutableArray *allNames = [xx_currentyClassPropertyNameArrayCache objectForKey:[self description]];
    
    if (allNames) {
        return allNames;
    }
    
    
    ///存储所有的属性名称
    allNames = [[NSMutableArray alloc] init];
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList(self, &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        NSString *pn = [NSString stringWithUTF8String:propertyName];
        
        if ([xx_ignore_name_array containsObject:pn] == false) {
            [allNames addObject:pn];
        }
    }
    
    ///释放
    free(propertys);
    
    if (xx_currentyClassPropertyNameArrayCache == nil) {
        xx_currentyClassPropertyNameArrayCache = [NSMutableDictionary<NSString *,NSMutableArray<NSString *> *>  dictionary];
    }
    
    if (allNames == nil) {
        allNames = [NSMutableArray array];
    }
    
    [xx_currentyClassPropertyNameArrayCache setObject:allNames forKey:[self description]];
    
    return allNames;
}


@end

