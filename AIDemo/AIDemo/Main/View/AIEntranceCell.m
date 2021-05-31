//
//  AIEntranceCell.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AIEntranceCell.h"
#import <SDWebImage/SDWebImage.h>
#import "AIModuleLineListLayout.h"
#import "AICMSManager.h"
#import <Masonry/Masonry.h>

@implementation AIEntranceCellItemInfo



@end

@implementation AIEntranceCellModel



@end

@implementation AIEntranceCell

+ (NSString *)templateModelResueIdentifier {
    return [AIEntranceCellModel resueIdentifier];
}

+ (NSString *)templateId {
    return @"2";
}

- (void)setupCellModel:(__kindof  AIEntranceCellModel*)model{
    [super setupCellModel:model];
    [self updateImageView:model.itemInfos];
}

- (void)updateImageView:(NSArray <AIEntranceCellItemInfo *> *)itemInfos{
    [self resetImageViews];
    if (!itemInfos || ![itemInfos isKindOfClass:[NSArray class]] || itemInfos.count <= 0) {
        return;
    }
    
    NSInteger count = itemInfos.count;
    __block UIButton *lastBtn = nil;
    __weak typeof(self) weakSelf = self;
    __block CGFloat widthScale = count > 1 ? 1.0 / count : 1;
    [itemInfos enumerateObjectsUsingBlock:^(AIEntranceCellItemInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsImageWhenDisabled = NO;
        btn.adjustsImageWhenHighlighted = NO;
        [btn addTarget:self action:@selector(entranceDidPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn sd_setImageWithURL:[NSURL URLWithString:obj.imageUrl] forState:UIControlStateNormal completed:nil];
        btn.tag = idx;
        [weakSelf.contentView addSubview:btn];
        [weakSelf.imageViews addObject:btn];
        if (lastBtn) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.height.equalTo(lastBtn);
                make.left.equalTo(lastBtn.mas_right);
                make.width.equalTo(weakSelf).multipliedBy(widthScale);
            }];
        }else{
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.top.mas_equalTo(0);
                make.width.equalTo(weakSelf).multipliedBy(widthScale);
            }];
        }
        lastBtn = btn;
    }];
}


- (void)entranceDidPressed:(UIButton *)btn {
    NSInteger index = btn.tag;
    AIEntranceCellModel *model = (AIEntranceCellModel *)self.model;
    if (index >= 0 && index <= model.itemInfos.count) {
        AIEntranceCellItemInfo *itemInfo = model.itemInfos[index];
        if ([AICMSManager sharedInstance].didSelectedCellHandler) {
            [AICMSManager sharedInstance].didSelectedCellHandler(itemInfo, nil);
        }

        if ([AICMSManager sharedInstance].reportEventHandler) {
            [AICMSManager sharedInstance].reportEventHandler(itemInfo, nil);
        }
    }
}

- (void)resetImageViews{
    if (!_imageViews) {
        _imageViews = [[NSMutableArray alloc]init];
    }
    for (UIView *subView in _imageViews) {
        [subView removeFromSuperview];
    }
    [_imageViews removeAllObjects];
}


+ (AIModuleSuperLayout *)createCellLayoutWithDataSource:(AICMSModuleDetailInfo *)dataSource vcTitle:(NSString *)vcTitle{
    NSArray <AICMSModuleContentInfo *> *contents = dataSource.contents;
    if (!contents || ![contents isKindOfClass:[NSArray class]] || contents.count <= 0) {
        return nil;
    }
    __block NSMutableArray <AIEntranceCellItemInfo *> *itemInfos = [[NSMutableArray alloc]init];
    [contents enumerateObjectsUsingBlock:^(AICMSModuleContentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AIEntranceCellItemInfo *model = [[AIEntranceCellItemInfo alloc]init];
        model.content_title = obj.eventTrackingName;
        model.module_id = dataSource.moduleId;
        model.template_title = dataSource.name;
        model.content_id = obj.contentId;
        model.title = vcTitle;
        model.location_order = [@(idx + 1) stringValue];
        
        [obj.customFields enumerateObjectsUsingBlock:^(AICMSCustomFieldInfo *_Nonnull c_obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([c_obj.fieldName isEqualToString:@"jumpUrl"]) {
                model.jumpUrl = c_obj.value.firstObject;
            }

            if ([c_obj.fieldName isEqualToString:@"image"]) {
                model.imageUrl = c_obj.value.firstObject;
            }

            if ([c_obj.fieldName isEqualToString:@"requireLogin"]) {
                model.requireLogin = ([c_obj.value.firstObject integerValue] == 1);
            }
        }];
        [itemInfos addObject:model];
    }];
    
    if (itemInfos.count <= 0) {
        return nil;
    }

    AIEntranceCellModel *cellModel = [[AIEntranceCellModel alloc] init];
    cellModel.itemInfos = itemInfos;
    cellModel.didAppearHandler = ^(__kindof AIModuleSuperCellModel *_Nonnull model, NSIndexPath *_Nonnull indexPath) {
        AIEntranceCellModel *resultModel = (AIEntranceCellModel *)model;
        [resultModel.itemInfos enumerateObjectsUsingBlock:^(AIEntranceCellItemInfo *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([AICMSManager sharedInstance].reportWillAppearEventHandler) {
                [AICMSManager sharedInstance].reportWillAppearEventHandler(obj, indexPath);
            }
        }];
    };

    AIModuleLineListLayout *layout = [[AIModuleLineListLayout alloc] init];
    layout.insets = UIEdgeInsetsMake(0, 0, [dataSource.marginBottom floatValue], 0);
    NSArray <AICMSCustomFieldInfo *> *customFields = dataSource.customFields;
    __block CGFloat proportion = 1.0;
    [customFields enumerateObjectsUsingBlock:^(AICMSCustomFieldInfo *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj.fieldName isEqualToString:@"proportion"]) {
            NSString *value = obj.value.firstObject;
            if (value && [value isKindOfClass:[NSString class]] && value.length > 0) {
                NSArray <NSString *> *proportionList = [value componentsSeparatedByString:@":"];
                if (proportionList.count == 2) {
                    CGFloat firstValue = [proportionList.firstObject floatValue];//宽
                    CGFloat lastValue = [proportionList.lastObject floatValue];//高
                    if (firstValue > 0) {
                        proportion = lastValue / firstValue;
                    }
                }
            }
            *stop = YES;
        }
    }];
    layout.defHWScale = proportion;
    layout.cellModels = @[cellModel];
    return layout;

}



@end
