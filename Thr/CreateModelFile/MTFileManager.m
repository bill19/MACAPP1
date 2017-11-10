//
//  MTFileManager.m
//  MACAPP1
//
//  Created by HaoSun on 2017/11/8.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import "MTFileManager.h"
#import "MutiModelAttribute.h"
#import "SHTransform.h"
#import "SHParmsModel.h"
@interface MTFileManager()

//存放多级model 的数组 弃用
@property (nonatomic, strong) NSMutableArray *mutiModelArray;
//存放多级model 的数组
@property (nonatomic, strong) NSMutableArray *allModelArray;

//拼接@class的字符串
@property (nonatomic, strong) NSMutableString *atString;

@property (nonatomic, strong) NSArray *urls;

@end
@implementation MTFileManager

- (BOOL)createModelWithUrlurlString:(NSString *)urlstring {
    [self createModelWithUrlurlArray:[SHTransform shTransFromFullSting:urlstring]];
    [self creatRequestFileWithArray:[SHTransform shTransFromFullSting:urlstring]];

    return YES;
}
/**
 * 创建出url文件
 * @param urlArray json数据
 */
- (BOOL)createModelWithUrlurlArray:(NSArray <SHParmsModel *>*)urlArray
{
    self.headerString = [NSMutableString string];
    [self creatFileHeader];
    [self.headerString appendString:[self urlHeaderBegin]];
    NSMutableArray *urlTempArr = [NSMutableArray array];
    for (NSUInteger index = 0; index < urlArray.count; index++) {
        SHParmsModel *parmsModel = [urlArray objectAtIndex:index];
        [urlTempArr addObject:parmsModel.netUrl];
    }
    NSArray *urls = [self removeRepeat:urlTempArr];
    self.urls = urls;
    for (int i = 0; i < urls.count; i++) {
        //去除空格
        NSString *urlStr1 = [[urls objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *urlStr = [urlStr1 stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        //创建 #define URL_NH_REPORT  的格式
        [self.headerString appendString:[self addUrlMark:@""]];
        NSString *temStr = [[urls[i] componentsSeparatedByString:@"/"] lastObject];
        [self.headerString appendFormat:@"#define URL_%@_%@ ",[self.abString uppercaseStringWithLocale:[NSLocale currentLocale]],[temStr uppercaseStringWithLocale:[NSLocale currentLocale]]];
        [self.headerString appendString:[self addDefppendString:urlStr]];
        [self.headerString appendString:@"\n\n\n"];
    }

    [self.headerString appendString:[self urlFooterEnd]];
    return [self generateFileAllowForHeader:@"URL"];
}

- (BOOL)creatRequestFileWithArray:(NSArray <SHParmsModel *>*)modelArray {

    self.headerString = [NSMutableString string];
    [self creatFileHeader];
    //拼接上面的block回调
    [self.headerString appendString:@"typedef void(^SuccessBlock)(id success);\n"];
    [self.headerString appendString:@"typedef void(^FailureBlock)(id error);\n"];
    [self.headerString appendString:@"typedef void(^ErrorBlock)(NSError *error);\n"];

    NSMutableString *sourceString = [NSMutableString string];
    [sourceString appendString:@"+ (void)judgeReturnValueResponseObject:(id)responseObject  Success:(void(^)())success fauile:(void(^)())fauile;\n\n"];

    NSDictionary *dict = [self mergeParms:modelArray];
    for (NSString *url in self.urls) {
        /**插入方法信息*/
        NSMutableString *tempSourceString = [NSMutableString string];
        NSArray *models = dict[url];
        [tempSourceString appendString: [self addMarkModels:models]];
        [tempSourceString appendString:@"+ (void)"];
        [tempSourceString appendString:@"request"];
        [tempSourceString appendString:[_abString uppercaseString]];
        [tempSourceString appendString:[[url componentsSeparatedByString:@"/"] lastObject]];

        for (int i = 0; i < models.count; i++) {
            SHParmsModel *parmModel = [models objectAtIndex:i];
            [tempSourceString appendString:parmModel.netParameterName];
            [tempSourceString appendString:@":"];
            [tempSourceString appendString:[self parmType:parmModel.netTypeName]];
            [tempSourceString appendString:parmModel.netParameterName];
            [tempSourceString appendString:@" "];
        }
        [tempSourceString appendString:[self appendBlockInfo]];
        [tempSourceString appendString:@"\n\n"];
        [sourceString appendString:tempSourceString];
        [sourceString appendString:@"\n"];
    }
    NSString *str1 = [NSString stringWithFormat:@"%@Request",_className];
    [self.headerString appendFormat:k_CLASS,str1,sourceString];

    [self creatRequestFileSourceWithArray:modelArray];
    return  [self generateFileAllowForHeader:@"Request"];
}

- (BOOL)creatRequestFileSourceWithArray:(NSArray <SHParmsModel *>*)modelArray {

    self.sourceString = [NSMutableString string];
    [self creatFileHeaderSource];
    NSMutableString *sourceString = [NSMutableString string];
    /**创建唯一调用方法*/
    [sourceString appendString:@"+ (void)judgeReturnValueResponseObject:(id)responseObject Success:(void(^)())success fauile:(void(^)())fauile{\nif (responseObject != nil || [responseObject isKindOfClass:[NSDictionary class]]) {\nNSDictionary *parm = (NSDictionary *)responseObject;\nif ([parm[@\"success\"] isEqualToString:@\"true\"]) {\nsuccess();\n} else {\nfauile();\n}\n}\n}\n\n"];
    NSDictionary *dict = [self mergeParms:modelArray];
    for (NSString *url in self.urls) {
        /**插入方法信息*/
        NSMutableString *tempSourceString = [NSMutableString string];
        NSArray *models = dict[url];
        [tempSourceString appendString: [self addMarkModels:models]];
        [tempSourceString appendString:@"+ (void)"];
        [tempSourceString appendString:@"request"];
        [tempSourceString appendString:[_abString uppercaseString]];
        [tempSourceString appendString:[[url componentsSeparatedByString:@"/"] lastObject]];

        NSMutableString *tempUrl = [NSMutableString string];
        NSString *temStruUrl = [[url componentsSeparatedByString:@"/"] lastObject];
        [tempUrl appendFormat:@"URL_%@_%@ ",[self.abString uppercaseStringWithLocale:[NSLocale currentLocale]],[temStruUrl uppercaseStringWithLocale:[NSLocale currentLocale]]];

        NSMutableString *inputSourceString = [NSMutableString string];
        NSString *requestType = [NSString string];
        [inputSourceString appendString:@"NSMutableDictionary *params = [NSMutableDictionary dictionary];\n"];
        for (int i = 0; i < models.count; i++) {
            //参数对接.h文件
            SHParmsModel *parmModel = [models objectAtIndex:i];
            [tempSourceString appendString:parmModel.netParameterName];
            [tempSourceString appendString:@":"];
            [tempSourceString appendString:[self parmType:parmModel.netTypeName]];
            [tempSourceString appendString:parmModel.netParameterName];
            [tempSourceString appendString:@" "];
            //参数新增到内部
            NSMutableString *tempType =[NSMutableString string];
            if ([parmModel.netTypeName isEqualToString:@"NSString"]) {
                [tempType appendString:parmModel.netParameterName];
            }else{
                [tempType appendString:[self addParentheses:parmModel.netParameterName]];
            }
            [inputSourceString appendFormat:@"[self addParmWith:params mtobject:%@ mtkey:@\"%@\"];\n",tempType,parmModel.netParameterName];
            requestType = parmModel.netRequest;
        }
        [tempSourceString appendString:[self appendBlockInfoSource]];
        [inputSourceString appendString:@"[self addParametersForDict:params];\n"];
        [inputSourceString appendString:[self addUnifiedUrl:tempUrl requestType:[requestType uppercaseString]]];
        inputSourceString = [self addBrackets:inputSourceString];
        [tempSourceString appendString:inputSourceString];
        [tempSourceString appendString:@"\n\n"];
        [sourceString appendString:tempSourceString];
        [sourceString appendString:@"\n"];
    }

    [sourceString appendString:@"/**统一增加某些参数 例如 userid 等*/\n+ (void)addParametersForDict:(NSMutableDictionary *)dict {\n[self addParmWith:dict mtobject:@\" mtkey:@\"\"];\n}\n"];
    [sourceString appendString:@"/**增加参数方法*/\n + (void)addParmWith:(NSMutableDictionary *)dict mtobject:(id)object mtkey:(NSString *)key{\nif ([key isKindOfClass:[NSString class]]) {\nif (object && key.length) {\n[dict setObject:object forKey:key];\n}\n}\n}\n"];
    NSString *str1 = [NSString stringWithFormat:@"%@Request",_className];
    [self.sourceString appendFormat:k_CLASS_M,str1,sourceString];
    return YES;
}

/**
 创建文件的头信息
 */
- (void)creatFileHeader {
    NSString *dateStr = [NSDate stringWithFormat:@"yyyy/MM/dd"];
    NSString *dateStr2 = [NSDate stringWithFormat:@"yyyy"];
    [self.headerString appendFormat:k_HEADINFO('h'),_className,_projectName,_developerName,dateStr,dateStr2,_developerName];
    [self.headerString appendString:@"\n\n"];
}
/**
 创建.m文件的头信息
 */
- (void)creatFileHeaderSource {
    NSString *dateStr = [NSDate stringWithFormat:@"yyyy/MM/dd"];
    NSString *dateStr2 = [NSDate stringWithFormat:@"yyyy"];
    NSString *classNameStr = [NSString stringWithFormat:@"%@Request",_className];
    [self.sourceString appendFormat:k_HEADINFO('m'),classNameStr,_projectName,_developerName,dateStr,dateStr2,_developerName,classNameStr];
    [self.sourceString appendFormat:@"#import \"%@URL.h\"",_className];
    [self.sourceString appendString:@"\n\n"];
}

- (NSString *)appendBlockInfo{
    return @"Success:(SuccessBlock)successBlock failure:(FailureBlock)failure netError:(ErrorBlock)errorBlock;";
}
- (NSString *)appendBlockInfoSource{
    return @"Success:(SuccessBlock)successBlock failure:(FailureBlock)failure netError:(ErrorBlock)errorBlock";
}

/**
 * 生成文件并存放到指定的目录下
 * @return 成功为YES 失败为NO
 * deprecated 目前弃用
 */
- (BOOL)generateFileAllowForHeader:(NSString *)name

{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *dirPath = [paths[0] stringByAppendingPathComponent:name];

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
    NSString *headFilePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.h",_className,name]];
    headFileFlag = [self.headerString writeToFile:headFilePath atomically:NO encoding:NSUTF8StringEncoding error:nil];

    NSString *sourceFilePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.m",_className,name]];
    sourceFileFlag =  [self.sourceString writeToFile:sourceFilePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    return headFileFlag;
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
 拼接 [NSString stringWithFormat:@"%@",@"report/report"] 的格式

 @param defString 拼接样式出产字符串
 @return 返回相对应的字符串
 */
- (NSString *)addDefppendString:(NSString *)defString {
    NSString *str1 = [defString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSString *str = [str1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSMutableString *muString = [NSMutableString string];
    [muString appendString:@"[NSString stringWithFormat:@"];
    [muString appendString:@"\""];
    [muString appendString:@"\%"];
    [muString appendString:@"@"];
    [muString appendString:@"\","];
    [muString appendString:@"@"];
    [muString appendString:@"\""];
    [muString appendString:str];
    [muString appendString:@"\""];
    [muString appendString:@"]"];

    return muString;
}

- (NSString *)urlHeaderBegin {

    NSMutableString *muString = [NSMutableString string];
    [muString appendString:@"#ifndef "];
    [muString appendFormat:@"%@URL_h\n",_className];
    [muString appendString:@"#define "];
    [muString appendFormat:@"%@URL_h\n",_className];
    return [NSString stringWithString:muString];
}

/**
 Description

 @return <#return value description#>
 */
- (NSString *)urlFooterEnd {

    NSMutableString *muString = [NSMutableString string];
    [muString appendString:@"#endif "];
    [muString appendFormat:@"/* %@URL_h */\n",_className];
    return [NSString stringWithString:muString];
}


/**
 添加备注 -  添加一行备注
 @param markString 需要添加的信息
 @return 备注信息
 */
- (NSString *)addMark:(NSString *)markString{
    NSMutableString *parmsString = [NSMutableString string];
    [parmsString appendString:[self addMarkHeader]];
    [parmsString appendString:[self addMarkBodyName:markString markName:@""]];
    [parmsString appendString:[self addMarkFooter]];
    return parmsString;
}

- (NSString *)addUrlMark:(NSString *)urlMarkString {
    NSMutableString *parmsString = [NSMutableString string];
    [parmsString appendString:@"/*"];
    [parmsString appendFormat:@"<#备注名称#"];
    [parmsString appendString:@">*/\n"];
    return parmsString;
}

- (NSString *)addMarkModel:(SHParmsModel *)parmsModel{
    NSMutableString *parmsString = [NSMutableString string];
    [parmsString appendString:[self addMarkHeader]];
    [parmsString appendString:[self addMarkBodyName:parmsModel.netParameterName markName:parmsModel.netNoteName]];
    [parmsString appendString:[self addMarkFooter]];
    return parmsString;
}


- (NSString *)addMarks:(NSArray <NSString *>*)marks {
    NSMutableString *parmsString = [NSMutableString string];
    [parmsString appendString:[self addMarkHeader]];
    for (int i = 0; i < marks.count; i++) {
        [self addMark:marks[i]];
    }
    [parmsString appendString:[self addMarkFooter]];
    return parmsString;
}

- (NSString *)addMarkModels:(NSArray <SHParmsModel *>*)marksModels {
    NSMutableString *parmsString = [NSMutableString string];
    [parmsString appendString:[self addMarkHeader]];
    for (int i = 0; i < marksModels.count; i++) {
        SHParmsModel *parmsModel = marksModels[i];
        [parmsString appendString:[self addMarkBodyName:parmsModel.netParameterName markName:parmsModel.netNoteName]];
    }
    [parmsString appendString:[self addMarkFooter]];
    return parmsString;
}


/**
 添加标注的头

 @return return value description
 */
- (NSString *)addMarkHeader{
    NSMutableString *headerString = [NSMutableString string];
    [headerString appendString:@"/**\n"];
    [headerString appendString:@"<#Description"];
    [headerString appendString:@"#>\n"];
    return headerString;
}

/**
 添加标注的body

 @return return value description
 */
- (NSString *)addMarkBodyName:(NSString *)name markName:(NSString *)markName{
    NSMutableString *bodyString = [NSMutableString string];
    [bodyString appendString:@"@param  "];
    [bodyString appendString:name];
    [bodyString appendString:@" "];
    [bodyString appendString:markName];
    [bodyString appendString:@"\n"];
    return bodyString;
}


//数组去重
- (NSArray *)removeRepeat:(NSArray *)reportArray {
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [reportArray count]; i++){
        if ([categoryArray containsObject:[reportArray objectAtIndex:i]] == NO){
            [categoryArray addObject:[reportArray objectAtIndex:i]];
        }
    }
    return categoryArray;
}

- (NSString *)addMarkFooter {
    NSMutableString *footerString = [NSMutableString string];
    [footerString appendString:@"\n*/\n"];
    return footerString;
}

- (NSMutableString *)headerString {

    if (!_headerString) {
        _headerString = [[NSMutableString alloc] init];
    }
    return _headerString;
}

- (NSMutableString *)sourceString {

    if (!_sourceString) {
        _sourceString = [[NSMutableString alloc] init];
    }
    return _sourceString;

}
/*只接受",@[@"NSString",@"NSInteger",@"float",@"double",@"BOOL",@"NSDate"];*/
- (NSString *)parmType:(NSString *)type {
    NSString *tem = [type stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSMutableString *muStr = [NSMutableString string];
    if ([tem isEqualToString:@"NSString"]) {
        [muStr appendString:@"(NSString *)"];
    }else{
        [muStr appendFormat:@"(%@)",type];
    }
    return muStr;
}

/**
 合并数组里面的同类项

 @param parms 合并同类项
 @return 合并同类项
 */
- (NSDictionary *)mergeParms:(NSArray <SHParmsModel *>*)parms {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.urls.count; i++) {
        [dict setObject:[NSMutableArray array] forKey:self.urls[i]];
    }

    for (int i = 0; i < parms.count; i++) {
        SHParmsModel * parm = parms[i];
        NSMutableArray *parmArr = dict[parm.netUrl];
        [parmArr addObject:parm];
        [dict setObject:parmArr forKey:parm.netUrl];
    }

    return dict;
}

/**在一个字符串外部加一对大括号**/
- (NSMutableString *)addBrackets:(NSString *)sourceString {
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"{\n\n"];
    [str appendString:sourceString];
    [str appendString:@"\n}\n"];
    return str;
}

/**在一个字符串外部加一对小括号**/
- (NSMutableString *)addParentheses:(NSString *)sourceString {
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"@("];
    [str appendString:sourceString];
    [str appendString:@")"];
    return str;
}

- (NSMutableString *)addUnifiedUrl:(NSString *)Url requestType:(NSString *)requestType{

    NSMutableString *tempStr = [NSMutableString string];
    [tempStr appendFormat:@" [MTHttpRequest_Helper %@RequestWithURL:%@ parameters:params success:^(id responseObject) {\n[self judgeReturnValueResponseObject:responseObject Success:^{\nif (successBlock) {\nsuccessBlock(responseObject);\n}\n} fauile:^{\nif (failure) {\nfailure(responseObject);\n}\n}];\n} failure:^(NSError *error, NSString *errorStr) {\nif (errorBlock) {\nerrorBlock(error);\n}\n}];",requestType,Url];
    return tempStr;
}

@end
