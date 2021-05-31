//
//  AICMSModuleDetailInfo.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import <Foundation/Foundation.h>
#import "AICMSCustomFieldInfo.h"
#import "AICMSModuleContentInfo.h"

NS_ASSUME_NONNULL_BEGIN

//模块详情
@interface AICMSModuleDetailInfo : NSObject
@property (nonatomic, copy) NSString *marginBottom;//模块下间距
@property (nonatomic, copy) NSString *moduleId;//模块id
@property (nonatomic, copy) NSString *moduleTemplateId;//末班id
@property (nonatomic, copy) NSString *name;//模块名
@property (nonatomic, copy) NSString *title;//模块标题

@property (nonatomic, strong) NSArray <AICMSCustomFieldInfo *> *customFields;//模块扩展字段
@property (nonatomic, strong) NSArray <AICMSModuleContentInfo *> *contents;//内容详情

@end

NS_ASSUME_NONNULL_END
