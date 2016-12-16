//
//  Phone.m
//  XXModel
//
//  Created by Rdxer on 2016/12/14.
//  Copyright © 2016年 Rdxer. All rights reserved.
//

#import "Phone.h"
#import "APP.h"

@implementation Phone

+(NSDictionary<NSString *,Class> *)xx_ArrayModelKeys{
    return @{@"app":[APP class]};
}

@end
