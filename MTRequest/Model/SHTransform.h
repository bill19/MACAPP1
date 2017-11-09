//
//  SHTransform.h
//  MACAPP1
//
//  Created by HaoSun on 2017/11/7.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SHParmsModel;
@interface SHTransform : NSObject


/**
 根据格式化要求将childNode转化为数组s

 @param string 以分号隔开的字符串
 @return 整理好的数组
 */
//+ (NSArray *)shTransformWithString:(NSString *)string;

/**
 按照固定好的excel生成需要的字符串-从而生成需要的model

 @param fullString /emptyVisit/myEmptyVisitPager    ~    userId    ~    用户id    ~    NSString    ~    GET    ;
 @return 给一个模型数组啊
 */
+ (NSArray <SHParmsModel *>*)shTransFromFullSting:(NSString *)fullString;

@end
