//
//  UIScrollView+Extension.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Extension)

- (void)headerPulldownRefreshing:(void (^)(void))refreshingBlock;

- (void)endRefrehing;

@end

NS_ASSUME_NONNULL_END
