//
//  XXViewController.m
//  XXModel
//
//  Created by LXF on 12/16/2016.
//  Copyright (c) 2016 LXF. All rights reserved.
//

#import "XXViewController.h"

#import "Person.h"

@interface XXViewController ()

@end

@implementation XXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /// 设置全局映射, 单独设置的话, 实现 +xx_propertyMapDictionary 方法即可
    [NSObject xx_setDefaultPropertyMapDictionary:@{@"id":@"identifier"}];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    id dictArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSArray<Person *> *array = [Person xx_modelArrayWithDictionaryArray:dictArray];
    NSLog(@"%@",array);
    
    NSDictionary *dict = [array.firstObject xx_toDictionary];
    NSString *json = [array.firstObject xx_toJsonString];
    NSLog(@"%@ \n %@\n",dict,json);
    
    NSArray *dictArray1 = [array xx_toDictionaryArray];
    NSString *arrayJson = [array xx_toJsonString];
    NSLog(@"%@ \n %@\n",dictArray1,arrayJson);
    
    
    /// 下面是不进行新键旧键映射的
    dict = [array.firstObject xx_toDictionary_Dont_Map];
    json = [array.firstObject xx_toJsonString_Dont_Map];
    NSLog(@"%@ \n %@\n",dict,json);
    
    dictArray1 = [array xx_toDictionaryArray_Dont_Map];
    arrayJson = [array xx_toJsonString_Dont_Map];
    NSLog(@"%@ \n %@\n",dictArray1,arrayJson);
    
    NSLog(@"--------");
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
