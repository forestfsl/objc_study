//
//  AICMSTipsCell.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AICMSTipsCell.h"
#import <SDWebImage/SDWebImage.h>
#import "AICMSManager.h"
#import "AIModuleLineListLayout.h"
#import "Macro.h"
#import <Masonry/Masonry.h>

@implementation AICMSTipsContentInfo


@end

@implementation AICMSTipsCellModel



@end

@implementation AICMSTipsCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupCmsTipsCell];
    }
    return self;
}

- (void)setupCmsTipsCell{
    UIView *midView = [[UIView alloc]init];
    midView.backgroundColor = Color(0xf2f2f2);
    midView.layer.cornerRadius = CompatibleIpadSize(5);
    midView.layer.masksToBounds = YES;
    [self.contentView addSubview:midView];
    [midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(CompatibleIpadSize(15));
        make.right.mas_equalTo(CompatibleIpadSize(-15));
    }];
    
    _iconView = [[UIImageView alloc]init];
    [midView addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(CompatibleIpadSize(13));
        make.centerY.mas_equalTo(0);
        make.height.width.mas_equalTo(CompatibleIpadSize(16));
    }];
    
    _lrr_Label = [[AILeftRightRotationLabel alloc]init];
    _lrr_Label.titleFont = Font_EEW(12);
    _lrr_Label.titleColor = Color(0x000000);
    _lrr_Label.textPadding = CompatibleIpadSize(8);
    _lrr_Label.standardCarouselWidth = UIMainScreenWidth - CompatibleIpadSize(82);
    __weak typeof(self) weakSelf = self;
    _lrr_Label.titleDidPressedHandler = ^(NSInteger idx, NSString * _Nonnull currentTitle) {
        [weakSelf titleDidPressedHandler:idx currentTitle:currentTitle];
    };
    [midView addSubview:_lrr_Label];
    [_lrr_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(CompatibleIpadSize(5));
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(CompatibleIpadSize(-14));
    }];
}

- (void)titleDidPressedHandler:(NSInteger)idx currentTitle:(NSString *)currentTitle{
    AICMSTipsCellModel *model = (AICMSTipsCellModel *)self.model;
    NSArray <AICMSTipsContentInfo *> *c_titls = model.c_titles;
    if (idx >= 0 && c_titls && [c_titls isKindOfClass:[NSArray class]] && idx < c_titls.count) {
        if ([AICMSManager sharedInstance].didSelectedCellHandler) {
            [AICMSManager sharedInstance].didSelectedCellHandler(c_titls[idx], nil);
        }
    }
}

- (void)setupCellModel:(__kindof AICMSTipsCellModel *)model {
    [super setupCellModel:model];
    NSString *iconUrl = [model.c_iconUrl copy];
    if (iconUrl && [iconUrl isKindOfClass:[NSString class]] && iconUrl.length > 0) {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:model.c_iconUrl]];
        [_lrr_Label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(CompatibleIpadSize(5));
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(CompatibleIpadSize(-14));
        }];
        _iconView.hidden = NO;
    } else {
        _iconView.hidden = YES;
        [_lrr_Label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(CompatibleIpadSize(13));
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(CompatibleIpadSize(-14));
        }];
    }

    __block NSMutableArray <NSString *> *contentList = [[NSMutableArray alloc] init];
    [model.c_titles enumerateObjectsUsingBlock:^(AICMSTipsContentInfo *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *text = [obj.text copy];
        if (text) {
            [contentList addObject:text];
        }
    }];
    _lrr_Label.titles = contentList;
}



+ (NSString *)templateId {
    return @"8";
}

+ (NSString *)templateModelResueIdentifier {
    return [AICMSTipsCellModel resueIdentifier];
}

+ (AIModuleSuperLayout *)createCellLayoutWithDataSource:(AICMSModuleDetailInfo *)dataSouce vcTitle:(NSString *)vcTitle{
    NSArray<AICMSModuleContentInfo *> *contents = dataSouce.contents;
    if (!contents || ![contents isKindOfClass:[NSArray class]] || contents.count <= 0) {
        return nil;
    }
    AICMSTipsCellModel *cellModel = [[AICMSTipsCellModel alloc]init];
    __block NSString *notiIconUrl = nil;
    [dataSouce.customFields enumerateObjectsUsingBlock:^(AICMSCustomFieldInfo * _Nonnull c_obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([c_obj.fieldName isEqualToString:@"icon"]) {
            notiIconUrl = [c_obj.value.firstObject copy];
        }
    }];
    cellModel.c_iconUrl = notiIconUrl;
    __block NSMutableArray <AICMSTipsContentInfo *> *contentList = [[NSMutableArray alloc]init];
    [contents enumerateObjectsUsingBlock:^(AICMSModuleContentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AICMSTipsContentInfo *model = [[AICMSTipsContentInfo alloc]init];
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
            if ([c_obj.fieldName isEqualToString:@"text"]) {
                model.text = c_obj.value.firstObject;
            }
        }];
        [contentList addObject:model];
    }];
    cellModel.c_titles = contentList;
    cellModel.didAppearHandler = ^(__kindof AIModuleSuperCellModel * _Nonnull model, NSIndexPath * _Nonnull indexPath) {
        AICMSTipsCellModel *resultModel = (AICMSTipsCellModel *)model;
        [resultModel.c_titles enumerateObjectsUsingBlock:^(AICMSTipsContentInfo * _Nonnull d_model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([AICMSManager sharedInstance].reportWillAppearEventHandler) {
                [AICMSManager sharedInstance].reportWillAppearEventHandler(d_model, indexPath);
            }
        }];
    };
    //设置背景图
    AIModuleLineListLayout *layout = [[AIModuleLineListLayout alloc]init];
    layout.backgroundColor = [UIColor whiteColor];
    layout.insets = UIEdgeInsetsMake(0, 0, [dataSouce.marginBottom floatValue], 0);
    layout.defLineHeight = CompatibleIpadSize(26);
    layout.defLineSpace = 0;
    layout.cellModels = @[cellModel];
    return layout;
}


@end
