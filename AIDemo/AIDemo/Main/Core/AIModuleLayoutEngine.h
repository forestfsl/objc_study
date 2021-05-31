//
//  AIModuleLayoutEngine.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class  AIModuleSuperLayout,AIModuleSuperCellModel,AIModuleStateMachine;

@interface AIModuleLayoutEngine : UICollectionViewFlowLayout
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UIScrollViewDelegate
>
{
    
}

//布局列表
@property (nonatomic, strong) NSArray<__kindof AIModuleSuperLayout *> *layouts;
//数据(嵌套数组，第一层是section，四二层：row)
@property (nonatomic, strong,readonly) NSArray<NSMutableArray<AIModuleSuperCellModel *> *> *models;
//布局属性列表
@property (nonatomic, strong, readonly) NSArray<NSArray<UICollectionViewLayoutAttributes *> *> *attArray;

@property (nonatomic, assign, readonly) CGSize contentSize;

//滑动回调
@property (nonatomic, copy) void(^scrollViewDidScroll)(UIScrollView *scrollView);
@property (nonatomic, copy) void(^scrollViewDidEndDraggingAndDecelerate)(UIScrollView *scrollView,BOOL decelerate);
@property (nonatomic, copy) void(^scrollViewDidEndDecelerating)(UIScrollView *scrollView);
@property (nonatomic, copy) void(^scrollViewDidEndScrollingAnimation)(UIScrollView *scrollView);
@property (nonatomic, copy) void(^collectionViewContentSizeDidUpdate)(CGSize contentSize);

/**
 绑定滑动方向
 @param scrollDirection 方向
 */
- (void)bindCollectionViewDelegateWithScrollDirection:(UICollectionViewScrollDirection)scrollDirection;

/**
 注册Cell类型及数据类型
 @param cellClass cell 类型
 @param modelClass 数据类型
 */
- (void)registerCellClass:(Class)cellClass modelClass:(Class)modelClass;

/**
 刷新cell
 @param model 数据
 */
- (void)reloadCellModel:(__kindof AIModuleSuperCellModel *)model;

/**
 刷新数据
 @param indexPaths 坐标
 */
- (void)reloadIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

//刷新
- (void)reloadData;

/**
 查找cell数据
 @param mId 数据Id
 @param toIndexPath 所在section
 */
- (__kindof AIModuleSuperCellModel *)findCellModelWithMId:(NSString *)mId toIndexPath:(NSIndexPath * __autoreleasing *)toIndexPath;

/**
 查找布局信息
 @param layoutId 布局信息Id
 @param toSection 所在Section
 */
- (__kindof AIModuleSuperLayout *)findSectionLayoutWithLayoutId:(NSString *)layoutId toSection:(NSInteger *)toSection;

/**
 替换Cell数据
 @param mId 数据Id
 @param toModel 需要更换的数据
 */
- (void)replaceCellModelWithMid:(NSString *)mId replaceModel:(__kindof AIModuleSuperCellModel *)toModel;

/**
 添加状态机
 @param machine 状态机
 */
- (void)addCellModelStateMachine:(AIModuleStateMachine *)machine;

/**
 移除状态机
 @param mId 状态机Id
 */
- (void)removeCellModelStateMachineWithMId:(NSString *)mId;

/**
 查找状态机
 @param mId 状态机Id
 */
- (AIModuleStateMachine *)findStateMachineWithMId:(NSString *)mId;



@end

NS_ASSUME_NONNULL_END
