//
//  AIGraphicControl.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AIGraphicControl.h"
#import "Macro.h"
#import <Masonry/Masonry.h>

@interface AIGraphicControl()

@property (nonatomic, assign) AIGraphicControlModel mode;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) BOOL useImageSize;
@end


@implementation AIGraphicControl

- (id)initWithPadding:(CGFloat)padding mode:(AIGraphicControlModel)mode useImageSize:(BOOL)useImageSize{
    if (self = [super init]) {
        _mode = mode;
        _padding = padding;
        _useImageSize = useImageSize;
        [self setupGraphicControl];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setupDefaultData];
        [self setupGraphicControl];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupDefaultData];
        [self setupGraphicControl];
    }
    return self;
}

- (void)setupDefaultData{
    _mode = AIGraphicControlModeNormal;
    _padding = 5;
    _useImageSize = NO;
}

- (void)setupGraphicControl{
    _titleLal = [[UILabel alloc]init];
    _titleLal.backgroundColor = [UIColor clearColor];
    _titleLal.font = Font(14);
    _titleLal.textColor = [UIColor grayColor];
    [self addSubview:_titleLal];
    
    _iconView = [[UIImageView alloc]init];
    [self addSubview:_iconView];
    
    __weak typeof(self) weakSelf = self;
    switch (_mode) {
        case AIGraphicControlModeNormal:
        {
            [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                if (weakSelf.useImageSize) {
                    make.top.bottom.mas_equalTo(0);
                }else{
                    make.centerY.mas_equalTo(0);
                }
            }];
            [_titleLal mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.iconView.mas_right).offset(weakSelf.padding);
                make.right.mas_equalTo(0);
                if (weakSelf.useImageSize) {
                    make.centerY.mas_equalTo(0);
                }else{
                    make.top.bottom.mas_equalTo(0);
                }
            }];
        }
            break;
        case AIGraphicControlModeReverse:
        {
            [_titleLal mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                if (weakSelf.useImageSize) {
                    make.centerY.mas_equalTo(0);
                } else {
                    make.top.bottom.mas_equalTo(0);
                }
            }];

            [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.titleLal.mas_right).offset(weakSelf.padding);
                make.right.mas_equalTo(0);
                if (weakSelf.useImageSize) {
                    make.top.bottom.mas_equalTo(0);
                } else {
                    make.centerY.mas_equalTo(0);
                }
            }];
        }
            break;
        case AIGraphicControlModeImageUp:
        {
            [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                if (weakSelf.useImageSize) {
                    make.right.left.mas_equalTo(0);
                } else {
                    make.centerX.mas_equalTo(0);
                }
            }];
            [_titleLal mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.iconView.mas_bottom).offset(weakSelf.padding);
                make.bottom.mas_equalTo(0);
                if (weakSelf.useImageSize) {
                    make.centerX.mas_equalTo(0);
                } else {
                    make.right.left.mas_equalTo(0);
                }
            }];
        }
            break;
        case AIGraphicControlModeImageDown:
        {
            [_titleLal mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);

                if (weakSelf.useImageSize) {
                    make.centerX.mas_equalTo(0);
                } else {
                    make.right.left.mas_equalTo(0);
                }
            }];

            [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.titleLal.mas_bottom).offset(weakSelf.padding);
                make.bottom.mas_equalTo(0);
                if (weakSelf.useImageSize) {
                    make.right.left.mas_equalTo(0);
                } else {
                    make.centerX.mas_equalTo(0);
                }
            }];

        }
            break;
            
        default:
            break;
    }
}

- (void)setImageSize:(CGSize)imageSize{
    _imageSize = imageSize;
    if (!CGSizeEqualToSize(_imageSize, CGSizeZero)) {
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.imageSize);
        }];
    }
}

//扩大点击范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero)){
        return [super pointInside:point withEvent:event];
    }else{
        CGRect relativeFrame = self.bounds;
        CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
        return CGRectContainsPoint(hitFrame, point);
    }
}

@end
