//
//  AILeftRightRotationLabel.m
//  AIDemo
//
//  Created by fengsl on 2021/5/30.
//

#import "AILeftRightRotationLabel.h"
#import "UIView+YYAdd.h"
#import "Macro.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>

#define kAL_LRR_Label_Tag 286


@interface AILeftRightRotationLabel ()
@property (nonatomic, strong) NSMutableArray <UIView *> *screenViews;
@property (nonatomic, strong) CADisplayLink *scrollLink;
@property (nonatomic, strong) UIView *lastLeftScreenView;//最左边的视图
@property (nonatomic, assign) CGFloat scrolltoLeftX;//往左移动的距离
@property (nonatomic, assign) CGFloat itemViewWidth;//每一屏的宽度
@end

@implementation AILeftRightRotationLabel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (CGFloat)standardCarouselWidth {
    if (_standardCarouselWidth <= 0) {
        _standardCarouselWidth = UIMainScreenWidth;
    }
    return _standardCarouselWidth;
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = [titles copy];
    [self stopTimer];
    [self setupLeftRightRotationLabel];
    CGFloat itemViewWidth = [self totalWidthWithTitles:_titles];
    CGFloat standardCarouselWidth = self.standardCarouselWidth;
    if (itemViewWidth > standardCarouselWidth && titles && [titles isKindOfClass:[NSArray class]] && titles.count > 0) {
        [self startRunTimer];
    }
}

- (void)setupLeftRightRotationLabel {
    [self removeAllSubviews];
    NSMutableArray *screemViews = [[NSMutableArray alloc] init];
    CGFloat itemViewWidth = [self totalWidthWithTitles:_titles];
    self.itemViewWidth = itemViewWidth;
    CGFloat standardCarouselWidth = self.standardCarouselWidth;
    if (itemViewWidth > standardCarouselWidth) {
        CGFloat textPadding = self.textPadding;
        CGFloat mixWidth = itemViewWidth * 3;
        UIView *lastView = nil;
        CGFloat totalWidth = 0;
        while (totalWidth < mixWidth) {
            UIView *itemView = [self itemViewWithTitles:_titles];
            [self addSubview:itemView];
            [screemViews addObject:itemView];
            if (lastView) {
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.mas_equalTo(0);
                    make.left.equalTo(lastView.mas_right).offset(textPadding);
                }];
                totalWidth += textPadding;
            } else {
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.mas_equalTo(0);
                }];
            }
            lastView = itemView;
            totalWidth += itemViewWidth;
        }
    } else {
        UIView *itemView = [self itemViewWithTitles:_titles];
        [self addSubview:itemView];
        [screemViews addObject:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.mas_equalTo(0);
        }];
    }
    self.screenViews = screemViews;
    self.lastLeftScreenView = screemViews.firstObject;
    self.scrolltoLeftX = 0;
}

- (CGFloat)totalWidthWithTitles:(NSArray<NSString *> *)titles {
    if (!titles || ![titles isKindOfClass:[NSArray class]] || titles.count <= 0) {
        return 0;
    }
    __block CGFloat totalWidth = 0;
    UIFont *titleFont = self.titleFont;
    [titles enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        CGRect rect = [obj boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, titleFont.lineHeight)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{ NSFontAttributeName: titleFont } context:nil];
        totalWidth += rect.size.width;
    }];

    CGFloat textPadding = self.textPadding;
    totalWidth += ((titles.count - 1) * textPadding);
    return totalWidth;
}

- (CGFloat)textPadding {
    CGFloat textPadding = _textPadding;
    if (textPadding <= 0) {
        textPadding = CompatibleIpadSize(10);
    }
    return textPadding;
}

- (UIFont *)titleFont {
    UIFont *titleFont = _titleFont;
    if (!titleFont) {
        titleFont = Font_EEW(12);
    }
    return titleFont;
}

- (UIColor *)titleColor {
    UIColor *titleColor = _titleColor;
    if (!titleColor) {
        titleColor = [UIColor blackColor];
    }
    return titleColor;
}

#define kAL_LRR_Label_Tag 286

- (UIView *)itemViewWithTitles:(NSArray<NSString *> *)titles {
    if (!titles || ![titles isKindOfClass:[NSArray class]] || titles.count <= 0) {
        return nil;
    }

    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [UIColor clearColor];

    UIColor *titleColor = self.titleColor;
    UIFont *titleFont = self.titleFont;
    CGFloat textPadding = self.textPadding;
    NSInteger count = titles.count;
    __block UIButton *lastLal = nil;
    [titles enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        UIButton *titleLal = ({
            UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [tempBtn addTarget:self action:@selector(titleLalDidPressed:) forControlEvents:UIControlEventTouchUpInside];
            [tempBtn setTitle:obj forState:UIControlStateNormal];
            [tempBtn setTitleColor:titleColor forState:UIControlStateNormal];
            tempBtn.adjustsImageWhenHighlighted = NO;
            tempBtn.adjustsImageWhenDisabled = NO;
            tempBtn.titleLabel.font = titleFont;
            tempBtn;
        });
        titleLal.tag = kAL_LRR_Label_Tag + idx;
        [aView addSubview:titleLal];
        if (lastLal) {
            [titleLal mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.left.equalTo(lastLal.mas_right).offset(textPadding);
            }];
        } else {
            [titleLal mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.left.mas_equalTo(0);
            }];
        }

        if (idx == (count - 1)) {
            [titleLal mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
            }];
        }
        lastLal = titleLal;
    }];
    return aView;
}

- (void)titleLalDidPressed:(UIButton *)btn {
    NSInteger idx = btn.tag - kAL_LRR_Label_Tag;
    NSArray <NSString *> *titles = self.titles;
    if (idx >= 0 && titles && [titles isKindOfClass:[NSArray class]] && idx < titles.count && _titleDidPressedHandler) {
        _titleDidPressedHandler(idx, titles[idx]);
    }
}

#pragma mark - time

- (void)startRunTimer {
    [self stopTimer];
    CADisplayLink *scrollLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(scrollAction)];
    CGFloat displayPerSecond = 30;
    if (@available(iOS 10.0, *)) {
        scrollLink.preferredFramesPerSecond = displayPerSecond;
    } else {
        scrollLink.frameInterval = 60 / displayPerSecond;
    }
    [scrollLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [scrollLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
    self.scrollLink = scrollLink;
}

- (void)stopTimer {
    if (self.scrollLink) {
        [self.scrollLink invalidate];
        self.scrollLink = nil;
    }
}

- (void)scrollAction {
    NSArray <UIView *> *screenViews = self.screenViews;
    if (!screenViews || ![screenViews isKindOfClass:[NSArray class]] || screenViews.count <= 0) {
        return;
    }

    if (!self.lastLeftScreenView) {
        return;
    }

    CGFloat firstScreenViewWidth = self.lastLeftScreenView.width;
    if (firstScreenViewWidth <= 0) {
        return;
    }

    CGFloat itemViewWidth = self.itemViewWidth;
    if (itemViewWidth <= 0) {
        itemViewWidth = [self totalWidthWithTitles:_titles];
    }

    CGFloat screenWidth = (itemViewWidth > UIMainScreenWidth) ? itemViewWidth : UIMainScreenWidth;
    CGFloat stepUnit = 0.5;
    if (_scrolltoLeftX >= screenWidth) {//进行更换第一个视图
        if (screenViews.count < 2) {
            NSLog(@"scrollAction 不可能出现 这种情况");
            return;
        }
        //更新布局
        UIView *lastLeftScreenView = screenViews[1];
        CGFloat secondeScreenViewX = lastLeftScreenView.mj_x - stepUnit;
        [lastLeftScreenView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(secondeScreenViewX);
        }];

        //更新布局
        CGFloat textPadding = self.textPadding;
        UIView *lastView = screenViews.lastObject;
        [_lastLeftScreenView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.equalTo(lastView.mas_right).offset(textPadding);
        }];
        [self.screenViews removeObject:_lastLeftScreenView];
        [self.screenViews addObject:_lastLeftScreenView];
        self.lastLeftScreenView = lastLeftScreenView;
        _scrolltoLeftX = -secondeScreenViewX;
    } else {
        _scrolltoLeftX += 0.5;
        __weak typeof(self) weakSelf = self;
        [self.lastLeftScreenView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(-weakSelf.scrolltoLeftX);
        }];
    }
}
@end
