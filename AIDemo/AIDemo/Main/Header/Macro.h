//
//  Macro.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#ifndef Macro_h
#define Macro_h

#import "UIFont+Extension.h"

// 是否iPad
#define kAL_isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

static CGFloat kAL_IpadScale = 1.5;

#define CompatibleIpadSize(__size) (kAL_isPad ? ((__size) * kAL_IpadScale) : (__size))


//Font
#define Font(__size)  (kAL_isPad ? [UIFont al_systemFontOfSize:((__size) * kAL_IpadScale)] : [UIFont al_systemFontOfSize:(__size)])
#define Font_GEW(__size) (kAL_isPad ? [UIFont gew_systemFontOfSize:((__size) * kAL_IpadScale)] : [UIFont gew_systemFontOfSize:(__size)])

#define Font_EEW(__size) (kAL_isPad ? [UIFont eew_systemFontOfSize:((__size) * kAL_IpadScale)] : [UIFont eew_systemFontOfSize:(__size)])

#define Font_DA(__size) (kAL_isPad ? [UIFont DA_systemFontOfSize:((__size) * kAL_IpadScale)] : [UIFont DA_systemFontOfSize:(__size)])



#define Font_PFR(__size) (kAL_isPad ? [UIFont pfr_systemFontOfSize:((__size) * kAL_IpadScale)] : [UIFont pfr_systemFontOfSize:(__size)])
#define Font_PFM(__size) (kAL_isPad ? [UIFont pfm_systemFontOfSize:((__size) * kAL_IpadScale)] : [UIFont pfm_systemFontOfSize:(__size)])
#define Font_PFL(__size) (kAL_isPad ? [UIFont pfl_systemFontOfSize:((__size) * kAL_IpadScale)] : [UIFont pfl_systemFontOfSize:(__size)])



//判空宏(基于已经确定类型)
#define objectIsEmpty(obj__) ((nil == obj__) || [obj__ isEqual:[NSNull null]])
#define stringIsEmpty(str__) (objectIsEmpty(str__)  || ([str__ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length <= 0))
#define arrayIsEmpty(arr__)  (objectIsEmpty(arr__)  || ([arr__ count] <= 0))
#define dictionaryIsEmpty(dict__)  (objectIsEmpty(dict__)  || ([dict__ count] <= 0))
#define setIsEmpty(set__)  (objectIsEmpty(set__)  || ([set__ count] <= 0))

//判断类型
#define isString(_str__)  [_str__ isKindOfClass:[NSString class]]
#define isArray(_arr__)  [_arr__ isKindOfClass:[NSArray class]]
#define isDictionary(_dict__)  [_dict__ isKindOfClass:[NSDictionary class]]
#define isSet(_set__)  [_set__ isKindOfClass:[NSSet class]]
#define isNumber(_num__)  [_num__ isKindOfClass:[NSNumber class]]



//空数据判断
#define isEmptyString(__text__) (!__text__ || ![__text__ isKindOfClass:[NSString class]] || __text__.length <= 0)
#define isEmptyArray(__array__) (!__array__ || ![__array__ isKindOfClass:[NSArray class]] || __array__.count <= 0)
#define isEmptyDictionary(__dictionary__) (!__dictionary__ || ![__dictionary__ isKindOfClass:[NSDictionary class]] || __dictionary__.count <= 0)


//Color默认使用此方法
#define Color(_hex) ColorA(_hex,1.0)
#define ColorA(_hex,_alpha) [UIColor colorWithRed:(((_hex & 0xFF0000) >> 16))/255.0 green:(((_hex &0xFF00) >>8))/255.0 blue:((_hex &0xFF))/255.0 alpha:_alpha]

#define UIMainScreenWidth [[UIScreen mainScreen] bounds].size.width
#define UIMainScreenHeight [[UIScreen mainScreen] bounds].size.height

//主windownTag
#define kAL_Main_Window_Tag 9653242

#endif /* Macro_h */
