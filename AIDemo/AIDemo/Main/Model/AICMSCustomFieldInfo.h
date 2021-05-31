//
//  AICMSCustomFieldInfo.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AICMSCustomFieldInfo : NSObject
@property (nonatomic, copy) NSString *fieldName;//字段名
@property (nonatomic, strong) NSArray <NSString *> *value;//字段值
@end

NS_ASSUME_NONNULL_END
