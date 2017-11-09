//
//  SHTransform.m
//  MACAPP1
//
//  Created by HaoSun on 2017/11/7.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import "SHTransform.h"
#import "SHParmsModel.h"
@implementation SHTransform


+ (NSArray *)shTransformWithString:(NSString *)string {
    //去除空格
    NSString *strUrl = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *str = [strUrl stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    //用分号隔开
    return [str componentsSeparatedByString:@";"];
}

/**
 按照固定好的excel生成需要的字符串-从而生成需要的model

 @param fullString /emptyVisit/myEmptyVisitPager    ~    userId    ~    用户id    ~    NSString    ~    GET    ;
 @return 给一个模型数组啊
 */
+ (NSArray <SHParmsModel *>*)shTransFromFullSting:(NSString *)fullString {

    NSString *strUrl = [fullString stringByReplacingOccurrencesOfString:@" " withString:@""];
    //去除空格和换行符
    NSString *strUrl2 = [strUrl stringByReplacingOccurrencesOfString:@"\t" withString:@""];

    NSString *strUrl3 = [strUrl2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //用分号隔开
    NSArray *array1 =  [strUrl3 componentsSeparatedByString:@";"];
    
    NSMutableArray *models = [NSMutableArray array];
    for (int i = 0; i < array1.count; i++) {
        NSArray *array2 = [array1[i] componentsSeparatedByString:@"~"];
        SHParmsModel *model = [[SHParmsModel alloc] init];
        model.netUrl = [array2 objectAtIndex:0];
        model.netParameterName = [array2 objectAtIndex:1];
        model.netNoteName = [array2 objectAtIndex:2];
        model.netTypeName = [array2 objectAtIndex:3];
        model.netRequest = [array2 objectAtIndex:4];
        model.abNetUrl = [[model.netUrl componentsSeparatedByString:@"/"] lastObject];
        [models addObject:model];
    }
    return models;
}


@end
