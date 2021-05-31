//
//  AILessonCardCellV2.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AIModuleSuperCell.h"
#import "AILessonCardCell.h"


@class AIGraphicControl;

@interface AILessonCardCellModelV2 : AIModuleSuperCellModel
@property (nonatomic, assign) BOOL isLast;//是不是最后一个
@property (nonatomic, copy) NSString *courseTitle;//总标题
@property (nonatomic, strong) NSArray <NSString *> *courseTags;//课程标签
@property (nonatomic, copy) NSString *courseName;//课程名称
@property (nonatomic, strong) NSArray <AILessonMealModel *> *coursePackages;//课程套餐

@end


@interface AILessonCardCellItemViewV2 : UIView
@property (nonatomic, strong) UIView *backgroundImageview;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *openCourseTimeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *originPriceLabel;
@property (nonatomic, strong) AILessonCardCellModelV2 *model;

@end


@interface AILessonCardCellV2 : AIModuleSuperCell

@property (nonatomic, strong) UILabel *lessonTitleLal;
@property (nonatomic, strong) AILessonCardCellItemViewV2 *lessonCardView;

+ (CGFloat)lessonCardViewTopWithHasTitleTop;
+ (CGFloat)lessonCardViewTopWithHasNoTitleTop;

+ (CGFloat)cardCellBottom;
+ (CGFloat)lastIndexBottom;

@end

