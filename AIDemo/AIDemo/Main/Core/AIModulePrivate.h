//
//  AIModulePrivate.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#ifndef AIModulePrivate_h
#define AIModulePrivate_h

static CGFloat AIModuleUndefineValue = 10000;

//Border 类型
//Border类型
typedef NS_OPTIONS(NSUInteger, ALLayerBorder){
    ALLayerBorderAll = 1 << 0,
    ALLayerBorderBottom = 1 << 1,
    ALLayerBorderLeft = 1 << 2,
    ALLayerBorderRight = 1 << 3,
    ALLayerBorderTop = 1 << 4,
};

#endif /* AIModulePrivate_h */
