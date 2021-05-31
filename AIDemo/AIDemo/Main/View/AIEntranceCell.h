//
//  AIEntranceCell.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AIModuleSuperCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface AIEntranceCellItemInfo : NSObject
@property (nonatomic, copy) NSString *jumpUrl;
@property (nonatomic, assign) BOOL requireLogin;
@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, copy) NSString *content_title;
@property (nonatomic, copy) NSString *module_id;
@property (nonatomic, copy) NSString *template_title;
@property (nonatomic, copy) NSString *content_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *location_order;

@end

@interface AIEntranceCellModel : AIModuleSuperCellModel
@property (nonatomic, strong) NSArray < AIEntranceCellItemInfo *> *itemInfos;

@end


@interface AIEntranceCell : AIModuleSuperCell
@property (nonatomic, strong) NSMutableArray <UIButton *> * imageViews;

@end

NS_ASSUME_NONNULL_END
