//
//  Person.h
//  XXModel
//
//  Created by Rdxer on 2016/12/14.
//  Copyright © 2016年 Rdxer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XXModel.h"

@class Cat;
@class Phone;

@interface Person : NSObject<XXParseModel>

@property (nonatomic, strong) Cat *cat;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSArray<Phone *> *phone;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;

@end
