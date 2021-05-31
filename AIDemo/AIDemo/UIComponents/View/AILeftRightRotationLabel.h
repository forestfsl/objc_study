//
//  AILeftRightRotationLabel.h
//  AIDemo
//
//  Created by fengsl on 2021/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//文本左右轮播视图
@interface AILeftRightRotationLabel : UIView
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) CGFloat textPadding;
@property (nonatomic, assign) CGFloat standardCarouselWidth;//标准轮播宽度
@property (nonatomic, copy) NSArray<NSString *> *titles;
@property (nonatomic, copy) void(^titleDidPressedHandler)(NSInteger idx,NSString *currentTitle);

@end

NS_ASSUME_NONNULL_END
