//
//  AIEdgeInsetLabel.h
//  AIDemo
//
//  Created by fengsl on 2021/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIEdgeInsetLabel : UILabel

- (id)init NS_UNAVAILABLE;
- (id)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (id)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (id)initWithEdgeInset:(UIEdgeInsets)edgeInset;

@end

NS_ASSUME_NONNULL_END
