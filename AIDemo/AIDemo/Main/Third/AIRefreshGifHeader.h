//
//  AIRefreshGifHeader.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import <MJRefresh/MJRefresh.h>

typedef NS_ENUM(NSInteger,ALRefreshType) {
    ALRefreshNormalType = 0
};

NS_ASSUME_NONNULL_BEGIN

@interface AIRefreshGifHeader : MJRefreshGifHeader

@property (nonatomic, assign) ALRefreshType refreshType;

+ (instancetype)headerWithRefreshingBlock:(void (^)(void))refreshingBlock refreshType:(ALRefreshType)refreshType;

@end

NS_ASSUME_NONNULL_END
