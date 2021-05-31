//
//  AIModuleLayoutContext.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIModuleLayoutContext : NSObject
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger beginRow;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) NSInteger zIndex;

@end

NS_ASSUME_NONNULL_END
