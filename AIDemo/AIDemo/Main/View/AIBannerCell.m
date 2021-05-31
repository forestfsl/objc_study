//
//  AIBannerCell.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AIBannerCell.h"
#import <MJExtension/MJExtension.h>
#import "AIModuleLineListLayout.h"
#import "Macro.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <MJExtension/MJProperty.h>
#import "AIPageControl.h"
#import <Masonry/Masonry.h>
#import "AICMSManager.h"
#import "SceneDelegate.h"
#import "ALHomeCarouselItemView.h"
#import <SDWebImage/SDWebImage.h>


@implementation AIBannerImageModel



@end

@implementation AIBannerCellModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"imageInfos":@"AIBannerImageModel"};
}

@end


@interface AIBannerCell()<SDCycleScrollViewDelegate,ZGPageControlDelegate>
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) AIPageControl *pageControl;

@end


@implementation AIBannerCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupBannerCell];
    }
    return self;
}

- (void)setupBannerCell{
    _scrollView = [[SDCycleScrollView alloc]init];
    _scrollView.autoScroll = YES;
    _scrollView.autoScrollTimeInterval = 5;
    _scrollView.delegate = self;
    _scrollView.showPageControl = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    _scrollView.layer.cornerRadius = 5;
    _scrollView.layer.masksToBounds = YES;
    [self.contentView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(CompatibleIpadSize(-11));
    }];
    
    _pageControl = [[AIPageControl alloc]init];
    _pageControl.delegate = self;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.cornerRadiusOfPages = CompatibleIpadSize(3);
    _pageControl.currentPageIndicatorTintColor = Color(0xFFAF4C);
    _pageControl.pageIndicatorTintColor = Color(0xB3B3B3);
    [self.contentView addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.mas_equalTo(0);
        make.height.mas_equalTo(CompatibleIpadSize(6));
        make.width.mas_equalTo(CompatibleIpadSize(100));
    }];
}

- (void)setupCellModel:(__kindof  AIBannerCellModel*)model{
    [super setupCellModel:model];
    NSInteger count = model.imageInfos.count;
    if (count > 0) {
        __block NSMutableArray *imageUrls = [[NSMutableArray alloc]init];
        [model.imageInfos enumerateObjectsUsingBlock:^(AIBannerImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *url = [obj.imageUrl copy];
            if (url.length > 0) {
                [imageUrls addObject:url];
            }
        }];
        self.scrollView.imageURLStringsGroup = imageUrls;
        _pageControl.numberOfPages = count;
    }else{
        _pageControl.hidden = YES;
    }
}



#pragma mark - 公共方法

+ (NSString *)templateId {
    return @"1";
}

+ (NSString *)templateModelResueIdentifier {
    return [AIBannerCellModel resueIdentifier];
}

+ (AIModuleSuperLayout *)createCellLayoutWithDataSource:(AICMSModuleDetailInfo *)dataSouce vcTitle:(NSString *)vcTitle{
    NSArray<AICMSModuleContentInfo *> *contents = dataSouce.contents;
    if (!contents || ![contents isKindOfClass:[NSArray class]] || contents.count <= 0) {
        return nil;
    }
    __block NSMutableArray <AIBannerImageModel *> *imageModels = [[NSMutableArray alloc]init];
    [contents enumerateObjectsUsingBlock:^(AICMSModuleContentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AIBannerImageModel *model = [[AIBannerImageModel alloc]init];
        model.title = vcTitle;
        model.content_title = obj.eventTrackingName;
        model.content_id = obj.contentId;
        model.template_title = dataSouce.name;
        model.location_order = [@(idx + 1) stringValue];
        [obj.customFields enumerateObjectsUsingBlock:^(AICMSCustomFieldInfo * _Nonnull c_obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
        [imageModels addObject:model];
    }];
    if (imageModels.count <= 0) {
        return nil;
    }
    AIModuleLineListLayout *layout = [[AIModuleLineListLayout alloc]init];
    layout.insets = UIEdgeInsetsMake(0, 0, [dataSouce.marginBottom floatValue], 0);
    layout.backgroundColor = [UIColor whiteColor];
    NSArray <AICMSCustomFieldInfo *> *customFields = dataSouce.customFields;
    __block CGFloat proportion = 1.0;
    [customFields enumerateObjectsUsingBlock:^(AICMSCustomFieldInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.fieldName isEqualToString:@"proportion"]) {
            NSString *value = obj.value.firstObject;
            if (value && [value isKindOfClass:[NSString class]] && value.length > 0) {
                NSArray <NSString *> *proportionList = [value componentsSeparatedByString:@":"];
//                "marginBottom": 25,
//                        "customFields": [{
//                            "fieldName": "proportion",
//                            "value": ["690:280"]
//                        }],
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
    if (imageModels && imageModels.count > 0) {
        layout.defLineSpace = CompatibleIpadSize(11);
    }
    layout.cellModels = @[({
        AIBannerCellModel *cellModel = [[AIBannerCellModel alloc]init];
        cellModel.imageInfos = imageModels;
        cellModel;
    })];
    return layout;
}


#pragma mark ZZPageControlDelegate

- (void)pagecontrol:(ZGPageControl *)control didSelectedIndex:(NSInteger)index{
    [_scrollView makeScrollViewScrollToIndex:index];
}

#pragma mark - SDCycleScrollViewDelegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    AIBannerCellModel *cellModel = (AIBannerCellModel *)self.model;
    if (index >= 0 && index < cellModel.imageInfos.count) {
        AIBannerImageModel *imageModel = cellModel.imageInfos[index];
        if ([AICMSManager sharedInstance].didSelectedCellHandler) {
            [AICMSManager sharedInstance].didSelectedCellHandler(imageModel, nil);
        }
        if ([AICMSManager sharedInstance].reportEventHandler) {
            [AICMSManager sharedInstance].reportEventHandler(imageModel, nil);
        }
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
  _pageControl.currentPage = index;
    AIBannerCellModel *cellModel = (AIBannerCellModel *)self.model;
  if (index >= 0 && index < cellModel.imageInfos.count
      && [self isShowCurrentViewController]
      && [self isItemImageViewDisplayedInScreen:self.scrollView]) {
      AIBannerImageModel *imageModel = cellModel.imageInfos[index];
        if ([AICMSManager sharedInstance].reportWillAppearEventHandler) {
            [AICMSManager sharedInstance].reportWillAppearEventHandler(imageModel, nil);
        }
    }
}

- (BOOL)isShowCurrentViewController{
  return ([self my_appTopViewController] == [self viewController]);
}


/// App全局最上面的VC
- (UIViewController *)my_appTopViewController {
  
    UIWindow* window = nil;
    
    if (@available(iOS 13.0, *))
    {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
        {
            if (windowScene.activationState == UISceneActivationStateForegroundActive)
            {
                window = windowScene.windows.firstObject;
                
                break;
            }
        }
    }else{
        window = [UIApplication sharedApplication].keyWindow;
    }
    UIViewController *resultVC = [self _topViewController:[window rootViewController]];
  while (resultVC.presentedViewController){
        resultVC = [self _topViewController:resultVC.presentedViewController];
  }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)rootVC {
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)rootVC topViewController]];
    } else if ([rootVC isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)rootVC selectedViewController]];
    } else {
        return rootVC;
    }
    return nil;
}

- (UIViewController *)viewController{
    for (UIView* next = [self.contentView superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (BOOL)isItemImageViewDisplayedInScreen:(UIView *)imgView {
    if (imgView == nil) {
        return NO;
    }
    
    // 若imgView隐藏
    if (imgView.hidden) {
        return NO;
    }
    
    // 若没有superview
    if (imgView.superview == nil) {
        return NO;
    }
    
    // 转换imgView对应cell的Rect
    CGRect rect = [self.contentView convertRect:imgView.frame toView:[self al_keyWindow]];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return NO;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  NO;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    // 获取imgView与window交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }
    
    //检测横向与屏幕交界，还没完全显示出来的
    if (((rect.origin.x+rect.size.width) > screenRect.size.width)) {
        return NO;
    }

    return YES;
}

- (UIWindow *)al_keyWindow {
    __block UIWindow *keyWindow = nil;
    [[UIApplication sharedApplication].windows enumerateObjectsUsingBlock:^(__kindof UIWindow *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.tag == kAL_Main_Window_Tag) {
            keyWindow = obj;
            *stop = YES;
        }
    }];
    return keyWindow;
}

/** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的class。 */
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
    return [ALHomeCarouselItemView class];
}

/** 如果你自定义了cell样式，请在实现此代理方法为你的cell填充数据以及其它一系列设置 */
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
    AIBannerCellModel *cellModel = (AIBannerCellModel *)self.model;
    if (index >= 0 && index < cellModel.imageInfos.count) {
        AIBannerImageModel *imageModel = cellModel.imageInfos[index];
        ALHomeCarouselItemView *itemView = (ALHomeCarouselItemView *)cell;
        [itemView.imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.imageUrl] placeholderImage:[UIImage imageNamed:@"pic_placeholder_home"]];
    }
}


@end
