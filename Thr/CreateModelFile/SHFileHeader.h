//
//  SHFileHeader.h
//  MACAPP1
//
//  Created by HaoSun on 2017/11/10.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#ifndef SHFileHeader_h
#define SHFileHeader_h

#define k_Block_Success  @"typedef void(^SuccessBlock)(id success);\n"
#define k_Block_Failure  @"typedef void(^FailureBlock)(id error);\n"
#define k_Block_Error    @"typedef void(^ErrorBlock)(NSError *error);\n"

#define k_block_judgeHeader @"+ (void)judgeReturnValueResponseObject:(id)responseObject  Success:(void(^)())success fauile:(void(^)())fauile;\n"

#define k_function_header(abString,funcName,parms,footer,sign) [NSString stringWithFormat:@"+ (void)request%@%@%@%@%@",abString,funcName,parms,footer,sign]
#define k_function_footer @"Success:(SuccessBlock)successBlock failure:(FailureBlock)failure netError:(ErrorBlock)errorBlock"

#define k_function_requestBody(requestType,url) [NSString stringWithFormat:@"[MTHttpRequest_Helper %@RequestWithURL:%@ parameters:params success:^(id responseObject) {\n[self judgeReturnValueResponseObject:responseObject Success:^{\nif (successBlock) {\nsuccessBlock(responseObject);\n}\n} fauile:^{\nif (failure) {\nfailure(responseObject);\n}\n}];\n} failure:^(NSError *error, NSString *errorStr) {\nif (errorBlock) {\nerrorBlock(error);\n}\n}];",requestType,url]

#define k_function_addParm @"/**统一增加某些参数 例如 userid 等*/\n+ (void)addParametersForDict:(NSMutableDictionary *)dict {\n[self addParmWith:dict mtobject:@\"\" mtkey:@\"\"];\n}\n"
#define k_function_addParmWithDict @"/**增加参数方法*/\n + (void)addParmWith:(NSMutableDictionary *)dict mtobject:(id)object mtkey:(NSString *)key{\nif ([key isKindOfClass:[NSString class]]) {\nif (object && key.length) {\n[dict setObject:object forKey:key];\n}\n}\n}\n"
#endif /* SHFileHeader_h */

