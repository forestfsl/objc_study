//
//  AICMSViewController.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import <UIKit/UIKit.h>
#import "AIModuleLayoutEngine.h"
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@class AICMSModuleDetailInfo,AIModuleSuperLayout;

@interface AICMSViewController : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) AIModuleLayoutEngine *flow;

- (void)setupCollectionView;
- (void)setupDefaultTemplateModels;
- (void)compatibleSystemAPI;
- (void)setupCollectionViewConstraints;

//返回HeaderView
- (AIModuleSuperLayout *)collectionHeaderView;

- (NSString *)analyticsTitle;

///是否需要添加
- (BOOL)canAddCollectionHeaderView:(NSArray<__kindof AIModuleSuperLayout *> *)layouts;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
