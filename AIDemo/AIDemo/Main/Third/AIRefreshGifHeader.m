//
//  AIRefreshGifHeader.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AIRefreshGifHeader.h"

@implementation AIRefreshGifHeader

+ (instancetype)headerWithRefreshingBlock:(void (^)(void))refreshingBlock refreshType:(ALRefreshType)refreshType{
    AIRefreshGifHeader *refreshHeader = [AIRefreshGifHeader headerWithRefreshingBlock:refreshingBlock];
    refreshHeader.refreshType = refreshType;
    return refreshHeader;
}

#pragma mark - 重写父类的方法
- (void)prepare{
    [super prepare];

    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 0; i< 24; i++) {
        UIImage * image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"gubi00%02d",i] ofType:@"png"]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages duration:1.8 forState:MJRefreshStatePulling];

    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages duration:1.8 forState:MJRefreshStateRefreshing];

    //隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    //隐藏状态
    self.stateLabel.hidden = YES;
}

@end
