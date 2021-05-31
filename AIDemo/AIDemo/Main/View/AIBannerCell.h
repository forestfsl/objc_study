//
//  AIBannerCell.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AIModuleSuperCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface AIBannerImageModel : NSObject

@property (nonatomic, copy) NSString *jumpUrl;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) BOOL requireLogin;
@property (nonatomic, copy) NSString *content_title;//对应eventTrackingName
@property (nonatomic, copy) NSString *module_id;
@property (nonatomic, copy) NSString *template_title;
@property (nonatomic, copy) NSString *content_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *location_order;

@end

@interface AIBannerCellModel : AIModuleSuperCellModel
@property (nonatomic, strong) NSArray <AIBannerImageModel *> *imageInfos;

@end



//bannerCell 模板
@interface AIBannerCell : AIModuleSuperCell

@end

NS_ASSUME_NONNULL_END
