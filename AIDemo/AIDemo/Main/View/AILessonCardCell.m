//
//  AILessonCardCell.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AILessonCardCell.h"
#import "AIGraphicControl.h"
#import "AIEdgeInsetLabel.h"
#import "AIModuleLineListLayout.h"
#import "AICMSManager.h"
#import "Macro.h"
#import <Masonry/Masonry.h>
#import "NSString+Extension.h"
#import <MJExtension/MJExtension.h>


@implementation AILessonMealModel

- (BOOL)hasOpentimeStamp{
    if (!isEmptyString(_openTimeStamp) && [_openTimeStamp doubleValue] > 0) {
        return YES;
    }
    return NO;
}

@end

@implementation AILessonCardCellModel



@end

@implementation ALLessonCardCellItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupLessonCardCellIteView];
    }
    return self;
}

- (void)setupLessonCardCellIteView{
    _backgroundImageview = [[UIView alloc]init];
    _backgroundImageview.backgroundColor = [UIColor whiteColor];
    _backgroundImageview.layer.borderWidth = 1;
    _backgroundImageview.layer.borderColor = Color(0xF7F7F7).CGColor;
    _backgroundImageview.layer.cornerRadius = 12;
    _backgroundImageview.layer.shadowOffset = CGSizeMake(0, 10);
    _backgroundImageview.layer.shadowOpacity = 0.8;
    _backgroundImageview.layer.shadowColor = Color(0xF2F2F2).CGColor;
    _backgroundImageview.layer.shadowRadius = 10;
    [self addSubview:_backgroundImageview];
    [_backgroundImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(CompatibleIpadSize(15.5));
        make.right.mas_equalTo(CompatibleIpadSize(-15.5));
        make.bottom.mas_equalTo(CompatibleIpadSize(-20));
    }];
    
    _lessonNoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_lessonNoBtn setBackgroundImage:[UIImage imageNamed:@"bg_title_table"] forState:UIControlStateNormal];
    _lessonNoBtn.titleLabel.font = Font_GEW(12);
    _lessonNoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_lessonNoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _lessonNoBtn.userInteractionEnabled = NO;
    [_backgroundImageview addSubview:_lessonNoBtn];
    [_lessonNoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(CompatibleIpadSize(15));
        make.height.mas_equalTo(CompatibleIpadSize(18));
        make.width.mas_equalTo(CompatibleIpadSize(53.5));
    }];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = Font_GEW(15);
    _nameLabel.textColor = Color(0x1A1A1A);
    [_backgroundImageview addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lessonNoBtn.mas_right).offset(CompatibleIpadSize(12));
        make.right.mas_equalTo(CompatibleIpadSize(-12));
        make.top.equalTo(self.lessonNoBtn.mas_top);
        make.height.equalTo(self.lessonNoBtn);
    }];
    
    _openCourseTimeGC = [[AIGraphicControl alloc] initWithPadding:6 mode:AIGraphicControlModeNormal useImageSize:YES];
    _openCourseTimeGC.imageSize = CGSizeMake(CompatibleIpadSize(12), CompatibleIpadSize(12));
    _openCourseTimeGC.iconView.image = [UIImage imageNamed:@"home_course_card_hook"];
    _openCourseTimeGC.titleLal.textColor = Color(0x333333);
    _openCourseTimeGC.titleLal.font = Font_GEW(12);
    _openCourseTimeGC.userInteractionEnabled = NO;
    [_backgroundImageview addSubview:_openCourseTimeGC];
    [_openCourseTimeGC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lessonNoBtn.mas_left);
        make.top.equalTo(self.lessonNoBtn.mas_bottom).offset(CompatibleIpadSize(14.5));
        make.height.mas_equalTo(CompatibleIpadSize(12));
    }];
    
    _priceLabel = [[UILabel alloc]init];
    [_backgroundImageview addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lessonNoBtn.mas_left);
        make.bottom.mas_equalTo(CompatibleIpadSize(-15));
        make.height.mas_equalTo(CompatibleIpadSize(20));
    }];
    
    _originPriceLabel = [[UILabel alloc]init];
    _originPriceLabel.textColor = Color(0x999999);
    _originPriceLabel.font = Font_GEW(12);
    [_backgroundImageview addSubview:_originPriceLabel];
    [_originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(CompatibleIpadSize(6.5));
        make.bottom.equalTo(self.priceLabel.mas_bottom);
        make.height.mas_equalTo(CompatibleIpadSize(14));
    }];
    
    _couponNameLabel = [[UILabel alloc]init];
    _couponNameLabel.font = Font_GEW(12);
    _couponNameLabel.textColor = Color(0xFF4D00);
    [_backgroundImageview addSubview:_couponNameLabel];
    [_couponNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.originPriceLabel.mas_right).offset(CompatibleIpadSize(6.5));
        make.bottom.equalTo(self.priceLabel.mas_bottom);
        make.right.mas_equalTo(CompatibleIpadSize(14));
    }];
}

- (void)updateLessonCardItemView:(NSString *)openTimeStamp lessonName:(NSString *)lessonName salePrice:(NSString *)salePrice originalPrice:(NSString *)originalPrice couponName:(NSString *)couponName tagTexts:(NSArray<NSString *> *)tagTexts{
    NSString *courseTime = [NSString timeStampConvertToTime:[NSString stringWithFormat:@"%f", ([openTimeStamp doubleValue] / 1000.0)] andDateFormat:@"MM月dd日" isReturnWeek:NO];
    NSString *lessonNo = [courseTime stringByReplacingOccurrencesOfString:@"月" withString:@""];
    lessonNo = [lessonNo stringByReplacingOccurrencesOfString:@"日" withString:@""];
    [self.lessonNoBtn setTitle:[lessonNo stringByAppendingString:@"期"] forState:UIControlStateNormal];
    courseTime = [NSString timeStampConvertToTime:[NSString stringWithFormat:@"%f", ([openTimeStamp doubleValue] / 1000.0)] andDateFormat:@"MM月dd日" isReturnWeek:YES];
    self.openCourseTimeGC.titleLal.text = [courseTime stringByAppendingString:@"入学"];
    self.nameLabel.text = lessonName;
    [self updatePriceLabelWithPrice:[salePrice floatValue] / 100.0];
    if ([originalPrice isPureInt] || [originalPrice isPureFloat]) {
        [self updateOriginPriceLalbel:[NSString stringWithFormat:@"原价%.2f元", [originalPrice floatValue] / 100.0]];
    } else {
        [self updateOriginPriceLalbel:originalPrice];
    }
    //    self.originPriceLabel.text = [NSString stringWithFormat:@"原价%.2f元", [originalPrice floatValue] / 100.0];
    [self updateTagLabels:tagTexts];
    _couponNameLabel.text = couponName;
}

- (void)updateOriginPriceLalbel:(NSString *)price{
    if (isEmptyString(price)) {
        _originPriceLabel.attributedText = nil;
        return;
    }
    NSUInteger length = [price length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:price];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:Color(0x93969D) range:NSMakeRange(0, length)];
    _originPriceLabel.attributedText = attri;
}



- (void)updatePriceLabelWithPrice:(float)salePrice {
    NSString *priceString = [NSString stringWithFormat:@"%.2f", salePrice];
    NSString *priceTemp = [@"¥" stringByAppendingString:priceString];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    NSAttributedString *attrTempString = [[NSAttributedString alloc] initWithString:priceTemp
                                                                         attributes:@{ NSFontAttributeName: Font_GEW(15),
                                                                                       NSForegroundColorAttributeName: Color(0xFF4D00) }];
    [attrString appendAttributedString:attrTempString];
    NSRange range = [priceTemp rangeOfString:priceString];
    [attrString addAttributes:@{ NSFontAttributeName: Font_GEW(24) } range:range];
    self.priceLabel.attributedText = attrString;
}

- (void)updateTagLabels:(NSArray <NSString *> *)tags {
    [self removeTagLabels];
    if (tags && [tags isKindOfClass:[NSArray class]] && tags.count > 0) {
        AIEdgeInsetLabel *lastObj = nil;
        for (NSString *tag in tags) {
            AIEdgeInsetLabel *tagLabel = [self createTagLable];
            tagLabel.text = tag;
            [self addSubview:tagLabel];
            [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastObj) {
                    make.top.equalTo(lastObj.mas_top);
                    make.left.equalTo(lastObj.mas_right).offset(CompatibleIpadSize(10));
                } else {
                    make.top.equalTo(self.openCourseTimeGC.mas_bottom).offset(CompatibleIpadSize(14.5));
                    make.left.equalTo(self.lessonNoBtn.mas_left);
                }
                make.height.mas_equalTo(CompatibleIpadSize(19.5));
            }];
            lastObj = tagLabel;
        }
    }
}

- (void)removeTagLabels {
    for (id subView in self.subviews) {
        if ([subView isKindOfClass:[AIEdgeInsetLabel class]]) {
            [subView removeFromSuperview];
        }
    }
}


- (AIEdgeInsetLabel *)createTagLable {
    AIEdgeInsetLabel *aLabel = [[AIEdgeInsetLabel alloc] initWithEdgeInset:UIEdgeInsetsMake(5, 4, 5, 4)];
    aLabel.backgroundColor = Color(0xFFF8EF);
    aLabel.font = Font_GEW(10);
    aLabel.textColor = Color(0xFF9516);
    aLabel.textAlignment = NSTextAlignmentCenter;
    aLabel.layer.borderColor = Color(0xFFC682).CGColor;
    aLabel.layer.borderWidth = 1;
    aLabel.layer.cornerRadius = 5;
    aLabel.layer.masksToBounds = YES;
    return aLabel;
}


@end

@implementation AILessonCardCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupLessonCardCell];
    }
    return self;
}

- (void)setupLessonCardCell{
    _lessonTitleLal = ({
        UILabel *aLabel = [[UILabel alloc]init];
        aLabel.font = Font_GEW(18);
        aLabel.textColor = Color(0x1a1a1a);
        aLabel;
    });
    [self.contentView addSubview:_lessonTitleLal];
    [_lessonTitleLal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(CompatibleIpadSize(15));
    }];
    
    _lessonCardView = [[ALLessonCardCellItemView alloc]init];
    [self.contentView addSubview:_lessonCardView];
    [_lessonCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CompatibleIpadSize(27));
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)setupCellModel:(__kindof AILessonCardCellModel *)model{
    [super setupCellModel:model];
    NSString *title = [model.courseTitle copy];
    if (title && [title isKindOfClass:[NSString class]] && title.length > 0) {
        [_lessonCardView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(CompatibleIpadSize(27));
        }];
    } else {
        [_lessonCardView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
        }];
    }
    _lessonTitleLal.text = title;
    
    AILessonMealModel *mealModel = model.coursePackages.firstObject;
    [_lessonCardView updateLessonCardItemView:mealModel.openTimeStamp
                                   lessonName:model.courseName
                                    salePrice:mealModel.originalPrice
                                originalPrice:mealModel.referencePrice
                                   couponName:nil
                                     tagTexts:model.courseTags];
}

+ (NSString *)templateId{
    return @"3";
}

+ (NSString *)templateModelResueIdentifier{
    return [AILessonCardCellModel resueIdentifier];
}

+ (AIModuleSuperLayout *)createCellLayoutWithDataSource:(AICMSModuleDetailInfo *)dataSouce vcTitle:(NSString *)vcTitle{
    NSArray<AICMSModuleContentInfo *> *contents = dataSouce.contents;
    if (!contents || ![contents isKindOfClass:[NSArray class]] || contents.count <= 0) {
        return nil;
    }
    
    __block NSMutableArray <AILessonCardCellModel *> *cellModels = [[NSMutableArray alloc]init];
    [contents enumerateObjectsUsingBlock:^(AICMSModuleContentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AILessonCardCellModel *model = [[AILessonCardCellModel alloc]init];
        model.content_title = obj.eventTrackingName;
        model.module_id = dataSouce.moduleId;
        model.template_title = dataSouce.name;
        model.content_id = obj.contentId;
        model.title = vcTitle;
        model.location_order = [@(idx + 1) stringValue];
        [obj.customFields enumerateObjectsUsingBlock:^(AICMSCustomFieldInfo * _Nonnull c_obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([c_obj.fieldName isEqualToString:@"jumpUrl"]) {
                model.jumpUrl = c_obj.value.firstObject;
            }
            if ([c_obj.fieldName isEqualToString:@"requireLogin"]) {
                model.requireLogin = ([c_obj.value.firstObject integerValue] == 1);
            }
            if ([c_obj.fieldName isEqualToString:@"courseTag"]) {
                model.courseTags = c_obj.value;
            }
            if ([c_obj.fieldName isEqualToString:@"courseName"]) {
                model.courseName = c_obj.value.firstObject;
            }
            if ([c_obj.fieldName isEqualToString:@"coursePackage"]) {
                model.coursePackages = [AILessonMealModel mj_objectArrayWithKeyValuesArray:c_obj.value];
            }
        }];
        model.didSelectedHandler = ^(__kindof AIModuleSuperCellModel * _Nonnull d_model, NSIndexPath * _Nonnull indexPath) {
            if ([AICMSManager sharedInstance].didSelectedCellHandler) {
                [AICMSManager sharedInstance].didSelectedCellHandler(d_model, indexPath);
            }
            if ([AICMSManager sharedInstance].reportEventHandler) {
                [AICMSManager sharedInstance].reportEventHandler(d_model, indexPath);
            }
        };
        model.didAppearHandler = ^(__kindof AIModuleSuperCellModel * _Nonnull d_model, NSIndexPath * _Nonnull indexPath) {
            if ([AICMSManager sharedInstance].reportWillAppearEventHandler) {
                [AICMSManager sharedInstance].reportWillAppearEventHandler(d_model, indexPath);
            }
        };
        [cellModels addObject:model];
    }];
    if (cellModels.count <= 0) {
        return nil;
    }
    
    //设置总标题
    AILessonCardCellModel *model = cellModels.firstObject;
    model.courseTitle = dataSouce.title;
    
    AIModuleLineListLayout *layout = [[AIModuleLineListLayout alloc]init];
    layout.backgroundColor = [UIColor whiteColor];
    layout.insets = UIEdgeInsetsMake(0, 0, [dataSouce.marginBottom floatValue], 0);
    layout.lineHeightAtIndex = ^CGFloat(NSUInteger index) {
        if (index >= 0 && index < cellModels.count) {
            AILessonCardCellModel *model = cellModels[index];
            if (model.courseTitle) {
                return CompatibleIpadSize(197);
            }
        }
        return CompatibleIpadSize(170);
    };
    layout.defLineSpace = 0;
    layout.cellModels = cellModels;
    return layout;
}
@end
