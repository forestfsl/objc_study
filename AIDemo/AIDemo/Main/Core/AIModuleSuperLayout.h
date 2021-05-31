//
//  AIModuleSuperLayout.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AIModulePrivate.h"


NS_ASSUME_NONNULL_BEGIN


@class AIModuleSuperCellModel,AIModuleLayoutAttribute;

//布局方式
@interface AIModuleSuperLayout : NSObject

//布局类型标识
@property (nonatomic, copy,nullable) NSString *layoutType;

//布局id
@property (nonatomic, copy,nullable) NSString *layoutId;

//第一层item，insets，zIndex相等，支持嵌套layout或者cellModel
@property (nonatomic, strong, nullable) NSArray *cellModels;

//组合子layout
@property (nonatomic, strong, nullable) NSArray<__kindof AIModuleSuperLayout *> *subLayouts;
//该layout的zIndex的偏移，cell的zIndex=该layout的zIndex+父layout的zIndex
@property (nonatomic, assign) NSInteger zIndex;
//整个布局与父容器的边距，外边距
@property (nonatomic, assign) UIEdgeInsets insets;
//布局内容边距，内边距
@property (nonatomic, assign) UIEdgeInsets contentInsets;
//子layout之间相互关系
@property (nonatomic, strong) AIModuleLayoutAttribute *childLayoutsAttribute;
//layout 的x、y偏移值，用于内部计算
@property (nonatomic, assign) CGPoint layoutOffset;
//指定layout宽度
@property (nonatomic, assign) CGFloat layoutWidth;
//指定layout宽度与容器宽度占比
@property (nonatomic, assign) CGFloat layoutWidthScale;


@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) UIColor *borderColor;
@property (nonatomic, assign) UIRectCorner corners;
@property (nonatomic, assign) ALLayerBorder borders;
@property (nonatomic, assign) CGSize cornerRadii;
@property (nonatomic, assign) UIColor *shadowColor;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) BOOL backgroundCellDisable;
@property (nonatomic, copy) void(^backgroundCellDidSelectedHandler)(__kindof AIModuleSuperCellModel *model, NSIndexPath *indexPath);
@property (nonatomic, copy) void(^backgroundCellDidAppearHandler)(__kindof AIModuleSuperCellModel *model,NSIndexPath *indexPath);
@property (nonatomic, copy) void(^backgroundCellDidDisappearHandler)(__kindof AIModuleSuperCellModel *model,NSIndexPath *indexPath);

/**
 配置layout的总宽度
 @param collectionView collectionview
 @param size 容器区域
 @param index layout 的collection flow或者subLayouts中的索引
 @return 高度
 */
- (CGFloat)layoutHeightForCollectionView:(UICollectionView *)collectionView atLayoutSize:(CGSize)size atLayoutIndex:(NSInteger)index;

/**
 配置cellModels相对于layout容器区域的frame
 @param collectionView collectionView
 @param size 容器区域
 @param index layout 的collection flow或者subLayouts中的索引
 @return frame
 */
- (NSArray<NSValue *> *)rectOfCellModelsForCollectionView:(UICollectionView *)collectionView atLayoutSize:(CGSize)size atLaoutIndex:(NSInteger)index;

/**
 通过id查找layout
 @param layoutId id
 @return layout
 */
- (__kindof AIModuleSuperLayout *)findSubLayoutWithLayoutId:(NSString *)layoutId;

@end

NS_ASSUME_NONNULL_END
