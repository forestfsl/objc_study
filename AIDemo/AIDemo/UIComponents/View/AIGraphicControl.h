//
//  AIGraphicControl.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AIGraphicControlModel){
    AIGraphicControlModeNormal,//图左文右
    AIGraphicControlModeReverse,//文左图右
    AIGraphicControlModeImageUp,//图上文下
    AIGraphicControlModeImageDown //文上图下
};

NS_ASSUME_NONNULL_BEGIN

@interface AIGraphicControl : UIControl
@property (nonatomic, strong) UILabel *titleLal;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;
@property (nonatomic, assign) BOOL isSelected;

/**
 初始化
 @param padding 中间间距，默认5
 @param mode 模式，默认AIGraphicControlModeNormal
 @param useImageSize 使用图片的尺寸，图片的尺寸比文字大，默认NO
 */
- (id)initWithPadding:(CGFloat)padding mode:(AIGraphicControlModel)mode useImageSize:(BOOL)useImageSize;

@end

NS_ASSUME_NONNULL_END
