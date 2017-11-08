//
//  CreateModel.m
//  JsonToModelFileDemo
//
//  Created by 刘学阳 on 2017/9/20.
//  Copyright © 2017年 刘学阳. All rights reserved.
//

#import "CreateModel.h"
@interface CreateModel ()
//json 只读的 如果传入的json为格式化的格式 可获取原来的json
@property (nonatomic, copy) NSString *json;
//格式化json串后的数据
@property (nonatomic, strong) NSString *formatJson;
//存放多级model 的数组 弃用
@property (nonatomic, strong) NSMutableArray *mutiModelArray;
//存放多级model 的数组
@property (nonatomic, strong) NSMutableArray *allModelArray;
//拼接@class的字符串
@property (nonatomic, strong) NSMutableString *atString;

/**
 * 下面是实首字母大写的方法
 * @param className 类名 作用用来大写类名的首字母
 */
- (NSString *)upperFirstLetter:(NSString *)className;
/**
 * 下面是去除关键字的方法
 */
- (NSString *)takeOutKeyWord:(NSString *)string;
/**
 * 下面是将所有属性连接成字符串的方法
 */
inline NSString * getPropertyString(NSArray *propertys);
/**
 * 下面是将所有的键值对拼接的方法
 */
inline NSString * getAllKeyValueString(NSArray *objInArr);
/**
 * 创建文件
 */
- (BOOL)createFileAtPath:(NSString *)filePath;

/**
 * 处理数据 实现多层model分离
 * @param obj 字典或数组 key是字典情况下用 outerModel 外层model
 * @return NSDictionary @{@"allProperty":@[],@"objInArr":@[]}
 */
- (NSDictionary *)handleDateEngine:(id)obj forKey:(NSString *)key outerModel:(SingleModelAttribute *)outerModel;
/**
 * 下面是处理类名的方法
 * @param key key键 superClassName 父类
 */
- (NSString *)handleClassName:(NSString *)key superClassName:(NSString *)superClassName;
@end
@implementation CreateModel
#pragma mark - Lazy loading -
- (NSMutableArray *)mutiModelArray
{
    if (!_mutiModelArray) {
        _mutiModelArray = [[NSMutableArray alloc]init];
    }
    return _mutiModelArray;
}
- (NSMutableString *)headerString
{
    if (!_headerString) {
        _headerString = [[NSMutableString alloc]init];
        
    }
    return _headerString;
}
- (NSMutableString *)sourceString
{
    if (!_sourceString) {
        _sourceString = [[NSMutableString alloc]init];
    }
    return _sourceString;
}
- (NSMutableArray *)allModelArray
{
    if (!_allModelArray) {
        _allModelArray = [[NSMutableArray alloc]init];
    }
    return _allModelArray;
}
- (NSMutableString *)atString
{
    if (!_atString) {
        _atString = [[NSMutableString alloc]init];
    }
    return _atString;
}
#pragma mark - publick method -
/**
 * 验证json
 */
- (BOOL)verifyJson:(NSString *)json
{
    if (json == nil || json.length == 0)
    {
        _errorMsg = @"json为空";
        return NO;
    }
    NSError *error = nil;
    NSData  * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    BOOL result = NO;
    if (error)
    {
        _errorMsg = error.userInfo[@"NSDebugDescription"];
        result = NO;
    }else{
       result = YES;
    }
    return result;
}
/**
 * 格式化字符串
 * @param json json
 * deprecated 目前弃用
 */
- (BOOL)formatJson:(NSString *)json
{
    NSError *error = nil;
    NSData  * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    if (error)
    {
        __block NSString *formatStr = json;
        NSArray *beReplaceStrs = @[@";",@"(",@")"];
        NSArray *replaceStrs = @[@",",@"[",@"]"];
        for (NSInteger i = 0; i < replaceStrs.count; i++)
        {
            formatStr = [formatStr stringByReplacingOccurrencesOfString:beReplaceStrs[i] withString:replaceStrs[i]];
        }
        formatStr = [self replaceUnicode:formatStr];
        // format key
        NSRegularExpression *regkey = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z0-9_]+[ \r\n]{0,}[=]{1,1}?" options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *matchkey = [regkey matchesInString:formatStr options:NSMatchingReportProgress range:NSMakeRange(0, formatStr.length)];
        [matchkey enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSTextCheckingResult *result = obj;
            NSRange range = result.range;
            NSString *key = [formatStr substringWithRange:range];
            
            if (![key hasPrefix:@"http:"]&&![key hasPrefix:@"https:"]&&![key hasPrefix:@"file:"]&&![key hasPrefix:@"email:"]&&![key hasPrefix:@"tel:"])
            {
                NSRegularExpression *regkey = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z0-9_]+" options:NSRegularExpressionCaseInsensitive error:nil];
                
                NSString *replaceStr = [regkey stringByReplacingMatchesInString:key options:0 range:NSMakeRange(0, key.length) withTemplate:@"\"$0\""];
                
                formatStr = [formatStr stringByReplacingCharactersInRange:range withString:replaceStr];
                
            }
            
        }];
        // format value
        NSError *err = nil;
        NSString *pattern = @"[=][a-zA-Z0-9._ \\r\"\",~`:\\/!@#$%^&*()+=?\\u4e00-\\u9fa5]{1,}[,]{1,1}?";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&err];
        NSArray *matchValue = [regex matchesInString:formatStr options:NSMatchingCompleted range:NSMakeRange(0, formatStr.length)];
        
        NSString *regNumber=@"-?[0-9.?]+";
        NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regNumber];
        
        NSString *regStr = @"^[\"][a-zA-Z0-9._ \r"",~`:/!@#$%^&*()+=?\u4e00-\u9fa5]{0,}[\"]{1,1}$";
        NSPredicate *strPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regStr];
        NSPredicate *datePre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[0-9]{2}:[0-9]{2}"];
        [matchValue enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSTextCheckingResult *result = obj;
            NSRange range = result.range;
            NSString *value = [formatStr  substringWithRange:NSMakeRange(range.location + 1 , range.length - 2)];
            value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if (![value isEqualToString:@"\"\""]&&![numberPre evaluateWithObject:value]&&![strPre evaluateWithObject:value]&&![datePre evaluateWithObject:value])
            {
                formatStr = [formatStr stringByReplacingCharactersInRange:NSMakeRange(range.location + 1, range.length - 2) withString:[NSString stringWithFormat:@"\"%@\"",value]];
            }
            formatStr = [formatStr stringByReplacingOccurrencesOfString:@"=" withString:@":"];
            self.json = formatStr;
            
        }];
        _formatJson = self.json;
        NSError *erro = nil;
        jsonData = [_json dataUsingEncoding:NSUTF8StringEncoding];
        dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&erro];
        if (erro) {
            _errorMsg = erro.userInfo[@"NSDebugDescription"];
            return NO;
            
        }
    }else{
        self.json = json;
        _formatJson = dict.description;
    }
    
    return YES;
}
- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:nil error:nil];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}
/**
 * 格式化字符串
 * @param json json
 */
- (BOOL)formattingJson:(NSString *)json
{
    NSError *error = nil;
    NSData  * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    BOOL result = NO;
    if (error)
    {
        _errorMsg = error.userInfo[@"NSDebugDescription"];
        result = NO;
    }else{
        NSError *err;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&err];
        NSString *jsonString;
        if (!jsonData) {
            _errorMsg = err.userInfo[@"NSDebugDescription"];
            result = NO;
        }else{
            
            jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            _formatJson = jsonString;
            result = YES;
        }
    }
    return result;

}
/**
 * 创建出model
 * @param json json数据
 * @return BOOL 成功为YES json结构出错 会失败 返回NO allowMuti 允许多级
 */
- (BOOL)createModelWithJson:(NSString *)json allowMuti:(BOOL)allowMuti
{
    if (json == nil || json.length == 0)
    {
        return NO;
    }
    
    NSError *error = nil;
    NSData  * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    if (error)
    {
        return NO;
    }
    
    [self.headerString setString:@""];
    [self.sourceString setString:@""];
    
    if (_className == nil || _className.length == 0)
    {
        _className = k_DEFAULT_CLASS_NAME;
    }
    
    NSString *dateStr = [NSDate stringWithFormat:@"yyyy/MM/dd"];
    NSString *dateStr2 = [NSDate stringWithFormat:@"yyyy"];
    
    [self.headerString appendFormat:k_HEADINFO('h'),_className,_projectName,_developerName,dateStr,dateStr2,_developerName];
    [self.sourceString appendFormat:k_HEADINFO('m'),_className,_projectName,_developerName,dateStr,dateStr2,_developerName,_className];
    
    [self.allModelArray removeAllObjects];
    [self.atString setString:@""];
    SingleModelAttribute *firstModelAtt = [[SingleModelAttribute alloc]initWithClassName:_className];
    [self.allModelArray addObject:firstModelAtt];
    NSDictionary *propertyAndKeyValue = [self handleDateEngine:dict forKey:@"" outerModel:firstModelAtt];
    NSString *property = getPropertyString(propertyAndKeyValue[@"allProperty"]);
    property = [property stringByAppendingString:NSLocalizedString(@"methodDef",nil)];
    [firstModelAtt.headString appendFormat:k_CLASS,_className,property];
    
    NSString *keyValue = getAllKeyValueString(propertyAndKeyValue[@"objInArr"]);
    [firstModelAtt.sourceString appendFormat:k_CLASS_M,_className,[NSString stringWithFormat:@"%@%@",METHODIMP(keyValue),NSLocalizedString(@"jsonToModelMethod",nil)]];
    
    //拼接@class
    [self.headerString appendString:self.atString];
    //下面是拼接头文件和源文件
    for (NSInteger i = 0; i < self.allModelArray.count; i++)
    {
        SingleModelAttribute *modelAtt = self.allModelArray[i];
        [self.headerString appendFormat:@"%@", modelAtt.headString];
        [self.sourceString appendFormat:@"%@", modelAtt.sourceString];
    }
    
    return YES;
}
/**
 * 生成文件并存放到指定的目录下
 * @param muti 多级情况
 * @return 成功为YES 失败为NO
 * deprecated 目前弃用
 */
- (BOOL)generateFileAllowMuti:(BOOL)muti;

{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *dirPath = [paths[0] stringByAppendingPathComponent:@"ClassFiles"];
    
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
    NSString *headFilePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h",_className]];
    NSString *sourceFilePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",_className]];
    
    if (!muti) {
        headFileFlag = [self.headerString writeToFile:headFilePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
        
        sourceFileFlag =  [self.sourceString writeToFile:sourceFilePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
        
        if (headFileFlag && sourceFileFlag)
        {
            return YES;
        }
        return NO;
    }else{
        NSInteger i = 0;
        for (i = 0; i < self.mutiModelArray.count; i++)
        {
            MutiModelAttribute *modelAtt = self.mutiModelArray[i];
            headFilePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h",modelAtt.className]];
            sourceFilePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",modelAtt.className]];
            
            headFileFlag = [modelAtt.headString writeToFile:headFilePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
            
            sourceFileFlag =  [modelAtt.sourceString writeToFile:sourceFilePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
            
            if (headFileFlag && sourceFileFlag)
            {
                continue;
            }
            break;
            
        }
        if (i == self.mutiModelArray.count)
        {
            return YES;
        }
    }
    return NO;
}
/**
 * 生成文件并存放到指定的目录下
 * @return 成功为YES 失败为NO
 */
- (BOOL)generateFile
{
    NSString *dateStr = [NSDate stringWithFormat:@"yyyy-MM-dd"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *dirPath = [paths[0] stringByAppendingPathComponent:dateStr];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL dir = NO;
    BOOL exis = [fm fileExistsAtPath:dirPath isDirectory:&dir];
    if (!exis && !dir)
    {
        [fm createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    //删除该文件夹下的所有文件
//    NSArray *contents = [fm contentsOfDirectoryAtPath:dirPath error:nil];
//    NSEnumerator *e = [contents objectEnumerator];
//    NSString *filename;
//    while ((filename = [e nextObject])) {
//        
//        [fm removeItemAtPath:[dirPath stringByAppendingPathComponent:filename] error:NULL];
//        
//    }
    BOOL headFileFlag = [self generateHeaderFile];
    BOOL sourceFileFlag = [self generateSourceFile];
    
    if (headFileFlag && sourceFileFlag)
    {
        return YES;
    }
    return NO;

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
 * 下面是实首字母大写的方法
 * @param className 类名 作用用来大写类名的首字母
 */
- (NSString *)upperFirstLetter:(NSString *)className
{
    NSString *capStr = [className capitalizedStringWithLocale:[NSLocale currentLocale]];
    if ([capStr hasSuffix:@"es"])
    {
        capStr = [capStr substringToIndex:capStr.length - 2];
    }else if ([capStr hasSuffix:@"s"]){
        capStr = [capStr substringToIndex:capStr.length - 1];
    }
    return capStr;
}
/**
 * 下面是去除关键字的方法
 */
- (NSString *)takeOutKeyWord:(NSString *)string
{
    NSString *str = string;
    NSArray *keyWords = @[@"id",@"description"];
    for (NSInteger i = 0; i < keyWords.count; i++)
    {
        if ([string isEqualToString:keyWords[i]])
        {
            str = [string uppercaseString];
            break;
        }
        
    }
    return str;
}
/**
 * 下面是将所有属性连接成字符串的方法
 */
inline NSString * getPropertyString(NSArray *propertys)
{
    NSString *propertyStr = [propertys componentsJoinedByString:@""];
    return propertyStr;
}
/**
 * 下面是将所有的键值对拼接的方法
 */
inline NSString * getAllKeyValueString(NSArray *objInArr)
{
    NSString *allKeyValue = [objInArr componentsJoinedByString:@","];
    return allKeyValue;
}
/**
 * 创建文件
 */
- (BOOL)createFileAtPath:(NSString *)filePath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL sc = NO;
    if ([fm fileExistsAtPath:filePath])
    {
        return YES;
    }else{
        sc = [fm createFileAtPath:filePath contents:nil attributes:nil];
    }
    return sc;
}
/**
 * 处理数据 实现多层model分离
 * @param obj 字典或数组 key是字典情况下用 outerModel 外层model
 * @return NSDictionary @{@"allProperty":@[],@"objInArr":@[]}
 */
- (NSDictionary *)handleDateEngine:(id)obj forKey:(NSString *)key outerModel:(SingleModelAttribute *)outerModel
{
    if (!obj || [obj isEqual:[NSNull null]])
    {
        return nil;
    }
    
    NSMutableArray *propertyArr = [[NSMutableArray alloc]init];
    NSMutableArray *objInArr = [[NSMutableArray alloc]init];
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dic = (NSDictionary *)obj;
        NSArray *allKeys = [dic allKeys];
        for (NSInteger i = 0; i < allKeys.count; i++)
        {
            id subObj = dic[allKeys[i]];
            if ([subObj isKindOfClass:[NSDictionary class]])
            {
                
                NSString *className = [self handleClassName:allKeys[i] superClassName:outerModel.className];
                NSString *curKey = [self takeOutKeyWord:allKeys[i]];
                NSString *property = [NSString stringWithFormat:k_PROPERTY('s'),curKey,className,curKey];
                [propertyArr addObject:property];
                
                [self.atString appendFormat:k_AT_CLASS,className];
                SingleModelAttribute *modelAtt = [[SingleModelAttribute alloc]initWithClassName:className];
                [self.allModelArray addObject:modelAtt];
                NSDictionary *classContent = [self handleDateEngine:subObj forKey:allKeys[i] outerModel:modelAtt];
                NSString *curAllProperty = getPropertyString(classContent[@"allProperty"]);
                NSString *allKeyValue = getAllKeyValueString(classContent[@"objInArr"]);
                [modelAtt.headString appendFormat:k_CLASS,className,curAllProperty];
                [modelAtt.sourceString appendFormat:k_CLASS_M, className,METHODIMP(allKeyValue)];
                
            }else if ([subObj isKindOfClass:[NSArray class]]){
                
                NSString *className = [self handleClassName:allKeys[i] superClassName:outerModel.className];
                NSString *curKey = [self takeOutKeyWord:allKeys[i]];
                NSString *property = [NSString stringWithFormat:k_PROPERTY('s'),curKey,[NSString stringWithFormat:@"NSArray<%@ *>",className],curKey];
                [propertyArr addObject:property];
                
                NSString * keyValue = [NSString stringWithFormat:@"@\"%@\" : @\"%@\"",curKey,className];
                [objInArr addObject:keyValue];
                [self.atString appendFormat:k_AT_CLASS,className];
                SingleModelAttribute *modelAtt = [[SingleModelAttribute alloc]initWithClassName:className];
                [self.allModelArray addObject:modelAtt];
                NSDictionary *classContent = [self handleDateEngine:subObj forKey:allKeys[i] outerModel:modelAtt];
                NSString *curAllProperty = getPropertyString(classContent[@"allProperty"]);
                NSString *allKeyValue = getAllKeyValueString(classContent[@"objInArr"]);
                [modelAtt.headString appendFormat:k_CLASS,className,curAllProperty];
             
                [modelAtt.sourceString appendFormat:k_CLASS_M, className,METHODIMP(allKeyValue)];
                
                
            }else if ([subObj isKindOfClass:[NSString class]]){
                NSString *curKey = [self takeOutKeyWord:allKeys[i]];
                NSString *property = [NSString stringWithFormat:k_PROPERTY('c'),curKey,@"NSString",curKey];
                [propertyArr addObject:property];
            }else if ([subObj isKindOfClass:[NSNumber class]]){
                NSString *curKey = [self takeOutKeyWord:allKeys[i]];
                NSString *property = [NSString stringWithFormat:k_PROPERTY('s'),curKey,@"NSNumber",curKey];
                [propertyArr addObject:property];
            }else{
                if (subObj == nil || [subObj isEqual:[NSNull null]])
                {
                    NSString *curKey = [self takeOutKeyWord:allKeys[i]];
                    NSString *property = [NSString stringWithFormat:k_PROPERTY('c'),curKey,@"NSString",curKey];
                    [propertyArr addObject:property];
                    
                }
            }
        }
    }else if ([obj isKindOfClass:[NSArray class]]){
        NSArray *dicArray = (NSArray *)obj;
        if (dicArray.count > 0)
        {
            id tempObj = dicArray[0];
            for (NSInteger i = 1; i < dicArray.count; i++)
            {
                id subObj = dicArray[i];
                if([subObj isKindOfClass:[NSDictionary class]]){
                    if(((NSDictionary *)subObj).count > ((NSDictionary *)tempObj).count)
                    {
                        tempObj = subObj;
                    }
                }
            }
            NSDictionary *classContent = [self handleDateEngine:tempObj forKey:key outerModel:outerModel];
            NSString *property = getPropertyString(classContent[@"allProperty"]);
            [propertyArr addObject:property];
            
            NSString * keyValue = getAllKeyValueString(classContent[@"objInArr"]);
     
            [objInArr addObject:keyValue];

        }
    }else{
        NSLog(@"key = %@",key);
    }
    return @{@"allProperty" : propertyArr, @"objInArr" : objInArr};

}
/**
 * 下面是处理类名的方法
 * @param key key键 superClassName 父类
 */
- (NSString *)handleClassName:(NSString *)key superClassName:(NSString *)superClassName
{
    NSString *firstChar = [key substringToIndex:1];
    firstChar = [firstChar uppercaseString];
    NSString *capStr = [firstChar stringByAppendingString:[key substringFromIndex:1]];
    if ([capStr hasSuffix:@"es"])
    {
        capStr = [capStr substringToIndex:capStr.length - 2];
    }else if ([capStr hasSuffix:@"s"]){
        capStr = [capStr substringToIndex:capStr.length - 1];
    }
    capStr = [superClassName stringByAppendingString:capStr];
    return capStr;

}
@end
