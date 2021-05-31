//
//  AICMSTipsCell.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AIModuleSuperCell.h"
#import "AILeftRightRotationLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AICMSTipsContentInfo : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *content_title;
@property (nonatomic, copy) NSString *module_id;
@property (nonatomic, copy) NSString *template_title;
@property (nonatomic, copy) NSString *content_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *location_order;
@property (nonatomic, assign) BOOL requireLogin;
@property (nonatomic, copy) NSString *jumpUrl;

@end

@interface AICMSTipsCellModel : AIModuleSuperCellModel

@property (nonatomic, copy) NSString *c_iconUrl;
@property (nonatomic, copy) NSArray<AICMSTipsContentInfo *> *c_titles;
@end



@interface AICMSTipsCell : AIModuleSuperCell
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) AILeftRightRotationLabel *lrr_Label;

@end

NS_ASSUME_NONNULL_END
