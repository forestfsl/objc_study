//
//  SLPerson+Test1.m
//  07.Category分析
//
//  Created by fengsl on 2019/5/5.
//  Copyright © 2019 songlin. All rights reserved.
//

#import "SLPerson+Test1.h"

@implementation SLPerson (Test1)

+ (void)load{
    NSLog(@"调用了SLPerson Test1 load方法");
}

+ (void)test{
    NSLog(@"调用了SLPerson Test1 test 方法");
}

@end
