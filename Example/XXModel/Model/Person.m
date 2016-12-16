//
//  Person.m
//  XXModel
//
//  Created by Rdxer on 2016/12/14.
//  Copyright © 2016年 Rdxer. All rights reserved.
//

#import "Person.h"

#import "Cat.h"
#import "Phone.h"


@implementation Person

+(NSDictionary *)xx_ModelKeys{
    return @{@"cat":@"Cat"};
}

+(NSDictionary *)xx_ArrayModelKeys{
    return @{@"phone":[Phone class]};
}

@end
