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
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"json"];
//    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSData *data = [NSData dataWithContentsOfFile:path];
    id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSArray<Person *> *array = [Person xx_modelsWithDicts:jsonDict[@"data"]];
    NSLog(@"%@",array);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
