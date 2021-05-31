//
//  AIPageControl.m
//  AIDemo
//
//  Created by fengsl on 2021/5/30.
//

#import "AIPageControl.h"
#import "Macro.h"

@implementation AIPageControl

- (CGSize)sizeForNumberOfPages:(NSInteger)pageIndex{
    if (pageIndex == self.currentPage) {
        return CGSizeMake(CompatibleIpadSize(16), CompatibleIpadSize(6));
    }
    return CGSizeMake(CompatibleIpadSize(6), CompatibleIpadSize(6));
}

@end
