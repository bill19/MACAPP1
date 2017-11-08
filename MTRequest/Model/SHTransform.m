//
//  SHTransform.m
//  MACAPP1
//
//  Created by HaoSun on 2017/11/7.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import "SHTransform.h"

@implementation SHTransform


+ (NSArray *)shTransformWithString:(NSString *)string {
    //去除空格
    NSString *strUrl = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    //用分号隔开
    return [strUrl componentsSeparatedByString:@";"];
}

@end
