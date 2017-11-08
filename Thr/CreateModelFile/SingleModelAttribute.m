//
//  SingleModelAttribute.m
//  JsonToModelFileDemo
//
//  Created by 刘学阳 on 2017/9/28.
//  Copyright © 2017年 刘学阳. All rights reserved.
//

#import "SingleModelAttribute.h"

@implementation SingleModelAttribute
- (instancetype)initWithClassName:(NSString *)className
{
    self = [super init];
    if (self) {
        _className = className;
    }
    return self;
}
#pragma mark - Lazy loading -
- (NSMutableString *)headString
{
    if (!_headString) {
        _headString = [[NSMutableString alloc]init];
    }
    return _headString;
}
- (NSMutableString *)sourceString
{
    if (!_sourceString) {
        _sourceString = [[NSMutableString alloc]init];
    }
    return _sourceString;
}

@end
