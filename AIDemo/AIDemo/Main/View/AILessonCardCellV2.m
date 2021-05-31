//
//  AILessonCardCellV2.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AILessonCardCellV2.h"
#import "AIGraphicControl.h"
#import "AICMSManager.h"
#import "NSString+Extension.h"
#import "AIModuleLineListLayout.h"
#import <Masonry/Masonry.h>
#import "AIEdgeInsetLabel.h"
#import "Macro.h"
#import <Masonry/Masonry.h>
#import "AICMSManager.h"
#import <MJExtension/MJExtension.h>

@implementation AILessonCardCellModelV2



@end

@implementation AILessonCardCellItemViewV2

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLessonCardCellItemView];
    }
    return self;
}

- (void)setupLessonCardCellItemView {
    _backgroundImageview = [[UIView alloc] init];
    _backgroundImageview.backgroundColor = [UIColor whiteColor];
    _backgroundImageview.layer.cornerRadius = CompatibleIpadSize(16);
    _backgroundImageview.layer.shadowOffset = CGSizeMake(0, CompatibleIpadSize(12));
    _backgroundImageview.layer.shadowOpacity = 1;
    _backgroundImageview.layer.shadowColor = ColorA(0xAAB4C3,0.2).CGColor;
    _backgroundImageview.layer.shadowRadius = CompatibleIpadSize(28);
    [self addSubview:_backgroundImageview];
    [_backgroundImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(CompatibleIpadSize(15));
        make.right.mas_equalTo(CompatibleIpadSize(-15));
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = Font_GEW(20);
    _nameLabel.textColor = Color(0x222326);
    [_backgroundImageview addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CompatibleIpadSize(24));
        make.left.mas_equalTo(CompatibleIpadSize(20));
        make.right.mas_equalTo(CompatibleIpadSize(-20));
        make.height.mas_equalTo(CompatibleIpadSize(24));
    }];
    
    _openCourseTimeLabel = [[UILabel alloc] init];
    _openCourseTimeLabel.font = Font_EEW(13);
    _openCourseTimeLabel.textColor = Color(0x93969D);
    [_backgroundImageview addSubview:_openCourseTimeLabel];
    [_openCourseTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(CompatibleIpadSize(2));
        make.left.mas_equalTo(CompatibleIpadSize(20));
        make.right.mas_equalTo(CompatibleIpadSize(-20));
        make.height.mas_equalTo(CompatibleIpadSize(17));
    }];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.font = Font_DA(16);
    _priceLabel.textColor = Color(0xFF4D00);
    [_backgroundImageview addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.mas_equalTo(CompatibleIpadSize(-20));
        make.height.mas_equalTo(CompatibleIpadSize(30));
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = Color(0xEFEFF3);
    [_backgroundImageview addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CompatibleIpadSize(20));
        make.width.mas_equalTo(CompatibleIpadSize(1));
        make.centerY.equalTo(self.priceLabel);
        make.left.equalTo(self.priceLabel.mas_right).offset(CompatibleIpadSize(8));
    }];
    _lineView.hidden = YES;
    
    _originPriceLabel = [[UILabel alloc] init];
    _originPriceLabel.textColor = Color(0x93969D);
    _originPriceLabel.font = Font_EEW(13);
    [_backgroundImageview addSubview:_originPriceLabel];
    [_originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(CompatibleIpadSize(8));
        make.centerY.equalTo(self.priceLabel);
        make.height.mas_equalTo(CompatibleIpadSize(15));
    }];
    _originPriceLabel.hidden = YES;
}

- (void)setModel:(AILessonCardCellModelV2 *)model{
   _model = model;
   NSString *title = [model.courseTitle copy];
   CGFloat top = [AILessonCardCellV2 lessonCardViewTopWithHasNoTitleTop];
   if (title && [title isKindOfClass:[NSString class]] && title.length > 0) {
       top = [AILessonCardCellV2 lessonCardViewTopWithHasTitleTop];
   }
   
   CGFloat bottom = [AILessonCardCellV2 cardCellBottom];
   if (model.isLast) {
       bottom += [AILessonCardCellV2 lastIndexBottom];
   }
   
   [_backgroundImageview mas_updateConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(top);
       make.bottom.mas_equalTo(-bottom);
   }];
   
   AILessonMealModel *mealModel = model.coursePackages.firstObject;
   //只处理一个
   [self updateLessonCardItemView:mealModel
                       lessonName:model.courseName
                        salePrice:mealModel.originalPrice
                    originalPrice:mealModel.referencePrice
                         tagTexts:model.courseTags];
   
}


- (NSString *)timeStampConvertToTime:(NSString *)timestamp
                      andDateFormat:(NSString *)dateFormat{
   // 时间字符串
   NSString *timeStr = timestamp;
   // 时间字符串转换时段
   NSTimeInterval time = [timeStr doubleValue];
   // 时段转换时间
   NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
   // 时间格式
   NSDateFormatter *dataformatter = [[NSDateFormatter alloc] init];
   dataformatter.dateFormat = dateFormat;
   // 时间转换字符串
   NSString *resultStr = [dataformatter stringFromDate:date];
   
   
   NSCalendar *gregorian = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   NSDateComponents *weekdayComponents =
   [gregorian components:NSCalendarUnitWeekday fromDate:date];
   NSInteger _weekday = [weekdayComponents weekday];
   NSString *weekStr;
   if (_weekday == 1) {
       weekStr = @"周日";
   } else if (_weekday == 2) {
       weekStr = @"周一";
   } else if (_weekday == 3) {
       weekStr = @"周二";
   } else if (_weekday == 4) {
       weekStr = @"周三";
   } else if (_weekday == 5) {
       weekStr = @"周四";
   } else if (_weekday == 6) {
       weekStr = @"周五";
   } else if (_weekday == 7) {
       weekStr = @"周六";
   }
   
   return [NSString stringWithFormat:@"%@(%@)",resultStr, weekStr];
}


- (void)updateLessonCardItemView:(AILessonMealModel *)mealModel
                     lessonName:(NSString *)lessonName
                      salePrice:(NSString *)salePrice
                  originalPrice:(NSString *)originalPrice
                       tagTexts:(NSArray <NSString *> *)tgaTexts {
   _nameLabel.text = lessonName;
   if ([mealModel hasOpentimeStamp]) {
       _openCourseTimeLabel.hidden = NO;
       NSString * openTimeStamp = mealModel.openTimeStamp;
       NSString *courseTime = [self timeStampConvertToTime:[NSString stringWithFormat:@"%f", ([openTimeStamp doubleValue] / 1000.0)]
                                             andDateFormat:@"MM月dd日"];
       _openCourseTimeLabel.text = [courseTime stringByAppendingString:@"入学"];
   } else {
       _openCourseTimeLabel.hidden = YES;
   }
 
   [self updatePriceLabelWithPrice:[salePrice floatValue] / 100.0];
   if (originalPrice) {
       _originPriceLabel.hidden = NO;
       _lineView.hidden = NO;
       if ([originalPrice isPureInt] || [originalPrice isPureFloat]) {
           [self updateOriginPriceLalbel:[NSString stringWithFormat:@"原价%.2f元", [originalPrice floatValue] / 100.0]];
       } else {
           [self updateOriginPriceLalbel:originalPrice];
       }
   } else {
       _originPriceLabel.hidden = YES;
       _lineView.hidden = YES;
   }
   [self updateTagLabels:tgaTexts];
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
   NSString *priceTemp = [@"¥ " stringByAppendingString:priceString];
   
   NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
   NSAttributedString *attrTempString = [[NSAttributedString alloc] initWithString:priceTemp
                                                                        attributes:@{ NSFontAttributeName: Font_DA(16),
                                                                                      NSForegroundColorAttributeName: Color(0xFF4D00) }];
   [attrString appendAttributedString:attrTempString];
   NSRange range = [priceTemp rangeOfString:priceString];
   [attrString addAttributes:@{ NSFontAttributeName: Font_DA(30) } range:range];
   self.priceLabel.attributedText = attrString;
}

- (void)updateTagLabels:(NSArray <NSString *> *)tags {
   [self removeTagLabels];
   if (tags && [tags isKindOfClass:[NSArray class]] && tags.count > 0) {
       AIEdgeInsetLabel *lastObj = nil;
       UIColor * o_Color = Color(0xFF9C00);
       UIColor * o_BgColor = ColorA(0xFF9C00,0.1);
       UIColor * s_Color = Color(0x2998EC);
       UIColor * s_BgColor = ColorA(0x2998EC,0.1);
       UIColor * t_Color = Color(0x4FB910);
       UIColor * t_BgColor = ColorA(0x4FB910,0.1);
       
       AILessonMealModel *mealModel = self.model.coursePackages.firstObject;
       
       CGFloat totalWidth = UIMainScreenWidth - CompatibleIpadSize(15) * 2 - CompatibleIpadSize(20) * 2;
       CGFloat currentTotalWidth = 0;
       CGFloat midPadding = CompatibleIpadSize(5);
       for (NSInteger i = 0; i < tags.count ;i++) {
           NSString *tag = tags[i];
           AIEdgeInsetLabel *tagLabel = [self createTagLable];
           tagLabel.text = tag;
           CGRect rect = [tag boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CompatibleIpadSize(20))
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{ NSFontAttributeName: Font_GEW(13) } context:nil];
           currentTotalWidth += (rect.size.width + CompatibleIpadSize(12));
           if (currentTotalWidth > totalWidth) {
               tagLabel.hidden = YES;
           }
           
           currentTotalWidth += midPadding;//中间间距
           
           [_backgroundImageview addSubview:tagLabel];
           NSInteger readIndex = (i + 1);
           NSInteger moreIndex = (readIndex % 3);
           if (moreIndex == 0) {
               tagLabel.backgroundColor = t_BgColor;
               tagLabel.textColor = t_Color;
           } else if(moreIndex == 2) {
               tagLabel.backgroundColor = s_BgColor;
               tagLabel.textColor = s_Color;
           } else {
               tagLabel.backgroundColor = o_BgColor;
               tagLabel.textColor = o_Color;
           }
           
           [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               if (lastObj) {
                   make.centerY.equalTo(lastObj);
                   make.left.equalTo(lastObj.mas_right).offset(midPadding);
               } else {
                   if ([mealModel hasOpentimeStamp]) {
                       make.top.equalTo(self.openCourseTimeLabel.mas_bottom).offset(CompatibleIpadSize(11));
                   } else {
                       make.top.equalTo(self.nameLabel.mas_bottom).offset(CompatibleIpadSize(11));
                   }
                   make.left.equalTo(self.nameLabel.mas_left);
               }
               make.height.mas_equalTo(CompatibleIpadSize(24));
           }];
           lastObj = tagLabel;
       }
   }
}

- (void)removeTagLabels {
   for (id subView in self.backgroundImageview.subviews) {
       if ([subView isKindOfClass:[AIEdgeInsetLabel class]]) {
           [subView removeFromSuperview];
       }
   }
}

- (AIEdgeInsetLabel *)createTagLable {
   AIEdgeInsetLabel *aLabel = [[AIEdgeInsetLabel alloc] initWithEdgeInset:UIEdgeInsetsMake(3.5, 6, 3.5, 6)];
   aLabel.font = Font_EEW(13);
   aLabel.textAlignment = NSTextAlignmentCenter;
   aLabel.layer.cornerRadius = CompatibleIpadSize(4);
   aLabel.layer.masksToBounds = YES;
   return aLabel;
}

@end

@implementation AILessonCardCellV2

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLessonCardCell];
    }
    return self;
}

- (void)setupLessonCardCell {
    _lessonTitleLal = ({
        UILabel *aLabel = [[UILabel alloc] init];
        aLabel.font = Font_GEW(20);
        aLabel.textColor = Color(0x5B5C5F);
        aLabel;
    });
    [self.contentView addSubview:_lessonTitleLal];
    [_lessonTitleLal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(CompatibleIpadSize(15));
    }];
    
    _lessonCardView = [[AILessonCardCellItemViewV2 alloc] init];
    [self.contentView addSubview:_lessonCardView];
    [_lessonCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}


+ (CGFloat)lessonCardViewTopWithHasTitleTop{
    return CompatibleIpadSize(4) + [self lessonCardViewTopWithHasNoTitleTop];
}

+ (CGFloat)lessonCardViewTopWithHasNoTitleTop{
    return CompatibleIpadSize(8);
}

- (void)setupCellModel:(__kindof AILessonCardCellModelV2 *)model {
    [super setupCellModel:model];
    NSString *title = [model.courseTitle copy];
    CGFloat height = 0;
    if (title && [title isKindOfClass:[NSString class]] && title.length > 0) {
        height = [AILessonCardCellV2 courseTitleHeight];
    }
    [_lessonCardView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(height);
    }];
    _lessonTitleLal.text = title;
    _lessonCardView.model = model;
}

#pragma mark - 公共

+ (NSString *)templateId {
    return @"5";
}

+ (NSString *)templateModelResueIdentifier {
    return [AILessonCardCellModelV2 resueIdentifier];
}

+ (AIModuleSuperLayout *)createCellLayoutWithDataSource:(AICMSModuleDetailInfo *)dataSource vcTitle:(NSString *)vcTitle {
    NSArray<AICMSModuleContentInfo *> *contents = dataSource.contents;
    NSInteger count = contents.count;
    if (!contents
        || ![contents isKindOfClass:[NSArray class]]
        || count <= 0) {
        return nil;
    }
    
    __block NSMutableArray <AILessonCardCellModelV2 *> *cellModels = [[NSMutableArray alloc] init];
    [contents enumerateObjectsUsingBlock:^(AICMSModuleContentInfo *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        AILessonCardCellModelV2 *model = [[AILessonCardCellModelV2 alloc] init];
        model.content_title = obj.eventTrackingName;
        model.module_id = dataSource.moduleId;
        model.template_title = dataSource.name;
        model.content_id = obj.contentId;
        model.title = vcTitle;
        model.location_order = [@(idx  + 1) stringValue];
        [obj.customFields enumerateObjectsUsingBlock:^(AICMSCustomFieldInfo *_Nonnull c_obj, NSUInteger idx, BOOL *_Nonnull stop) {
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
        model.isLast = ((count - 1) == idx);
        model.didSelectedHandler = ^(__kindof AIModuleSuperCellModel *_Nonnull d_model, NSIndexPath *_Nonnull indexPath) {
            if ([AICMSManager sharedInstance].didSelectedCellHandler) {
                [AICMSManager sharedInstance].didSelectedCellHandler(d_model, indexPath);
            }
            
            if ([AICMSManager sharedInstance].reportEventHandler) {
                [AICMSManager sharedInstance].reportEventHandler(d_model, indexPath);
            }
        };
        model.didAppearHandler = ^(__kindof AIModuleSuperCellModel *_Nonnull d_model, NSIndexPath *_Nonnull indexPath) {
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
    AILessonCardCellModelV2 *model = cellModels.firstObject;
    model.courseTitle = dataSource.title;
    
    AIModuleLineListLayout *layout = [[AIModuleLineListLayout alloc] init];
    layout.backgroundColor = [UIColor whiteColor];
    layout.insets = UIEdgeInsetsMake(0, 0, [dataSource.marginBottom floatValue], 0);
    layout.lineHeightAtIndex = ^CGFloat (NSUInteger index) {
        CGFloat height = 0;
        AILessonCardCellModelV2 *model = nil;
        if (index >= 0 && index < cellModels.count) {
            model = cellModels[index];
        }
        
        if (model.courseTitle) {
            height += [AILessonCardCellV2 courseTitleHeight] + [AILessonCardCellV2 lessonCardViewTopWithHasTitleTop];//top
        } else {
            height += [AILessonCardCellV2 lessonCardViewTopWithHasNoTitleTop];//top
        }
        
        
        AILessonMealModel * mealModel = model.coursePackages.firstObject;
        if ([mealModel hasOpentimeStamp]) {//开课时间错
            height += [AILessonCardCellV2 hasOpenTimeStampCardViewHeight];
        } else {
            height += [AILessonCardCellV2 noOpenTimeStampCardViewHeight];
        }
        
        height += [AILessonCardCellV2 cardCellBottom];//bottom
        
        if (model.isLast) {//最后一个补12
            height += [AILessonCardCellV2 lastIndexBottom];
        }
        return height;
    };
    layout.defLineSpace = 0;
    layout.cellModels = cellModels;
    return layout;
}

+ (CGFloat)cardCellBottom{
    return CompatibleIpadSize(8);
}


+ (CGFloat)lastIndexBottom{
    return CompatibleIpadSize(12);
}

+ (CGFloat)hasOpenTimeStampCardViewHeight{
    return CompatibleIpadSize(173);
}

+ (CGFloat)noOpenTimeStampCardViewHeight{
    return CompatibleIpadSize(154);
}

+ (CGFloat)courseTitleHeight{
    return CompatibleIpadSize(24);
}

@end
