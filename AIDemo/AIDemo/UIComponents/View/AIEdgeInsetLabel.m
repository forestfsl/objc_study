//
//  AIEdgeInsetLabel.m
//  AIDemo
//
//  Created by fengsl on 2021/5/30.
//

#import "AIEdgeInsetLabel.h"

@interface AIEdgeInsetLabel()
@property (nonatomic, assign) UIEdgeInsets edgeInset;

@end


@implementation AIEdgeInsetLabel

- (id)initWithEdgeInset:(UIEdgeInsets)edgeInset{
    if (self = [super init]) {
        _edgeInset = edgeInset;
    }
    return self;
}

- (CGSize)intrinsicContentSize{
    CGSize superContentSize = [super intrinsicContentSize];
    return CGSizeMake(superContentSize.width + _edgeInset.left + _edgeInset.right, superContentSize.height + _edgeInset.top + _edgeInset.bottom);
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:UIEdgeInsetsInsetRect(rect, _edgeInset)];
}

@end
