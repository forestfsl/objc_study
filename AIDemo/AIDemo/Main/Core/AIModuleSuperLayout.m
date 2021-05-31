//
//  AIModuleSuperLayout.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AIModuleSuperLayout.h"

@implementation AIModuleSuperLayout

- (void)dealloc{
#if DEBUG
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
#endif
}


- (CGFloat)layoutHeightForCollectionView:(UICollectionView *)collectionView atLayoutSize:(CGSize)size atLayoutIndex:(NSInteger)index{
    return 0;
}


- (NSArray<NSValue *> *)rectOfCellModelsForCollectionView:(UICollectionView *)collectionView atLayoutSize:(CGSize)size atLaoutIndex:(NSInteger)index{
    return nil;
}


- (__kindof AIModuleSuperLayout *)findSubLayoutWithLayoutId:(NSString *)layoutId{
    if (!layoutId) {
        return nil;
    }
    __block AIModuleSuperLayout *layout = nil;
    [self.subLayouts enumerateObjectsUsingBlock:^(__kindof AIModuleSuperLayout * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.layoutId isEqualToString:layoutId]) {
            layout = obj;
            *stop = YES;
        }
    }];
    return layout;
}

@end
