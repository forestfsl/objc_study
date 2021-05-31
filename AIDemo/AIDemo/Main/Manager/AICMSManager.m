//
//  AICMSManager.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AICMSManager.h"
#import "AIBannerCell.h"
#import "AIEntranceCell.h"
#import "AILessonCardCell.h"
#import "AICMSTipsCell.h"
#import "AILessonCardCellV2.h"
#import "AICMSAREntryCell.h"
#import "AICMSEventEntryCell.h"

@interface AICMSManager()
@property (nonatomic, strong) NSMutableDictionary <NSString *,NSString *> *templates;//模板id：cell
@property (nonatomic, strong) NSMutableDictionary <NSString *,NSString *> *templateModels;//模板cellClass：modelClass

@end


@implementation AICMSManager

static AICMSManager *sharedInstance = nil;

+ (AICMSManager *_Nonnull)sharedInstance{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[AICMSManager alloc]init];
    });
    return sharedInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        [self initializeTemplates];
    }
    return self;
}

- (void)initializeTemplates{
    if (!_templates) {
        _templates  = [[NSMutableDictionary alloc]init];
    }
    if (!_templateModels) {
        _templateModels = [[NSMutableDictionary alloc]init];
    }
    [self addCustomTemplates:[self defaultTemplateInfos]];
}

//默认模板信息
- (NSArray <AICMSTemplateInfo *> *)defaultTemplateInfos{
    return @[[AIModuleSuperCell templateInfo],
    [AIBannerCell templateInfo],
    [AIEntranceCell templateInfo],
    [AILessonCardCell templateInfo],
    [AICMSEventEntryCell templateInfo],
    [AILessonCardCellV2 templateInfo],
    [AICMSAREntryCell templateInfo],
    [AICMSTipsCell templateInfo]];
}

/**
 找到模板对应的Class
 @param templateId 模板Id
 */
- (NSString *)findTemplateClassWithTemplateId:(NSString *)templateId{
    if (!templateId || ![templateId isKindOfClass:[NSString class]] || templateId.length <= 0) {
        return nil;
    }
    if (_templates.count <= 0) {
        return nil;
    }
    return _templates[templateId];
}

/**
 添加自定义模板
 @param c_templates 模板信息
 */
- (void)addCustomTemplates:(NSArray <AICMSTemplateInfo *> *)c_templates{
    if (!c_templates || c_templates.count <= 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [c_templates enumerateObjectsUsingBlock:^(AICMSTemplateInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *templateId = [obj.templateId copy];
        NSString *templateUIClass = obj.templateUIClass;
        NSString *templateModelClass = obj.templateModelResueIdentifier;
        if (!templateId || ![templateId isKindOfClass:[NSString class]] || templateId.length <= 0
                             || !templateUIClass || ![templateUIClass isKindOfClass:[NSString class]] || templateId.length <= 0
            ||!templateModelClass || ![templateUIClass isKindOfClass:[NSString class]] || templateModelClass.length <= 0) {
            NSLog(@"addCustomTemplates templates has Error:%@-%@-%@",templateId,templateUIClass,templateModelClass);
            return;
        }
        [weakSelf.templates addEntriesFromDictionary:@{templateId:templateUIClass}];
        [weakSelf.templateModels addEntriesFromDictionary:@{templateUIClass:templateModelClass}];
    }];
}

/**
 获取注册模板
 */
- (NSDictionary <NSString *,NSString *> *)getRegisterTemplateModels{
    return [_templateModels copy];
}

@end
