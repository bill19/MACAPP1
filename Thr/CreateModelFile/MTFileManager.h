//
//  MTFileManager.h
//  MACAPP1
//
//  Created by HaoSun on 2017/11/8.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTFileManager : NSObject

//类名称
@property (nonatomic, strong) NSString *className;
//项目名称
@property (nonatomic, strong) NSString *projectName;
//开发者姓名
@property (nonatomic, strong) NSString *developerName;
//头文件内容
@property (nonatomic, strong) NSMutableString * headerString;
//源文件内容
@property (nonatomic, strong) NSMutableString *sourceString;

/**
 * 生成文件并存放到指定的目录下
 * @param muti 多级情况
 * @return 成功为YES 失败为NO
 * deprecated 目前弃用
 */
- (BOOL)generateFileAllowMuti:(BOOL)muti;
/**
 * 生成文件并存放到指定的目录下
 * @return 成功为YES 失败为NO
 */
- (BOOL)generateFile;
/**
 * 生成头文件
 */
- (BOOL)generateHeaderFile;
/**
 * 生成源文件
 */
- (BOOL)generateSourceFile;

@end
