//
//  SingleModelAttribute.h
//  JsonToModelFileDemo
//
//  Created by 刘学阳 on 2017/9/28.
//  Copyright © 2017年 刘学阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Extension.h"

@interface SingleModelAttribute : NSObject
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSMutableString *headString;
@property (nonatomic, strong) NSMutableString *sourceString;
//允许多级分离
@property (nonatomic, assign) BOOL allowMutiSeparate;

- (instancetype)initWithClassName:(NSString *)className;
@end
