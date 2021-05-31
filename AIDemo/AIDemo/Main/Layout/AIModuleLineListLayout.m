//
//  AIModuleLineListLayout.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AIModuleLineListLayout.h"

@implementation AIModuleLineListLayout

- (CGFloat)layoutHeightForCollectionView:(UICollectionView *)collectionView atLayoutSize:(CGSize)size atLayoutIndex:(NSInteger)index{
    CGFloat height = 0;
    if (!self.lineHeightAtIndex && !self.lineSpaceAtIndex && !self.HWScaleAtIndex) {
        if (self.defHWScale > 0) {
            height = size.width * self.defHWScale * self.cellModels.count;
        }else{
            height = self.cellModels.count * self.defLineHeight;
        }
        if (self.cellModels.count > 1) {
            height += (self.cellModels.count - 1) * self.defLineSpace;
        }
    }else{
        for (NSInteger i = 0; i < self.cellModels.count; i++) {
            CGFloat h = 0;
            if (self.lineHeightAtIndex) {
                h = self.lineHeightAtIndex(i);
            }
            if (h == 0) {
                if (self.HWScaleAtIndex) {
                    h = size.width * self.HWScaleAtIndex(i);
                }
                if (h == 0) {
                    if (self.defHWScale > 0) {
                        h = size.width * self.defHWScale;
                    }
                    if (h == 0) {
                        h = self.defLineHeight;
                    }
                }
            }
            height += h;
            if (i > 0) {
                if (self.lineSpaceAtIndex) {
                    height += self.lineSpaceAtIndex(i);
                }else{
                    height += self.defLineSpace;
                }
            }
        }
    }
    return height;
}

- (NSArray<NSValue *> *)rectOfCellModelsForCollectionView:(UICollectionView *)collectionView atLayoutSize:(CGSize)size atLaoutIndex:(NSInteger)index{
    NSMutableArray *rects = [NSMutableArray array];
    
    __block CGFloat lineY = 0;
    [self.cellModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect aRec = CGRectMake(0, lineY, size.width, 0);
        if (idx > 0) {
            if (self.lineSpaceAtIndex) {
                aRec.origin.y = lineY + self.lineSpaceAtIndex(idx);
            }else{
                aRec.origin.y = lineY + self.defLineSpace;
            }
        }
        CGFloat h = 0;
        if (self.lineHeightAtIndex) {
            h = self.lineHeightAtIndex(idx);
        }
        if (h == 0) {
            if (self.HWScaleAtIndex) {
                h = size.width * self.HWScaleAtIndex(idx);
            }
            if (h == 0) {
                if (self.defHWScale > 0) {
                    h = size.width * self.defHWScale;
                }
                if (h == 0) {
                    h = self.defLineHeight;
                }
            }
        }
        aRec.size.height = h;
        [rects addObject:[NSValue valueWithCGRect:aRec]];
        lineY = aRec.origin.y + aRec.size.height;
    }];
    return rects;
}

@end
