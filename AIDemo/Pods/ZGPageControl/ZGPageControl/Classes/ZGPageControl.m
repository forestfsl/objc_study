//
//  ZGPageControl.m
//  ZGPageControl
//
//  Created by kevenTsang on 2020/1/8.
//  Copyright © 2020 keventsang. All rights reserved.
//

#import "ZGPageControl.h"

@interface ZGPageControl ()
@property (nonatomic,strong)NSArray <UIView *>* itemViews;
@end

@implementation ZGPageControl
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPageControl];
    }
    return self;
}

- (void)setupPageControl{
    _pageSpacing = 6;
    _cornerRadiusOfPages = 5;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDidPressed:)];
    [self addGestureRecognizer:tapGesture];
    _pageIndicatorTintColor = [UIColor colorWithRed:222/255.0 green:225/255.0 blue:230/255.0 alpha:1.0];
    _currentPageIndicatorTintColor = [UIColor colorWithRed:39/255.0 green:111/255.0 blue:241/255.0 alpha:1.0];
}

- (void)setPageSpacing:(CGFloat)pageSpacing{
    _pageSpacing = pageSpacing;
    [self setNeedsLayout];
}

- (void)setCornerRadiusOfPages:(CGFloat)cornerRadiusOfPages{
    _cornerRadiusOfPages = cornerRadiusOfPages;
    [self resetItemViews:_numberOfPages];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages{
    if (numberOfPages >= 0) {
        _numberOfPages = numberOfPages;
        [self resetItemViews:numberOfPages];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage{
    if (currentPage >= 0 && currentPage < _itemViews.count) {
        NSInteger oldIndex = _currentPage;
        _currentPage = currentPage;
        [self updateItemViewWithIndex:oldIndex];
        [self updateItemViewWithIndex:currentPage];
        [self setNeedsLayout];
    }
}

- (void)updateItemViewWithIndex:(NSInteger)index{
    if (index >= 0 && index < _itemViews.count) {
            UIImage * img = [self imageForNumberOfPages:index];
        if (img) {
            UIImageView * imgView = (UIImageView *)_itemViews[index];
            imgView.image = img;
            [imgView sizeToFit];
        } else {
            UIView * currentView = _itemViews[index];
            CGSize size = [self sizeForNumberOfPages:index];
            currentView.frame = CGRectMake(0, 0, size.width, size.height);
            if (_currentPage == index) {
                currentView.backgroundColor = _currentPageIndicatorTintColor;
            } else {
                currentView.backgroundColor = _pageIndicatorTintColor;
            }
        }
    }
}


- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage{
    _hidesForSinglePage = hidesForSinglePage;
    [self setNeedsLayout];
}


- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    if (_itemViews.count > 0) {
        __weak typeof(self) weakSelf = self;
        [_itemViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (weakSelf.currentPage != idx) {
                obj.backgroundColor = pageIndicatorTintColor;
            }
        }];
      }
    [self setNeedsLayout];
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    if (_itemViews.count > 0) {
            if (_currentPage >= 0 && _currentPage < _itemViews.count) {
                UIView * currentView = _itemViews[_currentPage];
            if (![currentView isKindOfClass:[UIImageView class]]) {
                currentView.backgroundColor = currentPageIndicatorTintColor;
            }
        }
    }

    [self setNeedsLayout];
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageIndex{
    return CGSizeMake(6, 6);
}

- (UIImage *)imageForNumberOfPages:(NSInteger)pageIndex{
    return nil;
}

- (void)resetItemViews:(NSInteger)numberOfPages{
    [self.itemViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (numberOfPages > 0) {
        NSMutableArray * tmpItemViewList = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
        for (NSInteger i = 0; i < numberOfPages; i++) {
            UIView * currentView = nil;
            
            UIImage * img = [self imageForNumberOfPages:i];
            if (img) {
                UIImageView * imgview = [[UIImageView alloc] initWithImage:img];
                [imgview sizeToFit];
                currentView = imgview;
            } else {
                currentView = [[UIView alloc] init];
                CGSize size = [self sizeForNumberOfPages:i];
                currentView.frame = CGRectMake(0, 0, size.width, size.height);
                if (i == _currentPage) {
                    currentView.backgroundColor = _currentPageIndicatorTintColor;
                } else {
                    currentView.backgroundColor = _pageIndicatorTintColor;
                }
                currentView.layer.cornerRadius = _cornerRadiusOfPages;
            }
            
            if (currentView) {
                [self addSubview:currentView];
                [tmpItemViewList addObject:currentView];
            }
        }
        self.itemViews = [NSArray arrayWithArray:tmpItemViewList];
    } else {
        self.itemViews = nil;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat padding = [self paddingForNumberOfPages];
    CGFloat controlHeight = CGRectGetHeight(self.bounds);
    CGFloat controlWidth = CGRectGetWidth(self.bounds);
    NSInteger count = _itemViews.count;
    __block CGFloat viewTotalWidth =  padding * (count - 1);
    [_itemViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        viewTotalWidth += CGRectGetWidth(obj.frame);
    }];
    CGFloat lastLeft = (controlWidth - viewTotalWidth) * 0.5;
    if (lastLeft < 0) {
        lastLeft = 0;
    }
    for (NSInteger i = 0; i < _itemViews.count; i++) {
        UIView * currentView = _itemViews[i];
        CGRect frame = currentView.frame;
        frame.origin = CGPointMake(lastLeft, (controlHeight - frame.size.height) * 0.5);
        currentView.frame = frame;
        lastLeft += (CGRectGetWidth(frame)+ padding);
    }
    
    self.hidden = !(_itemViews.count > 1) && _hidesForSinglePage;
}

- (CGFloat)paddingForNumberOfPages{
    return _pageSpacing;
}

#pragma mark - Action

- (void)tapGestureDidPressed:(UITapGestureRecognizer *)tapGesture{
    CGPoint point = [tapGesture locationInView:self];
    NSInteger index = 0;
    CGFloat padding = [self paddingForNumberOfPages] * 0.5;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(-padding, -padding, -padding, -padding);
    for (NSInteger i = 0; i < _itemViews.count; i++) {
        UIView * currentView = _itemViews[i];
        CGRect frame = UIEdgeInsetsInsetRect(currentView.frame, edgeInsets);
        if (CGRectContainsPoint(frame, point)) {
            index = i;
            break;
        }
    }
    
    self.currentPage = index;
    
    if ([_delegate respondsToSelector:@selector(pagecontrol:didSelectedIndex:)]) {
        [_delegate pagecontrol:self didSelectedIndex:index];
    }
}




@end
