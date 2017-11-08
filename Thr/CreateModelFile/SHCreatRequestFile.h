//
//  SHCreatRequestFile.h
//  MACAPP1
//
//  Created by HaoSun on 2017/11/7.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MutiModelAttribute.h"
#import "SingleModelAttribute.h"
#import "SHParmsModel.h"
@interface SHCreatRequestFile : NSObject

/**
 通过模型数组创建需要的文件

 @param array 模型数组
 */
+ (BOOL)creatRequestFileWithArray:(NSArray <SHParmsModel *>*)array;

@end
