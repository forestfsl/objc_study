//
//  UIFont+Extension.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

+ (UIFont *)al_systemFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HYZhengYuan" size:size] ? : [UIFont systemFontOfSize:size];
}

+ (UIFont *)gew_systemFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HYZhengYuan-GEW" size:size] ? : [UIFont systemFontOfSize:size];
}

+ (UIFont *)eew_systemFontOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"HYZhengYuan-EEW" size:size] ? : [UIFont systemFontOfSize:size];
}

+ (UIFont *)DA_systemFontOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"DIN Alternate" size:size] ? : [UIFont systemFontOfSize:size];
}

+ (UIFont *)pfr_systemFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size] ? : [UIFont systemFontOfSize:size];
}

+ (UIFont *)pfm_systemFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Medium" size:size] ? : [UIFont systemFontOfSize:size];
}

+ (UIFont *)pfl_systemFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Light" size:size] ? : [UIFont systemFontOfSize:size];
}


@end
