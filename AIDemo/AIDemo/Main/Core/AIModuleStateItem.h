//
//  AIModuleStateItem.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//状态具体信息
@interface AIModuleStateItem : NSObject


//x、y坐标的偏移值
@property (nonatomic, assign) CGPoint orginOffset;

//透明度
@property (nonatomic, assign) CGFloat alpha;

//大小的偏移值
@property (nonatomic, assign) CGSize sizeOffset;


@end

NS_ASSUME_NONNULL_END
