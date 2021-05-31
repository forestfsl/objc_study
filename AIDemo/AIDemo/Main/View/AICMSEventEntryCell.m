//
//  AICMSEventEntryCell.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AICMSEventEntryCell.h"
#import "AIModuleLineListLayout.h"
#import "AICMSManager.h"
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>
#import "Macro.h"

@implementation AICMSEventEntryCellModel



@end

@implementation AICMSEventEntryCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupCMSEventEntryCell];
    }
    return self;
}

- (void)setupCMSEventEntryCell{
    _iconView = [[UIImageView alloc]init];
    [self.contentView addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(CompatibleIpadSize(20));
        make.left.mas_equalTo(CompatibleIpadSize(15));
    }];
    _titleLal = ({
        UILabel *aLabel = [[UILabel alloc]init];
        aLabel.font = Font_EEW(15);
        aLabel.textColor = Color(0x000000);
        aLabel;
    });
    [self.contentView addSubview:_titleLal];
    [_titleLal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.equalTo(self.iconView.mas_right).offset(CompatibleIpadSize(8));
    }];
    
    _rightArrowView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_right_arrow"]];
    [self.contentView addSubview:_rightArrowView];
    [_rightArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(CompatibleIpadSize(8));
        make.height.mas_equalTo(CompatibleIpadSize(13));
        make.right.mas_equalTo(CompatibleIpadSize(-15));
    }];
    _subTitleLabel = [[UILabel alloc]init];
    _subTitleLabel.font = Font_EEW(12);
    _subTitleLabel.textColor = Color(0x808080);
    [self.contentView addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightArrowView.mas_left).offset(CompatibleIpadSize(-5));
        make.width.mas_equalTo([[UIScreen mainScreen] bounds].size.width / 2);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)setupCellModel:(__kindof AICMSEventEntryCellModel *)model{
    [super setupCellModel:model];
    _titleLal.text = model.content_title;
    _subTitleLabel.text = model.c_subTitle;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.c_iconUrl] completed:nil];
}

+ (NSString *)templateId{
    return @"7";
}

+ (NSString *)templateModelResueIdentifier{
    return [AICMSEventEntryCellModel resueIdentifier];
}

+ (AIModuleSuperLayout *)createCellLayoutWithDataSource:(AICMSModuleDetailInfo *)dataSouce vcTitle:(NSString *)vcTitle{
    NSArray<AICMSModuleContentInfo *> *contents = dataSouce.contents;
    if (!contents || ![contents isKindOfClass:[NSArray class]] || contents.count <= 0) {
        return nil;
    }
    __block NSMutableArray <AICMSEventEntryCellModel *> *cellModels = [[NSMutableArray alloc]init];
    [contents enumerateObjectsUsingBlock:^(AICMSModuleContentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AICMSEventEntryCellModel *model = [[AICMSEventEntryCellModel alloc]init];
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
            if (([c_obj.fieldName isEqualToString:@"title"])) {
                model.c_title = c_obj.value.firstObject;
            }
            if ([c_obj.fieldName isEqualToString:@"subTitle"]) {
                model.c_subTitle = c_obj.value.firstObject;
            }
            if ([c_obj.fieldName isEqualToString:@"icon"]) {
                model.c_iconUrl = c_obj.value.firstObject;
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
                [AICMSManager sharedInstance].reportEventHandler(d_model, indexPath);
            }
        };
        [cellModels addObject:model];
    }];
    if (cellModels.count <= 0) {
        return nil;
    }
    AIModuleLineListLayout *layout = [[AIModuleLineListLayout alloc]init];
    layout.backgroundColor = [UIColor whiteColor];
    layout.insets = UIEdgeInsetsMake(0, 0, [dataSouce.marginBottom floatValue], 0);
    layout.defLineHeight = CompatibleIpadSize(50);
    layout.defLineSpace = 0;
    layout.cellModels = cellModels;
    return layout;
}
@end
