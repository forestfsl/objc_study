//
//  AILessonCardCell.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AIModuleSuperCell.h"

@class AIGraphicControl;



@interface AILessonMealModel : NSObject
@property (nonatomic, copy) NSString *courseMealId;//课程套餐id
@property (nonatomic, copy) NSString *openCourseDate;//开课日期
@property (nonatomic, copy) NSString *name;//课程名
@property (nonatomic, copy) NSString *referencePrice;//参考价格 单位分
@property (nonatomic, copy) NSString *originalPrice;//手机价格 单位分
@property (nonatomic, copy) NSString *openTimeStamp;//最新开课日期时间戳

- (BOOL)hasOpentimeStamp;

@end

@interface AILessonCardCellModel : AIModuleSuperCellModel
@property (nonatomic, copy) NSString *courseTitle;//总标题
@property (nonatomic, strong) NSArray<NSString *> *courseTags;//课程标记
@property (nonatomic, copy) NSString *courseName;//课程名称
@property (nonatomic, strong) NSArray <AILessonMealModel *> *coursePackages;//课程套餐
 
@end

@interface ALLessonCardCellItemView : UIView
@property (nonatomic, strong) UIView *backgroundImageview;
@property (nonatomic, strong) UIButton *lessonNoBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) AIGraphicControl *openCourseTimeGC;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *originPriceLabel;
@property (nonatomic, strong) UILabel *couponNameLabel;

- (void)updateLessonCardItemView:(NSString *)openTimeStamp
                      lessonName:(NSString *)lessonName
                       salePrice:(NSString *)salePrice
                   originalPrice:(NSString *)originalPrice
                      couponName:(NSString *)couponName
                        tagTexts:(NSArray <NSString *> *) tagTexts;


@end

@interface AILessonCardCell : AIModuleSuperCell
@property (nonatomic, strong) UILabel *lessonTitleLal;
@property (nonatomic, strong) ALLessonCardCellItemView *lessonCardView;

@end




