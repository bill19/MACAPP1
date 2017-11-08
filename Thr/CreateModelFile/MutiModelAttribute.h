//
//  MutiModelAttribute.h
//  JsonToModelFileDemo
//
//  Created by 刘学阳 on 2017/9/20.
//  Copyright © 2017年 刘学阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Extension.h"
#define k_HEADINFO(h) ((h) == 'h' ? @("//\n//  %@.h\n//  %@\n//  Created by %@ on %@.\n//  Copyright © %@年 %@. All rights reserved.\n//\n\n#import <Foundation/Foundation.h>\n#import \"MJExtension.h\" \n") :@("//\n//  %@.m\n//  %@\n//  Created by %@ on %@.\n//  Copyright © %@年 %@. All rights reserved.\n//\n\n#import \"%@.h\"\n"))
#define k_DEFAULT_CLASS_NAME @("Model")
#define k_AT_CLASS @("@class %@;\n")
#define k_CLASS       @("\n@interface %@ : NSObject\n%@\n@end\n\n")
#define k_PROPERTY(s)    ((s) == 'c' ? @("\n/** <#%@#>*/\n@property (nonatomic, copy) %@ *%@;\n") : @("\n/** <#%@#>*/\n@property (nonatomic, strong) %@ *%@;\n"))

#define METHODIMP(keyValue) [NSString stringWithFormat:NSLocalizedString(@"method",nil),keyValue]
#define k_CLASS_M     @("\n\n@implementation %@\n%@\n@end\n")

@interface MutiModelAttribute : NSObject
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSMutableString *headString;
@property (nonatomic, strong) NSMutableString *sourceString;

- (instancetype)initWithClassName:(NSString *)className;
@end



