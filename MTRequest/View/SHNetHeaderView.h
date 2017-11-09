//
//  SHNetHeaderView.h
//  MACAPP1
//
//  Created by HaoSun on 2017/11/6.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SHNetLabel;
@interface SHNetHeaderView : NSView
@property (nonatomic, weak) SHNetLabel *classNameLabel;

@property (nonatomic, weak) SHNetLabel *progectLabel;

@property (nonatomic, weak) SHNetLabel *authoLabel;

/**
 前缀
 */
@property (nonatomic, weak) SHNetLabel *abLabel;

@end
