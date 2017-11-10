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
 按照固定好的excel生成需要的字符串-从而生成需要的model

 @param fullString /emptyVisit/myEmptyVisitPager    ~    userId    ~    用户id    ~    NSString    ~    GET    ;
 @return 给一个模型数组啊
 */
+ (NSArray <SHParmsModel *>*)shTransFromFullSting:(NSString *)fullString;

/**在一个字符串外部加一对大括号 主要是 function最外部的大括号**/
+ (NSMutableString *)addBrackets:(NSString *)sourceString;

/**在一个字符串外部加一对小括号**/
+ (NSMutableString *)addParentheses:(NSString *)sourceString;

/**
 合并数组里面的同类项

 @param parms 合并同类项
 @return 合并同类项
 */
+ (NSDictionary *)mergeParms:(NSArray <SHParmsModel *>*)parms urls:(NSArray *)urls;

/*只接受",@[@"NSString",@"NSInteger",@"float",@"double",@"BOOL",@"NSDate"];*/
+ (NSString *)parmType:(NSString *)type ;

/***数组去重*/
+ (NSArray *)removeRepeat:(NSArray *)reportArray ;


/**
 添加标注的body

 @return return value description
 */
+ (NSString *)addMarkBodyName:(NSString *)name markName:(NSString *)markName;
/**
 添加标注的头

 @return return value description
 */
+ (NSString *)addMarkHeader;

+ (NSString *)addMarkFooter ;
/**
 给URL添加备注信息

 @param urlMarkString urlMarkString description
 @return return value description
 */
+ (NSString *)addUrlMark:(NSString *)urlMarkString ;

/**
 拼接 [NSString stringWithFormat:@"%@",@"report/report"] 的格式

 @param defString 拼接样式出产字符串
 @return 返回相对应的字符串
 */
+ (NSString *)addDefppendString:(NSString *)defString ;

/**
 添加备注信息

 @param marksModels marksModels description
 @return return value description
 */
+ (NSString *)addMarkModels:(NSArray <SHParmsModel *>*)marksModels ;
/**
 添加备注信息

 @param marks marks description
 @return return value description
 */
+ (NSString *)addMarks:(NSArray <NSString *>*)marks ;
/**
 添加备注 -  添加一行备注
 @param markString 需要添加的信息
 @return 备注信息
 */
+ (NSString *)addMark:(NSString *)markString;

+ (NSString *)addMarkModel:(SHParmsModel *)parmsModel ;

+ (NSString *)urlHeaderBeginclassName:(NSString *)className;

/**
 Description

 @return <#return value description#>
 */
+ (NSString *)urlFooterEndclassName:(NSString *)className ;
@end
