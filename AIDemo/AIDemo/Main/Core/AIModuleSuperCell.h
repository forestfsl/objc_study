//
//  AIModuleSuperCellModel.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AICMSModuleDetailInfo.h"
#import "AIModulePrivate.h"



@class AICMSTemplateInfo;
NS_ASSUME_NONNULL_BEGIN

@interface AIModuleSuperCellModel : NSObject

//模型Id
@property (nonatomic, copy, nullable) NSString *moduleId;
//cell 的背景色
@property (nonatomic, strong) UIColor *backgroundColor;
//cell是否可点击
@property (nonatomic, assign, getter=isDisable) BOOL disable;
//超出屏幕的是否需要裁减
@property (nonatomic, assign) BOOL clipsToBounds;
//圆角类型
@property (nonatomic, assign) UIRectCorner corners;
//圆角半径Size[优先级:cornerRadius > corderRadii]
@property (nonatomic, assign) CGSize cornerRadii;
// 圆角半径, [优先级:cornerRadius  >  cornerRadii]
@property (nonatomic, assign) CGFloat cornerRadius;
//Border 宽度
@property (nonatomic, assign) CGFloat borderWidth;
//Border 颜色
@property (nonatomic, strong) UIColor *borderColor;
//Border类型,default:ALLayerBorderAll
@property (nonatomic, assign) ALLayerBorder borders;
//阴影颜色
@property (nonatomic, strong) UIColor *shadowColor;
//阴影透明度
@property (nonatomic, assign) CGFloat shadowOpacity;
//阴影圆角半径
@property (nonatomic, assign) CGFloat shadowRadius;
//阴影偏移
@property (nonatomic, assign) CGSize shadowOffset;
//透明度 default：1
@property (nonatomic, assign) CGFloat alpha;
//单列唯一标识
@property (nonatomic, copy) NSString *singeIdentifier;
//点击回调方法
@property (nonatomic, copy) void(^ didSelectedHandler)(__kindof AIModuleSuperCellModel *model,NSIndexPath *indexPath);
//显示回调方法
@property (nonatomic, copy) void (^ didAppearHandler)(__kindof AIModuleSuperCellModel *model,NSIndexPath *indexPath);
//消失回调方法
@property (nonatomic, copy) void (^ didDisappearHandler)(__kindof AIModuleSuperCellModel *model,NSIndexPath *indexPath);

//唯一标识
+ (NSString *)resueIdentifier;

//业务数据(Common)
@property (nonatomic, copy) NSString *content_title;//对应eventTrackingName;
@property (nonatomic, copy) NSString *module_id;
@property (nonatomic, copy) NSString *template_title;
@property (nonatomic, copy) NSString *content_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *location_order;
@property (nonatomic, copy) NSString *jumpUrl;
@property (nonatomic, assign) BOOL requireLogin;

@end


@class AIModuleSuperLayout;
//抽象父类Cell
@interface AIModuleSuperCell : UICollectionViewCell

//数据Model
@property (nonatomic, readonly) __kindof AIModuleSuperCellModel *model;

//模板Id
+ (NSString *)templateId;
+ (NSString *)templateModelResueIdentifier;

/**
 设置数据Model
 @param model 数据
 */
- (void)setupCellModel:(__kindof AIModuleSuperCellModel *)model;

//Cell 正要加载
- (void)cellDidLoad;
//Cell 正要显示
- (void)cellDidAppear;
//Cell 正要消失
- (void)cellDidDisappear;

+ (AICMSTemplateInfo *)templateInfo;

+ (AIModuleSuperLayout *)createCellLayoutWithDataSource:(AICMSModuleDetailInfo *)dataSouce vcTitle:(NSString *)vcTitle;

@end

NS_ASSUME_NONNULL_END
