//
//  DSRunTime.m
//  ObjectMode
//
//  Created by 董德帅 on 2021/11/2.
//  Copyright © 2021 九天. All rights reserved.
//

#import "DSRunTime.h"
#import<objc/runtime.h>
@implementation DSRunTime
{
    NSString * str;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        str = @"9999";
        NSLog(@"%@", NSStringFromClass([self class])); // Son
        NSLog(@"%@", NSStringFromClass([super class])); // Son
    }
    return self;
}
- (void)runTimeTest{
    Class te = objc_getClass("DSRunTime");
    NSLog(@"%@",te);
//    Class c = object_setClass(te, object_getClass(te));
}
@end
