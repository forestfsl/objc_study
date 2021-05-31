//
//  ALTool.h
//  AIDemo
//
//  Created by fengsl on 2021/5/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALTool : NSObject

+ (NSArray <NSTextCheckingResult *> *)searchRangeContainsChinese:(NSString *)content;

+ (CGFloat)al_statusBarHeight;

@end

NS_ASSUME_NONNULL_END
