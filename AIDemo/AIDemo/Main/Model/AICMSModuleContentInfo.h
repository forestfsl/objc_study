//
//  AICMSModuleContentInfo.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import <Foundation/Foundation.h>
#import "AICMSCustomFieldInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface AICMSModuleContentInfo : NSObject
@property (nonatomic, copy) NSString *contentId;//内容id
@property (nonatomic, copy) NSString *eventTrackingName;//埋点名称
@property (nonatomic, copy) NSString *name;//内容名称
@property (nonatomic, copy) NSString *priority;//优先级

@property (nonatomic, strong) NSArray <AICMSCustomFieldInfo *> *customFields;//模块扩展字段

@end

NS_ASSUME_NONNULL_END
