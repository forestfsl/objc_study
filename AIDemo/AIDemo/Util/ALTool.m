//
//  ALTool.m
//  AIDemo
//
//  Created by fengsl on 2021/5/30.
//

#import "ALTool.h"
#import "SceneDelegate.h"

static CGFloat __statusBarHeight = 0.f;

@implementation ALTool

+ (NSArray <NSTextCheckingResult *> *)searchRangeContainsChinese:(NSString *)content {
    if (!content || ![content isKindOfClass:[NSString class]] || content.length <= 0) {
        return nil;
    }
    NSString *regexStr = @"[\u4e00-\u9fa5]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:nil];
    return [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];
}


/// 状态栏高度
+ (CGFloat)al_statusBarHeight {
    
    UIWindow* window = nil;
    
    if (@available(iOS 13.0, *))
    {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
        {
            window = windowScene.windows.firstObject;
            break;
        }
    }else{
        window = [UIApplication sharedApplication].keyWindow;
    }
    
    if (__statusBarHeight > 0) {
        return __statusBarHeight;
    }
    if (@available(iOS 13.0, *)) {
        __statusBarHeight = window.windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        __statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    return __statusBarHeight;
}


@end
