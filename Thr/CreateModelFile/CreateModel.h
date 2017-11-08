//
//  CreateModel.h
//  JsonToModelFileDemo
//
//  Created by 刘学阳 on 2017/9/20.
//  Copyright © 2017年 刘学阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MutiModelAttribute.h"
#import "SingleModelAttribute.h"

@interface CreateModel : NSObject
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
//json 只读的 如果传入的json为格式化的格式 可获取原来的json
@property (nonatomic, readonly) NSString *json;
//格式化json串后的数据
@property (nonatomic, readonly) NSString *formatJson;
//错误信息描述
@property (nonatomic, readonly) NSString *errorMsg;
/**
 * 验证json
 */
- (BOOL)verifyJson:(NSString *)json;
/**
 * 格式化字符串
 * @param json json
 * deprecated 目前弃用
 */
- (BOOL)formatJson:(NSString *)json;
/**
 * 格式化字符串
 * @param json json
 */
- (BOOL)formattingJson:(NSString *)json;
/**
 * 创建出model
 * @param json json数据
 * @return BOOL 成功为YES json结构出错 会失败 返回NO allowMuti 允许多级
 */
- (BOOL)createModelWithJson:(NSString *)json allowMuti:(BOOL)allowMuti;
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
