//
//  MTFileManager.h
//  MACAPP1
//
//  Created by HaoSun on 2017/11/8.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTFileManager : NSObject

/**
 缩写
 */
@property (nonatomic, copy) NSString *abString;
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
 * 创建.H的 url文件
 * @param urlArray
 */
- (BOOL)createModelWithUrlurlArray:(NSArray *)urlArray;

- (BOOL)createModelWithUrlurlString:(NSString *)urlstring;

/**
 创建 具体的 post和get接口文件

 @param url url description
 @param parms parms description
 */
- (void)creatRequestFileWithUrl:(NSString *)url parms:(NSArray *)parms  requestType:(NSInteger)requestType;
- (void)creatRequestFileWithUrl:(NSString *)url parmsString:(NSString *)parmsString requestType:(NSInteger)requestType;

/**
 * 生成文件并存放到指定的目录下
 * @return 成功为YES 失败为NO
 * deprecated 目前弃用
 */
- (BOOL)generateFileAllow;
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
