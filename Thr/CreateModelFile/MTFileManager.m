//
//  MTFileManager.m
//  MACAPP1
//
//  Created by HaoSun on 2017/11/8.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import "MTFileManager.h"
#import "MutiModelAttribute.h"

@implementation MTFileManager


/**
 * 生成文件并存放到指定的目录下
 * @param muti 多级情况
 * @return 成功为YES 失败为NO
 * deprecated 目前弃用
 */
- (BOOL)generateFileAllowMuti:(BOOL)muti;

{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *dirPath = [paths[0] stringByAppendingPathComponent:@"ClassFiles"];

    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:dirPath error:nil];
    BOOL dir = NO;
    BOOL exis = [fm fileExistsAtPath:dirPath isDirectory:&dir];
    if (!exis && !dir)
    {
        [fm createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:nil];
    }

    BOOL headFileFlag = NO;
    BOOL sourceFileFlag = NO;
    NSString *headFilePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h",_className]];
    NSString *sourceFilePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",_className]];

    headFileFlag = [self.headerString writeToFile:headFilePath atomically:NO encoding:NSUTF8StringEncoding error:nil];

    sourceFileFlag =  [self.sourceString writeToFile:sourceFilePath atomically:NO encoding:NSUTF8StringEncoding error:nil];

    if (headFileFlag && sourceFileFlag)
    {
        return YES;
    }
    return NO;
}
/**
 * 生成文件并存放到指定的目录下
 * @return 成功为YES 失败为NO
 */
- (BOOL)generateFile
{
    NSString *dateStr = [NSDate stringWithFormat:@"yyyy-MM-dd"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *dirPath = [paths[0] stringByAppendingPathComponent:dateStr];

    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL dir = NO;
    BOOL exis = [fm fileExistsAtPath:dirPath isDirectory:&dir];
    if (!exis && !dir)
    {
        [fm createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:nil];
    }

    BOOL headFileFlag = [self generateHeaderFile];
    BOOL sourceFileFlag = [self generateSourceFile];

    if (headFileFlag && sourceFileFlag)
    {
        return YES;
    }
    return NO;

}
/**
 * 生成头文件
 */
- (BOOL)generateHeaderFile
{
    BOOL headFileFlag = NO;
    NSString *dateStr = [NSDate stringWithFormat:@"yyyy-MM-dd"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *dirPath = [paths[0] stringByAppendingPathComponent:dateStr];
    NSString *headFilePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h",_className]];

    headFileFlag = [self.headerString writeToFile:headFilePath atomically:NO encoding:NSUTF8StringEncoding error:nil];

    if (headFileFlag)
    {
        return YES;
    }
    return NO;
}
/**
 * 生成源文件
 */
- (BOOL)generateSourceFile
{
    BOOL sourceFileFlag = NO;
    NSString *dateStr = [NSDate stringWithFormat:@"yyyy-MM-dd"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *dirPath = [paths[0] stringByAppendingPathComponent:dateStr];
    NSString *sourceFilePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",_className]];

    sourceFileFlag =  [self.sourceString writeToFile:sourceFilePath atomically:NO encoding:NSUTF8StringEncoding error:nil];

    if (sourceFileFlag)
    {
        return YES;
    }
    return NO;

}
/**
 * 下面是实首字母大写的方法
 * @param className 类名 作用用来大写类名的首字母
 */
- (NSString *)upperFirstLetter:(NSString *)className
{
    NSString *capStr = [className capitalizedStringWithLocale:[NSLocale currentLocale]];
    if ([capStr hasSuffix:@"es"])
    {
        capStr = [capStr substringToIndex:capStr.length - 2];
    }else if ([capStr hasSuffix:@"s"]){
        capStr = [capStr substringToIndex:capStr.length - 1];
    }
    return capStr;
}
/**
 * 下面是去除关键字的方法
 */
- (NSString *)takeOutKeyWord:(NSString *)string
{
    NSString *str = string;
    NSArray *keyWords = @[@"id",@"description"];
    for (NSInteger i = 0; i < keyWords.count; i++)
    {
        if ([string isEqualToString:keyWords[i]])
        {
            str = [string uppercaseString];
            break;
        }

    }
    return str;
}
/**
 * 下面是将所有属性连接成字符串的方法
 */
inline NSString * getPropertyString(NSArray *propertys)
{
    NSString *propertyStr = [propertys componentsJoinedByString:@""];
    return propertyStr;
}
/**
 * 下面是将所有的键值对拼接的方法
 */
inline NSString * getAllKeyValueString(NSArray *objInArr)
{
    NSString *allKeyValue = [objInArr componentsJoinedByString:@","];
    return allKeyValue;
}
/**
 * 创建文件
 */
- (BOOL)createFileAtPath:(NSString *)filePath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL sc = NO;
    if ([fm fileExistsAtPath:filePath])
    {
        return YES;
    }else{
        sc = [fm createFileAtPath:filePath contents:nil attributes:nil];
    }
    return sc;
}

@end
