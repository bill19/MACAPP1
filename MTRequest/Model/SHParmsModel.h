//
//  SHParmsModel.h
//  MACAPP1
//
//  Created by HaoSun on 2017/11/7.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHParmsModel : NSObject

/**
 基本路径
 */
@property (nonatomic, copy) NSString *netUrl;
/**
 参数名称 - 英文
 */
@property (nonatomic, copy) NSString *netParameterName;
/**
 简称参数名称 - 英文 - 取/最后的obj
 */
@property (nonatomic, copy) NSString *abNetUrl;
/**
 参数备注
 */
@property (nonatomic, copy) NSString *netNoteName;
/**
 参数类型- NSString",@"NSInteger",@"float",@"double",@"BOOL",@"NSDate
 */
@property (nonatomic, copy) NSString *netTypeName;
/**
 参数请求方式 post  or get
 */
@property (nonatomic, copy) NSString *netRequest;

@end
