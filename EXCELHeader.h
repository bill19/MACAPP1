//
//  EXCELHeader.h
//  MACAPP1
//
//  Created by HaoSun on 2017/11/8.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#ifndef EXCELHeader_h
#define EXCELHeader_h
/emptyVisit/myEmptyVisitPager    ~    userId    ~    用户id    ~    NSString    ~    GET    ;
/emptyVisit/myEmptyVisitPager    ~    pageNo    ~    当前分页号    ~    NSInteger    ~    GET    ;
/emptyVisit/myEmptyVisitPager    ~    pageSize    ~    每页多少条数据    ~    NSInteger    ~    GET    ;
/emptyVisit/initEmptyVisitPage    ~    userId    ~    用户id    ~    NSString    ~    GET    ;
/emptyVisit/initEmptyVisitPage    ~    stageId    ~    楼盘分期ID    ~    NSString    ~    GET    ;
/emptyVisit/saveAppointment    ~    oldEmptyVisitId    ~    旧空看ID    ~    NSString    ~    POST    ;
/emptyVisit/saveAppointment    ~    newEmptyVisitId    ~    新空看ID    ~    NSString    ~    POST    ;
/emptyVisit/saveAppointment    ~    userId    ~    申请人的Old用户Id    ~    NSString    ~    POST    ;
/emptyVisit/saveAppointment    ~    stageId    ~    空看楼盘分期ID    ~    NSString    ~    POST    ;
#endif /* EXCELHeader_h */
