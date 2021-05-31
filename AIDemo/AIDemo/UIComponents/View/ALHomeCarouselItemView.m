//
//  ALHomeCarouselItemView.m
//  AIDemo
//
//  Created by fengsl on 2021/5/30.
//

#import "ALHomeCarouselItemView.h"
#import "Macro.h"
#import <Masonry/Masonry.h>

@implementation ALHomeCarouselItemView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupHomeCarouselItem];
    }
    return self;
}

- (void)setupHomeCarouselItem {
    _imageView = [[UIImageView alloc] init];
    _imageView.layer.cornerRadius = CompatibleIpadSize(12);
    _imageView.layer.masksToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.image = [UIImage imageNamed:@"pic_placeholder_home"];
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(CompatibleIpadSize(15));
        make.right.mas_equalTo(CompatibleIpadSize(-15));
    }];
}


@end
