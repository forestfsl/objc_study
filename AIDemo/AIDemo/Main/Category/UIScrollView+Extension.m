//
//  UIScrollView+Extension.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "UIScrollView+Extension.h"
#import "AIRefreshGifHeader.h"

@implementation UIScrollView (Extension)

- (void)headerPulldownRefreshing:(void (^)(void))refreshingBlock {
    self.mj_header = [AIRefreshGifHeader headerWithRefreshingBlock:^{
        if (refreshingBlock) {
            refreshingBlock();
        }
    } refreshType:ALRefreshNormalType];
}

- (void)endRefrehing {
    if (self.mj_header) {
        [self.mj_header endRefreshing];
    }
    if (self.mj_footer) {
        [self.mj_footer endRefreshing];
    }
}

@end
