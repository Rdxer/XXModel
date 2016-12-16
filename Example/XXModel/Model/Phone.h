//
//  Phone.h
//  XXModel
//
//  Created by Rdxer on 2016/12/14.
//  Copyright © 2016年 Rdxer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXModel.h"

@class APP;
@interface Phone : NSObject<XXParseModel>

@property (nonatomic, copy) NSArray<APP *> *app;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger price;


@end
