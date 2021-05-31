//
//  AICMSEventEntryCell.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AIModuleSuperCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface AICMSEventEntryCellModel : AIModuleSuperCellModel
@property (nonatomic, copy) NSString *c_title;
@property (nonatomic, copy) NSString *c_subTitle;
@property (nonatomic, copy) NSString *c_iconUrl;

@end


@interface AICMSEventEntryCell : AIModuleSuperCell
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLal;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *rightArrowView;

@end

NS_ASSUME_NONNULL_END
