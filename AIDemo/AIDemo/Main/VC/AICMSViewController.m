//
//  AICMSViewController.m
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import "AICMSViewController.h"
#import "AICMSManager.h"
#import "AppDelegate.h"
#import "ALTool.h"

@interface AICMSViewController ()

@end

@implementation AICMSViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupCollectionView];
    [self setupDefaultTemplateModels];
    [self compatibleSystemAPI];
    [self setupCollectionViewConstraints];
}

- (void)setupCollectionView{
    self.flow = [[AIModuleLayoutEngine alloc] init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flow];
    [self.flow bindCollectionViewDelegateWithScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.view addSubview:self.collectionView];
}

- (void)setupDefaultTemplateModels{
    //注册模板
    NSDictionary <NSString *,NSString *> *templateModels = [[AICMSManager sharedInstance] getRegisterTemplateModels];
    __weak typeof(self) weakSelf = self;
    [templateModels enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [weakSelf.flow registerCellClass:NSClassFromString(key) modelClass:NSClassFromString(obj)];
    }];
}

- (void)compatibleSystemAPI{
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    if ([self.collectionView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.collectionView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)setupCollectionViewConstraints{
    CGFloat barHeight = [ALTool al_statusBarHeight];
    if ([self prefersNavigationBarHidden]) {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(barHeight);
        }];
    }else{
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
}

- (AIModuleSuperLayout *)collectionHeaderView{
    NSLog(@"头部视图，业务可以配置");
    return nil;
}

- (BOOL)canAddCollectionHeaderView:(NSArray<__kindof AIModuleSuperLayout *> *)layouts{
    NSLog(@"头部视图，业务可以配置");
    if (!layouts || ![layouts isKindOfClass:[NSArray class]] || layouts.count <= 0) {
        return YES;
    }
    return NO;
    
}

//是否需要隐藏导航栏
- (BOOL)prefersNavigationBarHidden {
    return YES;
}

/// 统计标题，用于埋点，子类必须设置
- (NSString *)analyticsTitle {
    NSString *title = [self.title copy];
    if (title && title.length > 0) {
        return title;
    }
    return @"";
}

- (void)reloadData{
    AIModuleSuperLayout *headerLayout = [self collectionHeaderView];
    if (headerLayout && [self canAddCollectionHeaderView:_flow.layouts]) {
        NSMutableArray *layouts = [[NSMutableArray alloc]init];
        if (_flow.layouts && [_flow.layouts isKindOfClass:[NSArray class]]  && _flow.layouts.count > 0) {
            [layouts addObjectsFromArray:_flow.layouts];
        }
        [layouts insertObject:headerLayout atIndex:0];
        _flow.layouts = layouts;
    }
    [_flow reloadData];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
