//
//  ZGPageControl.h
//  ZGPageControl
//
//  Created by kevenTsang on 2020/1/8.
//  Copyright © 2020 keventsang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZGPageControl;
@protocol ZGPageControlDelegate <NSObject>
@optional
- (void)pagecontrol:(ZGPageControl *)control didSelectedIndex:(NSInteger)index;
@end

@interface ZGPageControl : UIView
@property (nonatomic,weak)id<ZGPageControlDelegate>delegate;
@property (nonatomic)CGFloat  cornerRadiusOfPages;  //default is 5
@property(nonatomic) NSInteger numberOfPages;          // default is 0
@property(nonatomic) NSInteger currentPage;            // default is 0. value pinned to 0..numberOfPages-1
@property (nonatomic)CGFloat  pageSpacing;              //default is 6

@property(nonatomic) BOOL hidesForSinglePage;          // hide the the indicator if there is only one page. default is NO


- (CGSize)sizeForNumberOfPages:(NSInteger)pageIndex;   // default CGSizeMake(6, 6), returns minimum size required to display dots for given page count. can be used to size control if page count could change
- (UIImage *)imageForNumberOfPages:(NSInteger)pageIndex;   // returns image required to display view for given page count. can be used to size control if page count could change

@property(nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;
@property(nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor ;

@end

NS_ASSUME_NONNULL_END
