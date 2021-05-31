//
//  AIModuleLineListLayout.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AIModuleSuperLayout.h"

NS_ASSUME_NONNULL_BEGIN

//单行cell列表布局
/*
   高度计算优先级： lineHeightAtIndex ，HWScaleAtIndex ，lineSpaceAtIndex > defLineHeight ,defHWScale, defLineSpace
   具体计算：defHWScale > defLineHeight
   具体计算：lineHeightAtIndex > HWScaleAtIndex  + defLineSpace;
 */

@interface AIModuleLineListLayout : AIModuleSuperLayout

//默认cell高度
@property (nonatomic, assign) CGFloat defLineHeight;

//定制行高，优先级高，如果设置为0，则cell高度为defLineHeight
@property (nonatomic, copy) CGFloat (^lineHeightAtIndex)(NSUInteger index);

//高/宽 比例
@property (nonatomic, assign) CGFloat defHWScale;

@property (nonatomic, copy) CGFloat(^HWScaleAtIndex)(NSUInteger index);


//默认cell间隔
@property (nonatomic, assign) CGFloat defLineSpace;

//定制cell间隔，优先级高，如果设置为0，则cell间隔为defLineSpace
@property (nonatomic, copy) CGFloat(^lineSpaceAtIndex)(NSUInteger index);


@end

NS_ASSUME_NONNULL_END
