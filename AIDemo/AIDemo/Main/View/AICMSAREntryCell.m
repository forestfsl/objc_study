//
//  AICMSAREntryCell.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AICMSAREntryCell.h"
#import "AIModuleLineListLayout.h"
#import "AICMSManager.h"
#import <Masonry/Masonry.h>
#import "Macro.h"

@implementation AICMSAREntryCellModel



@end

@interface AICMSAREntryCell()
@property (nonatomic, strong) UILabel *titleLal;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *subTitleLal;
@property (nonatomic, strong) UILabel *redLal;
@end


@implementation AICMSAREntryCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupAREntryCell];
    }
    return self;
}

- (void)setupAREntryCell{
    _titleLal = ({
        UILabel *aLabel = [[UILabel alloc] init];
        aLabel.font = Font_GEW(26);
        aLabel.textColor = Color(0x222326);
        aLabel;
    });
    [self.contentView addSubview:_titleLal];
    [_titleLal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(CompatibleIpadSize(20));
    }];
    _titleLal.text = @"咕比启蒙";

    UIView *midView = [[UIView alloc] init];
    midView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:midView];
    [midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-CompatibleIpadSize(20));
    }];
  UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arScanQRBtnDidPressed:)];
  [midView addGestureRecognizer:gesture];

    _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_homepage_scan_new"]];
    [midView addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(CompatibleIpadSize(24));
        make.top.centerX.mas_equalTo(0);
    }];

    CGFloat redRotSize = CompatibleIpadSize(8);
    CGFloat halfSize = redRotSize * 0.5;
    _redLal = [[UILabel alloc] init];
    _redLal.backgroundColor = Color(0xff4d00);
    _redLal.layer.cornerRadius = halfSize;
    _redLal.layer.masksToBounds = YES;
    [_iconView addSubview:_redLal];
    [_redLal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(redRotSize);
        make.top.mas_equalTo(-halfSize);
        make.right.mas_equalTo(halfSize);
    }];
    _redLal.hidden = YES;

    _subTitleLal = ({
        UILabel *aLabel = [[UILabel alloc] init];
        aLabel.font = Font_EEW(11);
        aLabel.textColor = Color(0x5b5c5f);
        aLabel;
    });
    [midView addSubview:_subTitleLal];
    [_subTitleLal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.iconView.mas_bottom).offset(CompatibleIpadSize(2));
    }];
    _subTitleLal.text = @"AR扫画";
}

- (void)arScanQRBtnDidPressed:(UITapGestureRecognizer *)gesture{
  AICMSManager * manager = [AICMSManager sharedInstance];
  if (manager.didSelectedCellHandler) {
    manager.didSelectedCellHandler(self.model, nil);
  }

  if (manager.reportEventHandler) {
    manager.reportEventHandler(self.model, nil);
  }
}

- (void)setupCellModel:(__kindof AICMSAREntryCellModel *)model {
    [super setupCellModel:model];
    if (model.redDotNum > 0) {
        _redLal.hidden = NO;
    } else {
        _redLal.hidden = YES;
    }
}

#pragma mark - 公共

+ (NSString *)templateModelResueIdentifier {
    return [AICMSAREntryCellModel resueIdentifier];
}

+ (NSString *)templateId {
    return @"12";
}

+ (AIModuleSuperLayout *)createCellLayoutWithDataSource:(AICMSModuleDetailInfo *)dataSource vcTitle:(NSString *)vcTitle {
    NSArray<AICMSModuleContentInfo *> *contents = dataSource.contents;
    if (!contents
        || ![contents isKindOfClass:[NSArray class]]
        || contents.count <= 0) {
        return nil;
    }

    AICMSModuleContentInfo *contentInfo = contents.firstObject;
    AICMSAREntryCellModel *cellModel = [[AICMSAREntryCellModel alloc] init];
    cellModel.content_title = contentInfo.eventTrackingName;
    cellModel.module_id = dataSource.moduleId;
    cellModel.template_title = dataSource.name;
    cellModel.content_id = contentInfo.contentId;
    cellModel.title = vcTitle;
    cellModel.location_order = @"1";
    [contentInfo.customFields enumerateObjectsUsingBlock:^(AICMSCustomFieldInfo *_Nonnull c_obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([c_obj.fieldName isEqualToString:@"linkedData"]) {
          NSDictionary * redDotDict = (NSDictionary*)c_obj.value.firstObject;
          if (redDotDict && [redDotDict isKindOfClass:[NSDictionary class]] && redDotDict.count > 0) {
            cellModel.redDotNum = [redDotDict[@"redDotNum"] integerValue];
          }
        }

        if ([c_obj.fieldName isEqualToString:@"jumpUrl"]) {
            cellModel.jumpUrl = c_obj.value.firstObject;
        }

        if ([c_obj.fieldName isEqualToString:@"requireLogin"]) {
            cellModel.requireLogin = ([c_obj.value.firstObject integerValue] == 1);
        }
    }];


    cellModel.didAppearHandler = ^(__kindof AIModuleSuperCellModel *_Nonnull d_model, NSIndexPath *_Nonnull indexPath) {
        if ([AICMSManager sharedInstance].reportWillAppearEventHandler) {
            [AICMSManager sharedInstance].reportWillAppearEventHandler(d_model, indexPath);
        }
    };
//    cellModel.didSelectedHandler = ^(__kindof ALModularSuperCellModel *_Nonnull d_model, NSIndexPath *_Nonnull indexPath) {
//        if ([ALCMSManager shareInstance].didSelectedCellHandler) {
//            [ALCMSManager shareInstance].didSelectedCellHandler(d_model, indexPath);
//        }
//
//        if ([ALCMSManager shareInstance].reportEventHandler) {
//            [ALCMSManager shareInstance].reportEventHandler(d_model, indexPath);
//        }
//    };

    AIModuleLineListLayout *layout = [[AIModuleLineListLayout alloc] init];
    layout.insets = UIEdgeInsetsMake(0, 0, [dataSource.marginBottom floatValue], 0);
    layout.defLineHeight = CompatibleIpadSize(64);
    layout.cellModels = @[cellModel];
    return layout;
}


@end
