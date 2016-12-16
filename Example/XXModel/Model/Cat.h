//
//  Cat.h
//  XXModel
//
//  Created by Rdxer on 2016/12/14.
//  Copyright © 2016年 Rdxer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXModel.h"

@interface Cat : NSObject<XXParseModel>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger sex;

@end
