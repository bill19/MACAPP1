//
//  SHNetModel.h
//  MACAPP1
//
//  Created by HaoSun on 2017/11/6.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHNetModel : NSObject
/**
 标题名字
 */
@property (nonatomic, copy) NSString *nodeName;

/**
 node的类型 可以能为一层或者二层
 */
@property (nonatomic, assign) NSInteger nodeType;
@end
