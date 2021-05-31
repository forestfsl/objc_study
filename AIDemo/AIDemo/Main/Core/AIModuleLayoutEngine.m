//
//  AIModuleLayoutEngine.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AIModuleLayoutEngine.h"
#import "AIModuleLayoutContext.h"
#import "AIModuleSuperCell.h"
#import "AIModuleLayoutAttribute.h"
#import "AIModuleSuperLayout.h"
#import "AIModuleStateMachine.h"


@interface AIModuleLayoutEngine(){
    CGSize _tSize;
}

@property (nonatomic, strong) NSMutableArray<AIModuleStateMachine *> *stateMachines;
//数据 （嵌套数组，第一层是Section，第二次：row）
@property (nonatomic, strong) NSArray<NSMutableArray<AIModuleSuperCellModel *> *> *models;
//布局属性列表
@property (nonatomic, strong) NSArray<NSArray<UICollectionViewLayoutAttributes *> *> *attArray;

/**
 递归函数，计算传入的layout和子layout上cell的UICollectionViewLayoutAttributes
 @param context 画布信息
 @param layout 样式组件
 @return cell 约束关系
 */
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)createLayoutAttributesForContext:(AIModuleLayoutContext *)context layout:(__kindof AIModuleSuperLayout *)layout;

@end


@implementation AIModuleLayoutEngine

- (void)dealloc{
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
}

- (instancetype)init{
    if (self = [super init]) {
        self.stateMachines = [NSMutableArray array];
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        self.itemSize = CGSizeMake(1, 1);
    }
    return self;
}

- (void)bindCollectionViewDelegateWithScrollDirection:(UICollectionViewScrollDirection)scrollDirection{
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.scrollDirection = scrollDirection;
    if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.alwaysBounceHorizontal = YES;
    }else{
        self.collectionView.alwaysBounceVertical = YES;
    }
    self.collectionView.backgroundColor = [UIColor clearColor];
}

/**
 注册Cell类型及数据类型
 @param cellClass cell 类型
 @param modelClass 数据类型
 */
- (void)registerCellClass:(Class)cellClass modelClass:(Class)modelClass{
    if ([cellClass isSubclassOfClass:[AIModuleSuperCell class]] && [modelClass isSubclassOfClass:[AIModuleSuperCellModel class]]) {
        [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:[modelClass resueIdentifier]];
    }
}

///继承自定义方法
/**
 会调用三次
 1.第一次初始化Layout
 2.第二次刷新Layout
 3.第三次- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds 方法返回Yes
 */
- (void)prepareLayout{
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        [self prepareLayoutAtDirectionHorizontal];
    }else{
        [self prepareLayoutAtDirectionVertical];
    }
    [super prepareLayout];
}

#pragma mark -核心代码
///水平布局
- (void)prepareLayoutAtDirectionHorizontal{
    CGFloat contentHeight = self.collectionView.bounds.size.height;
    __block CGFloat contentWidth = 0;
    _attArray = @[];
    _models = @[];
    NSMutableArray *tmp = [NSMutableArray array];
    NSMutableArray *models = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [self.layouts enumerateObjectsUsingBlock:^(__kindof AIModuleSuperLayout * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat layoutW = 0;
        if (obj.layoutWidth > 0) {
            layoutW = obj.layoutWidth;
        }else if (obj.layoutWidthScale > 0){
            layoutW = (contentWidth - obj.insets.left - obj.insets.right) * obj.layoutWidthScale;
        }else{
            layoutW = (contentWidth - obj.insets.left - obj.insets.right);
        }
        CGSize size = CGSizeMake(layoutW, contentHeight - obj.insets.top - obj.insets.bottom);
        CGFloat beginY = obj.insets.top;
        CGFloat aH = [obj layoutHeightForCollectionView:weakSelf.collectionView atLayoutSize:CGSizeMake(size.width - obj.contentInsets.left - obj.contentInsets.right, size.height - obj.contentInsets.top - obj.contentInsets.bottom) atLayoutIndex:idx];
        aH += obj.contentInsets.top;
        aH += obj.contentInsets.bottom;
        
        AIModuleLayoutContext *context = [AIModuleLayoutContext new];
        context.zIndex = obj.zIndex;
        context.x = contentWidth + obj.insets.left + (idx > 0 ? weakSelf.minimumLineSpacing : 0);
        context.y = beginY;
        if (obj.childLayoutsAttribute) {
            if (obj.childLayoutsAttribute.centerX != AIModuleUndefineValue) {
                context.x = context.x + (size.width - layoutW) / 2;
            }
            if (obj.childLayoutsAttribute.centerY != AIModuleUndefineValue) {
                context.y = beginY + (size.height = aH) / 2;
            }
        }
        size.height = aH;
        context.size = size;
        context.section = idx;
        context.beginRow = 0;
        [tmp addObject:[weakSelf createLayoutAttributesForContext:context layout:obj]];
        [models addObject:[weakSelf toModelsForLayout:obj]];
        contentWidth += layoutW;
        contentWidth += obj.insets.left;
        contentWidth += obj.insets.right;
    }];
    _attArray = tmp;
    _models = models;
    _tSize  = CGSizeMake(contentWidth, contentHeight);
    [self updateCollectionViewConstraintsWithSize:_tSize];
}

- (void)updateCollectionViewConstraintsWithSize:(CGSize)contentSize{
  if (_collectionViewContentSizeDidUpdate) {
    _collectionViewContentSizeDidUpdate(contentSize);
  }
}

///纵向布局
- (void)prepareLayoutAtDirectionVertical{
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    __block CGFloat contentHeight = 0;
    _attArray = @[];
    _models = @[];

    NSMutableArray *tmp = [NSMutableArray array];
    NSMutableArray *models = [NSMutableArray array];

    __weak typeof(self) weakSelf = self;
    [self.layouts enumerateObjectsUsingBlock:^(__kindof AIModuleSuperLayout *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        CGFloat layoutW = 0;
        if (obj.layoutWidth > 0) {
            layoutW = obj.layoutWidth;
        } else if (obj.layoutWidthScale > 0) {
            layoutW = (contentWidth - obj.insets.left - obj.insets.right) * obj.layoutWidthScale;
        } else {
            layoutW = contentWidth - obj.insets.left - obj.insets.right;
        }
        CGSize size = CGSizeMake(layoutW, 40);
        CGFloat beginY = contentHeight + obj.insets.top;
        CGFloat aH = [obj layoutHeightForCollectionView:weakSelf.collectionView
                                           atLayoutSize:CGSizeMake(size.width - obj.contentInsets.left - obj.contentInsets.right, 40)
                                          atLayoutIndex:idx];
        aH += obj.contentInsets.top;
        aH += obj.contentInsets.bottom;
        contentHeight += aH;
        contentHeight += obj.insets.top;
        contentHeight += obj.insets.bottom;

        AIModuleLayoutContext *context = [AIModuleLayoutContext new];
        context.zIndex = obj.zIndex;
        context.x = obj.insets.left;
        context.y = beginY;
        if (obj.childLayoutsAttribute) {
            if (obj.childLayoutsAttribute.centerX != AIModuleUndefineValue) {
                context.x = context.x  + (size.width - layoutW) / 2;
            }
            if (obj.childLayoutsAttribute.centerY != AIModuleUndefineValue) {
                context.y = beginY + (size.height - aH) / 2;
            }
        }
        size.height = aH;

        context.size = size;
        context.section = idx;
        context.beginRow = 0;

        [tmp addObject:[weakSelf createLayoutAttributesForContext:context layout:obj]];
        [models addObject:[weakSelf toModelsForLayout:obj]];
    }];
    _attArray = tmp;
    _models = models;
    _tSize =  CGSizeMake(contentWidth, contentHeight);
  [self updateCollectionViewConstraintsWithSize:_tSize];
}

#pragma mark - 辅助功能

/// 由layout生成CellModel
/// @param layout 布局方式
- (NSArray<AIModuleSuperCellModel *> *)toModelsForLayout:(__kindof AIModuleSuperLayout *)layout {
    NSMutableArray *models = [NSMutableArray array];
    if (layout.backgroundColor
        || layout.borderWidth > 0
        || layout.cornerRadius > 0
        || layout.cornerRadii.width > 0
        || layout.shadowColor) {
        [models addObject:({
            AIModuleSuperCellModel *model = [AIModuleSuperCellModel new];
            model.backgroundColor = layout.backgroundColor;
            model.cornerRadius = layout.cornerRadius;
            model.borderWidth = layout.borderWidth;
            model.borderColor = layout.borderColor;
            model.corners = layout.corners;
            model.cornerRadii = layout.cornerRadii;
            model.shadowOffset = layout.shadowOffset;
            model.shadowRadius = layout.shadowRadius;
            model.shadowColor = layout.shadowColor;
            model.shadowOpacity = layout.shadowOpacity;
            model.borders = layout.borders;
            model.didSelectedHandler = layout.backgroundCellDidSelectedHandler;
            model.didAppearHandler = layout.backgroundCellDidAppearHandler;
            model.didDisappearHandler = layout.backgroundCellDidDisappearHandler;
            model.disable = layout.backgroundCellDisable;
            if (layout.layoutId) {
                model.moduleId = [NSString stringWithFormat:@"%@-bg", layout.layoutId];
            }
            model;
        })];
    }

    __weak typeof(self) weakSelf = self;
    [layout.cellModels enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:[AIModuleSuperCellModel class]]) {
            [models addObject:obj];
        } else if ([obj isKindOfClass:[AIModuleSuperLayout class]]) {
            [models addObjectsFromArray:[weakSelf toModelsForLayout:obj]];
        }
    }];

    [layout.subLayouts enumerateObjectsUsingBlock:^(__kindof AIModuleSuperLayout *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [models addObjectsFromArray:[weakSelf toModelsForLayout:obj]];
    }];
    return models;
}


/**
 刷新cell
 @param model 数据
 */
- (void)reloadCellModel:(__kindof AIModuleSuperCellModel *)model{
    __block NSInteger section = -1;
    __block NSInteger row = -1;
    [self.models enumerateObjectsUsingBlock:^(NSArray<AIModuleSuperCellModel *> *_Nonnull obj, NSUInteger section_idx, BOOL *_Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(AIModuleSuperCellModel *_Nonnull obj, NSUInteger row_idx, BOOL *_Nonnull stop) {
            if (obj == model) {
                section = section_idx;
                row = row_idx;
                *stop = YES;
            }
        }];

        if (section != -1) {
            *stop = YES;
        }
    }];

    if (section != -1) {
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:row inSection:section];
        [UIView setAnimationsEnabled:NO];
        [self.collectionView reloadItemsAtIndexPaths:@[indexP]];
        [UIView setAnimationsEnabled:YES];
    }
}

/**
 刷新数据
 @param indexPaths 坐标
 */
- (void)reloadIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    if (!indexPaths || indexPaths.count == 0) {
        return;
    }
    [UIView setAnimationsEnabled:NO];
    [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    [UIView setAnimationsEnabled:YES];
}

//刷新
- (void)reloadData{
    [self.collectionView reloadData];
}

/**
 查找cell数据
 @param mId 数据Id
 @param toIndexPath 所在section
 */
- (__kindof AIModuleSuperCellModel *)findCellModelWithMId:(NSString *)mId toIndexPath:(NSIndexPath * __autoreleasing *)toIndexPath{
    if (!mId) {
        return nil;
    }
    __block AIModuleSuperCellModel *toModel = nil;
    [self.models enumerateObjectsUsingBlock:^(NSArray<AIModuleSuperCellModel *> *_Nonnull obj, NSUInteger section, BOOL *_Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(AIModuleSuperCellModel *_Nonnull obj, NSUInteger row, BOOL *_Nonnull stop) {
            if ([obj.moduleId isEqualToString:mId]) {
                toModel = obj;
                if (toIndexPath) {
                    *toIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
                }
                *stop = YES;
            }
        }];

        if (toModel) {
            *stop = YES;
        }
    }];
    return toModel;
}

/**
 查找布局信息
 @param layoutId 布局信息Id
 @param toSection 所在Section
 */
- (__kindof AIModuleSuperLayout *)findSectionLayoutWithLayoutId:(NSString *)layoutId toSection:(NSInteger *)toSection{
    if (!layoutId) {
        return nil;
    }
    __block AIModuleSuperLayout *toLayout = nil;
    [self.layouts enumerateObjectsUsingBlock:^(__kindof AIModuleSuperLayout * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.layoutId isEqualToString:layoutId]) {
            toLayout = obj;
            if (toSection) {
                *toSection = idx;
            }
            *stop = YES;
        }
    }];
    return toLayout;
}

/**
 替换Cell数据
 @param mId 数据Id
 @param toModel 需要更换的数据
 */
- (void)replaceCellModelWithMid:(NSString *)mId replaceModel:(__kindof AIModuleSuperCellModel *)toModel{
    if (!mId || !toModel) {
        return;
    }
    __block BOOL find = false;
    [self.models enumerateObjectsUsingBlock:^(NSMutableArray<AIModuleSuperCellModel *> *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(AIModuleSuperCellModel *_Nonnull subObj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([subObj.moduleId isEqualToString:mId]) {
                if ([toModel isMemberOfClass:[subObj class]]) {
                    find = true;
                    toModel.didSelectedHandler = subObj.didSelectedHandler;
                    [obj replaceObjectAtIndex:idx withObject:toModel];
                }
                *stop = YES;
            }
        }];
        if (find) {
            *stop = YES;
        }
    }];
}

/**
 添加状态机
 @param machine 状态机
 */
- (void)addCellModelStateMachine:(AIModuleStateMachine *)machine{
    if (!machine.associatedModuleId) {
        return;
    }
    AIModuleStateMachine *item = [self findStateMachineWithMId:machine.associatedModuleId];
    if (item) {
        [self removeCellModelStateMachineWithMId:machine.associatedModuleId];
    }
    [self.stateMachines addObject:machine];
}

/**
 移除状态机
 @param mId 状态机Id
 */
- (void)removeCellModelStateMachineWithMId:(NSString *)mId{
    if (!mId) {
        return;
    }
    __block NSInteger index = -1;
    [self.stateMachines enumerateObjectsUsingBlock:^(AIModuleStateMachine *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj.associatedModuleId isEqualToString:mId]) {
            index = idx;
            *stop = YES;
        }
    }];
    if (index != -1) {
        [self.stateMachines removeObjectAtIndex:index];
    }
}

/**
 查找状态机
 @param mId 状态机Id
 */
- (AIModuleStateMachine *)findStateMachineWithMId:(NSString *)mId{
    if (!mId) {
        return nil;
    }
    __block AIModuleStateMachine *targetItem = nil;
    [self.stateMachines enumerateObjectsUsingBlock:^(AIModuleStateMachine *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj.associatedModuleId isEqualToString:mId]) {
            targetItem = obj;
            *stop = YES;
        }
    }];
    return targetItem;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)createLayoutAttributesForContext:(AIModuleLayoutContext *)context layout:(__kindof AIModuleSuperLayout *)layout{
    if (!layout || !context) {
        return @[];
    }
    NSMutableArray *atts = [NSMutableArray array];
    CGSize contentSize = CGSizeMake(context.size.width - layout.contentInsets.left - layout.contentInsets.right, context.size.height - layout.contentInsets.top - layout.contentInsets.bottom);
    
    CGFloat contentHeight = [layout layoutHeightForCollectionView:self.collectionView atLayoutSize:contentSize atLayoutIndex:context.section];//内容的高度
    NSArray *rects = [layout rectOfCellModelsForCollectionView:self.collectionView atLayoutSize:contentSize atLaoutIndex:context.section];//每个模块的frame
    __block NSInteger targetIndex = context.beginRow;
    
    if (layout.backgroundColor || layout.borderWidth > 0 || layout.cornerRadius > 0 || layout.cornerRadii.width > 0 || layout.shadowColor) {
        NSIndexPath *indexP = [NSIndexPath indexPathForItem:targetIndex inSection:context.section];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexP];
        attr.frame = CGRectMake(context.x - layout.borderWidth, context.y - layout.borderWidth, context.size.width + layout.borderWidth * 2, contentHeight + (layout.contentInsets.top + layout.contentInsets.bottom) + layout.borderWidth * 2);
        attr.zIndex = context.zIndex - 1;
        [atts addObject:attr];//让AIModuleSuperCellModel ->AIModuleSuperCell 作为第一层背景图，在背景图上面再放置子Cell，所以这里要事先添加一次，然后后面再添加layoutAttribute 第二次,models 的添加要和attribute 数组的添加要一致，否则就会对应不上
        targetIndex++;
    }
    [layout.cellModels enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (rects.count > idx) {
            CGRect aRec = [rects[idx] CGRectValue];
            if ([obj isKindOfClass:[AIModuleSuperCellModel class]]) {
                //组件
                NSIndexPath *indexP = [NSIndexPath indexPathForItem:targetIndex inSection:context.section];
                UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexP];
                aRec.origin.x += context.x;
                aRec.origin.x += layout.contentInsets.left;
                aRec.origin.y += context.y;
                aRec.origin.y += layout.contentInsets.top;
                att.frame = aRec;
                att.zIndex = context.zIndex;

                AIModuleSuperCellModel *model = obj;
                att.alpha = model.alpha;
                [atts addObject:att];

                targetIndex++;
            } else if ([obj isKindOfClass:[AIModuleSuperLayout class]]) {
                //内嵌layout
                AIModuleSuperLayout *subLayout = obj;
                AIModuleLayoutContext *subContext = [AIModuleLayoutContext new];
                subContext.section = context.section;
                subContext.beginRow = targetIndex;

                CGFloat layoutW = 0;
                if (subLayout.layoutWidth > 0) {
                    layoutW = subLayout.layoutWidth;
                } else if (subLayout.layoutWidthScale > 0) {
                    layoutW = (aRec.size.width - subLayout.insets.left - subLayout.insets.right) * subLayout.layoutWidthScale;
                } else {
                    layoutW = aRec.size.width - subLayout.insets.left - subLayout.insets.right;
                }
                subContext.size = CGSizeMake(layoutW, aRec.size.height - subLayout.insets.top - subLayout.insets.bottom);

                CGFloat contentHeight = [subLayout layoutHeightForCollectionView:self.collectionView atLayoutSize:subContext.size atLayoutIndex:subContext.section];
                subContext.size = CGSizeMake(subContext.size.width, contentHeight + subLayout.contentInsets.top + subLayout.contentInsets.bottom);

                subContext.x = aRec.origin.x + context.x + layout.contentInsets.left + subLayout.insets.left;
                subContext.y = aRec.origin.y + context.y + layout.contentInsets.top + subLayout.insets.top;
                if (subLayout.childLayoutsAttribute) {
                    if (subLayout.childLayoutsAttribute.centerX != AIModuleUndefineValue) {
                        subContext.x = aRec.origin.x + context.x + (aRec.size.width - subLayout.layoutWidth) / 2;
                    }
                    if (subLayout.childLayoutsAttribute.centerY != AIModuleUndefineValue) {
                        subContext.y = aRec.origin.y + context.y + (aRec.size.height - subContext.size.height) / 2;
                    }
                }

                subContext.zIndex = context.zIndex + subLayout.zIndex;
                NSArray *addAry = [self createLayoutAttributesForContext:subContext layout:obj];
                [atts addObjectsFromArray:addAry];//递归
                targetIndex += addAry.count;
            }
        }
    }];
    [layout.subLayouts enumerateObjectsUsingBlock:^(__kindof AIModuleSuperLayout *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        AIModuleLayoutContext *subContext = [AIModuleLayoutContext new];
        subContext.section = context.section;
        subContext.beginRow = targetIndex;
        subContext.zIndex = context.zIndex + obj.zIndex;

        CGFloat layoutW = 0;
        if (obj.layoutWidthScale > 0) {
            layoutW = (context.size.width - obj.insets.left - obj.insets.right) * obj.layoutWidthScale;
            obj.layoutWidth = layoutW;
        } else if (obj.layoutWidth > 0) {
            layoutW = obj.layoutWidth;
        } else {
            layoutW = context.size.width - obj.insets.left - obj.insets.right;
            obj.layoutWidth = layoutW;
        }

        subContext.size = CGSizeMake(layoutW, context.size.height - obj.insets.top - obj.insets.bottom);
        CGFloat contentHeight = [obj layoutHeightForCollectionView:self.collectionView atLayoutSize:subContext.size atLayoutIndex:subContext.section];

        subContext.size = CGSizeMake(subContext.size.width, contentHeight + obj.contentInsets.top + obj.contentInsets.bottom);

        if (obj.insets.right != 0 && obj.insets.left == 0) {
            subContext.x = context.x + (context.size.width - obj.insets.right - subContext.size.width);
        } else {
            subContext.x = context.x + obj.insets.left;
        }

        if (obj.insets.bottom != 0 && obj.insets.top == 0) {
            subContext.y = context.y + (context.size.height - obj.insets.bottom - subContext.size.height);
        } else {
            subContext.y = context.y + obj.insets.top;
        }

        if (obj.childLayoutsAttribute.brotherLayoutId) {
            AIModuleSuperLayout *fromLayout = [layout findSubLayoutWithLayoutId:obj.childLayoutsAttribute.brotherLayoutId];
            if (fromLayout) {
                if (obj.childLayoutsAttribute.leftMargin != AIModuleUndefineValue) {
                    subContext.x = fromLayout.layoutOffset.x + obj.childLayoutsAttribute.leftMargin + fromLayout.layoutWidth;
                    CGFloat w = context.size.width + context.x - subContext.x - obj.insets.right - obj.insets.left;

                    subContext.size = CGSizeMake(MIN(w, subContext.size.width), subContext.size.height);
                }

                if (obj.childLayoutsAttribute.topMargin != AIModuleUndefineValue) {
                    subContext.y = fromLayout.layoutOffset.y + obj.childLayoutsAttribute.topMargin + [fromLayout layoutHeightForCollectionView:self.collectionView atLayoutSize:CGSizeMake(fromLayout.layoutWidth, context.size.height - obj.insets.top - obj.insets.bottom) atLayoutIndex:context.section];
                }
            }
        } else if (obj.childLayoutsAttribute) {
            if (obj.childLayoutsAttribute.centerX != AIModuleUndefineValue) {
                subContext.x = context.x + (context.size.width - subContext.size.width) / 2 + obj.childLayoutsAttribute.centerX;
            }

            if (obj.childLayoutsAttribute.centerY != AIModuleUndefineValue) {
                subContext.y = context.y + (context.size.height - subContext.size.height) / 2 + obj.childLayoutsAttribute.centerY;
            }
        }

        obj.layoutOffset = CGPointMake(subContext.x, subContext.y);

        NSArray *addAry = [self createLayoutAttributesForContext:subContext layout:obj];
        [atts addObjectsFromArray:addAry];//递归
        targetIndex += addAry.count;
    }];

    return atts;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.models.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.models objectAtIndex:section].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AIModuleSuperCellModel *model = [[self.models objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];

    if (model.singeIdentifier.length > 0) {
        //取消一般重用
//        [self.collectionView registerClass:ZZCModGradientColorCell.class forCellWithReuseIdentifier:model.singleIdentifier];
        AIModuleSuperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:model.singeIdentifier forIndexPath:indexPath];
        if (!cell.model) {
            [cell cellDidLoad];
        }
        if (cell.model != model) {
            [cell setupCellModel:model];
        }
        return cell;
    }

    AIModuleSuperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[[model class] resueIdentifier] forIndexPath:indexPath];
    if (!cell.model) {
        [cell cellDidLoad];
    }
    [cell setupCellModel:model];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.models.count <= indexPath.section) {
        return;
    }

    if ([self.models objectAtIndex:indexPath.section].count <= indexPath.item) {
        return;
    }

    AIModuleSuperCellModel *model = [[self.models objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
    if (model.didSelectedHandler) {
        model.didSelectedHandler(model, indexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(AIModuleSuperCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.models.count <= indexPath.section) {
        return;
    }

    if ([self.models objectAtIndex:indexPath.section].count <= indexPath.item) {
        return;
    }

    if ([cell isKindOfClass:[AIModuleSuperCell class]]) {
        [cell cellDidAppear];
        AIModuleSuperCellModel *model = [[self.models objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
        if (model.didAppearHandler) {
            model.didAppearHandler(model, indexPath);
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull AIModuleSuperCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.models.count <= indexPath.section) {
        return;
    }

    if ([self.models objectAtIndex:indexPath.section].count <= indexPath.item) {
        return;
    }
    if ([cell isKindOfClass:[AIModuleSuperCell class]]) {
        [cell cellDidDisappear];
        AIModuleSuperCellModel *model = [[self.models objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
        if (model.didDisappearHandler) {
            model.didDisappearHandler(model, indexPath);
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollViewDidScroll) {
        self.scrollViewDidScroll(scrollView);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.scrollViewDidEndDraggingAndDecelerate) {
        self.scrollViewDidEndDraggingAndDecelerate(scrollView, decelerate);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollViewDidEndDecelerating) {
        self.scrollViewDidEndDecelerating(scrollView);
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.scrollViewDidEndScrollingAnimation) {
        self.scrollViewDidEndScrollingAnimation(scrollView);
    }
}

/// 内容size 决定collectionView的可滚动范围
- (CGSize)collectionViewContentSize {
    return _tSize;
}

//作用：返回当前屏幕视图框内item的属性，可以直接返回所有item属性,指定区域的cell布局对象.定新的区域的时候调用
- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    __block NSMutableArray *layoutAttributes = [NSMutableArray array];
    [self.attArray enumerateObjectsUsingBlock:^(NSArray<UICollectionViewLayoutAttributes *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [obj enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (CGRectIntersectsRect(obj.frame, rect)) {
                [layoutAttributes addObject:obj];
            }
        }];
    }];
    return layoutAttributes;
}

- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [[self.attArray objectAtIndex:itemIndexPath.section] objectAtIndex:itemIndexPath.item];
    AIModuleSuperCellModel *model = [[self.models objectAtIndex:itemIndexPath.section] objectAtIndex:itemIndexPath.item];

    AIModuleStateMachine *machine = [self findStateMachineWithMId:model.moduleId];
    if (machine.beiginState) {
        CGRect aRec = attr.frame;
        aRec.origin.x += machine.beiginState.orginOffset.x;
        aRec.origin.y += machine.beiginState.orginOffset.y;
        aRec.size.width += machine.beiginState.sizeOffset.width;
        aRec.size.height += machine.beiginState.sizeOffset.height;
        attr.frame = aRec;
        attr.alpha = machine.beiginState.alpha;
    }
    return attr;
}

- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [[self.attArray objectAtIndex:itemIndexPath.section] objectAtIndex:itemIndexPath.item];
    AIModuleSuperCellModel *model = [[self.models objectAtIndex:itemIndexPath.section] objectAtIndex:itemIndexPath.item];

    AIModuleStateMachine *machine = [self findStateMachineWithMId:model.moduleId];
    if (machine.endState) {
        CGRect aRec = attr.frame;
        aRec.origin.x += machine.endState.orginOffset.x;
        aRec.origin.y += machine.endState.orginOffset.y;
        aRec.size.width += machine.endState.sizeOffset.width;
        aRec.size.height += machine.endState.sizeOffset.height;
        attr.frame = aRec;
        attr.alpha = machine.endState.alpha;
    }

    return attr;
}


@end
