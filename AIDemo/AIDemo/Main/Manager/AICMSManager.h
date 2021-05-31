//
//  AICMSManager.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import <Foundation/Foundation.h>
#import "AICMSTemplateInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AICMSDidSelectedCellHandler)(id cellModel,NSIndexPath *indexPath);
typedef void (^AICMSReportEventHandler)(id cellModel,NSIndexPath *indexPath);

@interface AICMSManager : NSObject

@property (nonatomic, copy) AICMSReportEventHandler reportEventHandler;//上报埋点回调
@property (nonatomic, copy) AICMSDidSelectedCellHandler didSelectedCellHandler;//点击事件埋点
@property (nonatomic, copy) AICMSReportEventHandler reportWillAppearEventHandler;//上报曝光埋点事件埋点回调

+ (AICMSManager *_Nonnull)sharedInstance;

/**
 找到模板对应的Class
 @param templateId 模板Id
 */
- (NSString *)findTemplateClassWithTemplateId:(NSString *)templateId;

/**
 添加自定义模板
 @param c_templates 模板信息
 */
- (void)addCustomTemplates:(NSArray <AICMSTemplateInfo *> *)c_templates;

/**
 获取注册模板
 */
- (NSDictionary <NSString *,NSString *> *)getRegisterTemplateModels;

@end

NS_ASSUME_NONNULL_END
