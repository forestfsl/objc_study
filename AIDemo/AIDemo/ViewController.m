//
//  ViewController.m
//  AIDemo
//
//  Created by fengsl on 2021/5/28.
//

#import "ViewController.h"
#import "NSData+YYAdd.h"
#import "UIScrollView+Extension.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <MJRefresh/MJRefresh.h>
#import "AICMSModuleInfo.h"
#import <MJExtension/MJExtension.h>
#import "AICMSManager.h"
#import "AIModuleSuperCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"defaultTemplateContent:%@",[self defaultTemplateContent]);
    [self beginRefresh];
    [self loadData];
}

- (void)beginRefresh{
    [self.collectionView headerPulldownRefreshing:^{
        [self loadData];
    }];
}

- (void)loadData{
 
    NSDictionary *responseDict = [self defaultTemplateContent];
    AICMSModuleInfo *info = [AICMSModuleInfo mj_objectWithKeyValues:responseDict];
    NSString *vcTitle = info.name;
    if (vcTitle && [vcTitle isKindOfClass:[NSString class]] && vcTitle.length <= 0) {
        self.title = vcTitle;
    }
    NSArray <AIModuleSuperLayout *> *layouts = [self createModuleLayoutListWithModules:info.modules vcTitle:[self analyticsTitle]];
    self.flow.layouts = layouts;
    [self.collectionView endRefrehing];
    [self reloadData];
}

- (NSDictionary *)defaultTemplateContent {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"course" ofType:@"json"];;
   
    NSData *contentData = [NSData dataWithContentsOfFile:filePath];
    if (contentData && contentData.length > 0) {
        return [contentData jsonValueDecoded];
    }
    return nil;
}

- (NSArray <AIModuleSuperLayout *> *)createModuleLayoutListWithModules:(NSArray <AICMSModuleDetailInfo *> *)modules vcTitle:(NSString *)vcTitle{
    if (!modules || ![modules isKindOfClass:[NSArray class]] || modules.count <= 0) {
        return nil;
    }
    
    NSMutableArray *layouts = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    __block NSMutableArray <AICMSModuleDetailInfo *> *specialTemplates = [[NSMutableArray alloc]init];
    [modules enumerateObjectsUsingBlock:^(AICMSModuleDetailInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([weakSelf isSpecialTemplateWithId:[obj.moduleTemplateId integerValue]]) {//特殊模板
            [specialTemplates addObject:obj];
        }else{
            AIModuleSuperLayout *layout =  [weakSelf createModuleLayoutWithInfo:obj vcTitle:vcTitle];
            if (layout) {
                [layouts addObject:layout];
            }
        }
    }];
    [self handlingSpecialTemplateWithContent:specialTemplates];
    return layouts;
}

- (AIModuleSuperLayout *)createModuleLayoutWithInfo:(AICMSModuleDetailInfo *)info vcTitle:(NSString *)vcTitle{
    if (!info) {
        return nil;
    }
    NSString *moduleTemplateId = info.moduleTemplateId;
    if (!moduleTemplateId) {
        return nil;
    }
    AICMSManager *cmsManager = [AICMSManager sharedInstance];
    NSString *templateClassString = [cmsManager findTemplateClassWithTemplateId:moduleTemplateId];
    if (!templateClassString || ![templateClassString isKindOfClass:[NSString class]] || templateClassString.length <= 0) {
        return nil;
    }
    Class templateClass = NSClassFromString(templateClassString);
    if (!templateClass) {
        return nil;
    }
    if (![templateClass isSubclassOfClass:[AIModuleSuperCell class]]) {
        return nil;
    }
    if (![[templateClass templateId] isEqualToString:moduleTemplateId]) {//做多一次确认
        return nil;
    }
    return [templateClass createCellLayoutWithDataSource:info vcTitle:vcTitle];
}


/// 处理特殊模版
/// @param contentInfo 特殊模版内容
- (void)handlingSpecialTemplateWithContent:(NSArray<AICMSModuleDetailInfo *> *)contentInfo {
    NSLog(@"特殊模版，需要业务各自定制处理");
}


//是不是特殊模板
- (BOOL)isSpecialTemplateWithId:(NSInteger)templateId{
    if (templateId <= 0) {
        return NO;
    }
    NSArray <NSNumber *> *templateIdList = [self specialTemplateIds];
    if (templateIdList && [templateIdList isKindOfClass:[NSArray class]] && templateIdList.count > 0) {
        __block BOOL isSpecial = NO;
        [templateIdList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (templateId == [obj integerValue]) {
                isSpecial = YES;
                *stop = YES;
            }
        }];
        return isSpecial;
    }
    return NO;
}

#pragma mark - 特殊模板
//需要特殊处理的模板Id列表
- (NSArray <NSNumber *> *)specialTemplateIds{
    NSLog(@"如有特殊模板，请返回定制的特殊模板Id");
    return nil;
}

@end
