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
@property (nonatomic, strong) NSMutableString *headerString;
//源文件内容
@property (nonatomic, strong) NSMutableString *sourceString;


- (BOOL)createModelWithUrlurlArray:(NSArray *)urlArray;

- (BOOL)createModelWithUrlurlString:(NSString *)urlstring;


@end
