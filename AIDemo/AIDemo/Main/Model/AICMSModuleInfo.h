//
//  AICMSModuleInfo.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import <Foundation/Foundation.h>
#import "AICMSModuleDetailInfo.h"
NS_ASSUME_NONNULL_BEGIN

//页面模块
@interface AICMSModuleInfo : NSObject
@property (nonatomic, copy) NSString *name;//页面标题
@property (nonatomic, strong) NSArray <AICMSModuleDetailInfo *> *modules;//模块内容


@end

NS_ASSUME_NONNULL_END
