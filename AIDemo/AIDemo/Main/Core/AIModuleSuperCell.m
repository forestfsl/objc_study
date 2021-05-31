//
//  AIModuleSuperCellModel.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AIModuleSuperCell.h"
#import "AICMSTemplateInfo.h"
#import "AIModuleSuperLayout.h"


@implementation AIModuleSuperCellModel

- (void)dealloc{
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
}


- (instancetype)init{
    if (self = [super init]) {
        self.borders = ALLayerBorderAll;
        self.alpha = 1;
    }
    return self;
}

+ (NSString *)resueIdentifier{
    return NSStringFromClass([self class]);
}

@end

#define SINGLE_LINE_ADJUST_OFFSET ((1.0 / [UIScreen mainScreen].scale) / 2)

@interface AIModuleSuperCell()
{
    CAShapeLayer *_lineLayer;
    CAShapeLayer *_cornerLayer;
}

@end



@implementation AIModuleSuperCell

- (void)dealloc{
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    self.layer.zPosition = layoutAttributes.zIndex;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.layer.mask = nil;
    [_cornerLayer removeFromSuperlayer];
    self.contentView.layer.masksToBounds = self.model.clipsToBounds;
    self.contentView.layer.cornerRadius = self.model.cornerRadius;

    UIBezierPath *maskPath = nil;
    if (self.model.shadowColor) {
        if (self.model.cornerRadius > 0) {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:UIRectCornerAllCorners
                                                   cornerRadii:CGSizeMake(self.model.cornerRadius, self.model.cornerRadius)];
        } else if (!CGSizeEqualToSize(self.model.cornerRadii, CGSizeZero)) {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:self.model.corners
                                                   cornerRadii:self.model.cornerRadii];
        }
        if (maskPath) {
            _cornerLayer = [[CAShapeLayer alloc] init];
            _cornerLayer.frame = self.bounds;
            _cornerLayer.path = maskPath.CGPath;
            _cornerLayer.fillColor = self.model.backgroundColor.CGColor;
            [self.contentView.layer insertSublayer:_cornerLayer atIndex:0];
        }
    } else {
        if (self.model.cornerRadius > 0) {
            self.contentView.layer.masksToBounds = YES;
            self.contentView.layer.cornerRadius = self.model.cornerRadius;
        } else if (!CGSizeEqualToSize(self.model.cornerRadii, CGSizeZero)) {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:self.model.corners
                                                   cornerRadii:self.model.cornerRadii];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            self.contentView.layer.mask = maskLayer;
        }
    }

    [_lineLayer removeFromSuperlayer];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    linePath.lineWidth = self.model.borderWidth;

    CGFloat pixelAdjustOffset = 0;
    if (((int)(self.model.borderWidth * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
    }

    [linePath moveToPoint:CGPointMake(0 - pixelAdjustOffset, 0)]; //线开头
    BOOL has = NO;
    if (self.model.borders & ALLayerBorderLeft) {
        [linePath addLineToPoint:CGPointMake(0 - pixelAdjustOffset, self.bounds.size.height)];
        has = YES;
    } else {
        [linePath moveToPoint:CGPointMake(0, self.bounds.size.height - pixelAdjustOffset)];
    }

    if (self.model.borders & ALLayerBorderBottom) {
        [linePath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - pixelAdjustOffset)];
        has = YES;
    } else {
        [linePath moveToPoint:CGPointMake(self.bounds.size.width - pixelAdjustOffset, self.bounds.size.height)];
    }

    if (self.model.borders & ALLayerBorderRight) {
        [linePath addLineToPoint:CGPointMake(self.bounds.size.width - pixelAdjustOffset, 0)];
        has = YES;
    } else {
        [linePath moveToPoint:CGPointMake(self.bounds.size.width, 0 - pixelAdjustOffset)];
    }

    if (self.model.borders & ALLayerBorderTop) {
        [linePath addLineToPoint:CGPointMake(0,  0 - pixelAdjustOffset)];
        has = YES;
    }

    if (has && self.model.borderWidth > 0 && self.model.borderColor) {
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.lineWidth = self.model.borderWidth;
        lineLayer.path = linePath.CGPath;
        lineLayer.fillColor = nil;
        lineLayer.strokeColor = self.model.borderColor.CGColor;
        [self.contentView.layer addSublayer:lineLayer];
        _lineLayer = lineLayer;
    }
}

+ (AICMSTemplateInfo *)templateInfo{
    AICMSTemplateInfo *info = [[AICMSTemplateInfo alloc]init];
    info.templateId = [self templateId];
    info.templateUIClass = NSStringFromClass([self class]);
    info.templateModelResueIdentifier = [self templateModelResueIdentifier];
    return info;
}

+ (NSString *)templateId{
    return @"0";
}


+ (NSString *)templateModelResueIdentifier{
    return [AIModuleSuperCellModel resueIdentifier];
}


- (void)setupCellModel:(__kindof AIModuleSuperCellModel *)model{
    _model = model;
    self.backgroundColor = model.backgroundColor;
    self.contentView.backgroundColor = model.backgroundColor;
    self.userInteractionEnabled = !model.isDisable;
    if (model.borders == ALLayerBorderAll && !model.borderColor) {
        self.contentView.layer.borderColor = model.borderColor.CGColor;
        self.contentView.layer.borderWidth = model.borderWidth;
    }else{
        self.contentView.layer.borderColor = nil;
        self.contentView.layer.borderWidth = 0;
    }
    self.contentView.layer.shadowColor = model.shadowColor.CGColor;
    self.contentView.layer.shadowRadius = model.shadowRadius;
    self.contentView.layer.shadowOffset = model.shadowOffset;
    self.contentView.layer.shadowOpacity = model.shadowOpacity;
    self.contentView.alpha = model.alpha;
}


- (void)cellDidLoad{
#if DEBUG
    NSLog(@"cellDidLoad");
#endif
}

- (void)cellDidAppear{
#if DEBUG
    NSLog(@"cellDidAppear");
#endif
}

- (void)cellDidDisappear{
#if DEBUG
    NSLog(@"cellDidDisappear");
#endif
}

+ (AIModuleSuperLayout *)createCellLayoutWithDataSource:(AICMSModuleDetailInfo *)dataSoucee vcTitle:(NSString *)vcTitle{
    NSAssert(NO, @"ALModularSuperCell createCellLayoutWithDataSource:vcTitle:子类必须实现");
    return nil;
}

@end
