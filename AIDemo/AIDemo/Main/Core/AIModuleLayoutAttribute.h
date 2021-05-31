//
//  AIModuleLayoutAttribute.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIModuleLayoutAttribute : NSObject

//相互约束的layout id
@property (nonatomic, copy) NSString *brotherLayoutId;
//左边距离兄弟layout右边的距离
@property (nonatomic, assign) CGFloat leftMargin;
//顶部距离兄弟layout底部的距离
@property (nonatomic, assign) CGFloat topMargin;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@end

NS_ASSUME_NONNULL_END
