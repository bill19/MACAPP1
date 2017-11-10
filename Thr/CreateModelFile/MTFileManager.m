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
#import "SHFileHeader.h"
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
    [self.headerString appendString:[self creatFileHeaderClassName:self.className projectName:self.projectName developerName:self.developerName abString:self.abString isHeader:YES]];
    [self.headerString appendString:[SHTransform urlHeaderBeginclassName:self.className]];
    NSMutableArray *urlTempArr = [NSMutableArray array];
    for (NSUInteger index = 0; index < urlArray.count; index++) {
        SHParmsModel *parmsModel = [urlArray objectAtIndex:index];
        [urlTempArr addObject:parmsModel.netUrl];
    }
    NSArray *urls = [SHTransform removeRepeat:urlTempArr];
    self.urls = urls;
    for (int i = 0; i < urls.count; i++) {
        //去除空格
        NSString *urlStr1 = [[urls objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *urlStr = [urlStr1 stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        //创建 #define URL_NH_REPORT  的格式
        [self.headerString appendString:[SHTransform addUrlMark:@""]];
        NSString *temStr = [[urls[i] componentsSeparatedByString:@"/"] lastObject];
        [self.headerString appendFormat:@"#define URL_%@_%@ ",[self.abString uppercaseStringWithLocale:[NSLocale currentLocale]],[temStr uppercaseStringWithLocale:[NSLocale currentLocale]]];
        [self.headerString appendString:[SHTransform addDefppendString:urlStr]];
        [self.headerString appendString:@"\n\n\n"];
    }

    [self.headerString appendString:[SHTransform urlFooterEndclassName:self.className]];
    return [self generateFileAllowForHeader:@"URL" needSource:NO];
}

- (BOOL)creatRequestFileWithArray:(NSArray <SHParmsModel *>*)modelArray {

    self.headerString = [NSMutableString string];
    [self.headerString appendString:[self creatFileHeaderClassName:self.className projectName:self.projectName developerName:self.developerName abString:self.abString isHeader:YES]];
    //拼接上面的block回调
    [self.headerString appendString:k_Block_Success];
    [self.headerString appendString:k_Block_Failure];
    [self.headerString appendString:k_Block_Error];

    NSMutableString *sourceString = [NSMutableString string];
    [sourceString appendString:k_block_judgeHeader];

    NSDictionary *dict = [SHTransform mergeParms:modelArray urls:self.urls];
    for (NSString *url in self.urls) {
        /**插入方法信息*/
        NSMutableString *tempSourceString = [NSMutableString string];
        NSMutableString *parmsString = [NSMutableString string];
        NSArray *models = dict[url];
        for (int i = 0; i < models.count; i++) {
            SHParmsModel *parmModel = [models objectAtIndex:i];
            [parmsString appendString:parmModel.netParameterName];
            [parmsString appendString:@":"];
            [parmsString appendString:[SHTransform parmType:parmModel.netTypeName]];
            [parmsString appendString:parmModel.netParameterName];
            [parmsString appendString:@" "];
        }
        [tempSourceString appendString:[SHTransform addMarkModels:models]];
        [tempSourceString appendString:k_function_header([_abString uppercaseString],[[url componentsSeparatedByString:@"/"] lastObject],parmsString,k_function_footer,@";\n")];
        [sourceString appendString:tempSourceString];
    }
    NSString *str1 = [NSString stringWithFormat:@"%@Request",_className];
    [self.headerString appendFormat:k_CLASS,str1,sourceString];

    [self creatRequestFileSourceWithArray:modelArray];
    return  [self generateFileAllowForHeader:@"Request" needSource:YES];
}

- (BOOL)creatRequestFileSourceWithArray:(NSArray <SHParmsModel *>*)modelArray {

    self.sourceString = [NSMutableString string];
    [self.sourceString appendString:[self creatFileHeaderClassName:self.className projectName:self.projectName developerName:self.developerName abString:self.abString isHeader:NO]];
    NSMutableString *sourceString = [NSMutableString string];
    /**创建唯一调用方法*/
    NSDictionary *dict = [SHTransform mergeParms:modelArray urls:self.urls];
    for (NSString *url in self.urls) {
        /**插入方法信息*/
        NSMutableString *tempSourceString = [NSMutableString string];
        NSArray *models = dict[url];
        [tempSourceString appendString: [SHTransform addMarkModels:models]];

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
            [tempSourceString appendString:[SHTransform parmType:parmModel.netTypeName]];
            [tempSourceString appendString:parmModel.netParameterName];
            [tempSourceString appendString:@" "];
            //参数新增到内部
            NSMutableString *tempType =[NSMutableString string];
            if ([parmModel.netTypeName isEqualToString:@"NSString"]) {
                [tempType appendString:parmModel.netParameterName];
            }else{
                [tempType appendString:[SHTransform addParentheses:parmModel.netParameterName]];
            }
            [inputSourceString appendFormat:@"[self addParmWith:params mtobject:%@ mtkey:@\"%@\"];\n",tempType,parmModel.netParameterName];
            requestType = parmModel.netRequest;
        }
        [tempSourceString appendString:k_function_footer];
        [inputSourceString appendString:@"[self addParametersForDict:params];\n"];
        [inputSourceString appendString:k_function_requestBody([requestType uppercaseString], tempUrl)];
        inputSourceString = [SHTransform addBrackets:inputSourceString];
        [tempSourceString appendString:inputSourceString];
        [tempSourceString appendString:@"\n\n"];
        [sourceString appendString:tempSourceString];
        [sourceString appendString:@"\n"];
    }
    [sourceString appendString:k_function_addParm];
    [sourceString appendString:k_function_addParmWithDict];
    NSString *str1 = [NSString stringWithFormat:@"%@Request",_className];
    [self.sourceString appendFormat:k_CLASS_M,str1,sourceString];
    return YES;
}

/**
 创建文件的头信息
 */
- (NSString *)creatFileHeaderClassName:(NSString *)className projectName:(NSString *)projectName developerName:(NSString *)developerName abString:(NSString *)abString isHeader:(BOOL)isHeader{

    NSString *dateFull = [NSDate stringWithFormat:@"yyyy/MM/dd"];
    NSString *dateYear = [NSDate stringWithFormat:@"yyyy"];
    if (isHeader) {
       return  [NSString stringWithFormat:k_HEADINFO('h'),className,projectName,developerName,dateFull,dateYear,developerName];
    }else{
        NSString *classNameStr = [NSString stringWithFormat:@"%@Request",className];
        NSMutableString *tempStr = [NSMutableString stringWithFormat:k_HEADINFO('m'),classNameStr,projectName,_developerName,dateFull,dateYear,developerName,classNameStr];
        [tempStr appendFormat:@"#import \"%@URL.h\"",_className];
        [tempStr appendString:@"\n\n"];
      return  tempStr;
    }
}


/**
 * 生成文件并存放到指定的目录下
 * @return 成功为YES 失败为NO
 * deprecated 目前弃用
 */
- (BOOL)generateFileAllowForHeader:(NSString *)name needSource:(BOOL)needSource{
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
    if (needSource) {
        NSString *sourceFilePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.m",_className,name]];
        sourceFileFlag =  [self.sourceString writeToFile:sourceFilePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }

    if (needSource) {
        return headFileFlag;
    }else{
        return (headFileFlag&&sourceFileFlag);
    }
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
@end
