//
//  NSString+Extension.m
//  AIDemo
//
//  Created by fengsl on 2021/5/30.
//

#import "NSString+Extension.h"
#import "Macro.h"
#import "ALTool.h"
#import "NSString+Extension.h"
#import "NSString+YYAdd.h"

@implementation NSString (Extension)

- (NSDictionary *)getUrlParmas {
    if (self.length <= 0) {
        return nil;
    }

    NSURLComponents *components = [[NSURLComponents alloc] initWithString:self];
    NSArray<NSURLQueryItem *> *queryItems = [components.queryItems copy];
    if (!queryItems || ![queryItems isKindOfClass:[NSArray class]] || queryItems.count <= 0) {
        return nil;
    }
    __block NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *key = [obj.name copy];
        NSString *value = [obj.value copy];
        if (key && value) {
            [parms setObject:value forKey:key];
        }
    }];
    return [parms copy];
}

- (NSString *)al_stringByURLEncode {
    if (self.length <= 0) {
        return [self copy];
    }

    NSArray <NSTextCheckingResult *> *resultList = [ALTool searchRangeContainsChinese:self];
    if (!resultList || ![resultList isKindOfClass:[NSArray class]] || resultList.count <= 0) {
        return [self copy];
    }
    NSString *resultContent = [self copy];
    NSInteger count = resultList.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        NSTextCheckingResult *match = resultList[i];
        NSRange range = match.range;
        NSString *subText = [resultContent substringWithRange:range];
        resultContent = [resultContent stringByReplacingCharactersInRange:range withString:[subText stringByURLEncode]];
    }
    return resultContent;
}

//拼接业务地址
- (NSString *)hostByAppendingBusinessAddress:(NSString *_Nonnull)businessAddress {
    if ([self hasSuffix:@"/"] && [businessAddress hasPrefix:@"/"]) {
        return [self stringByAppendingString:[businessAddress substringFromIndex:1]];
    } else if (![self hasSuffix:@"/"] && ![businessAddress hasPrefix:@"/"]) {
        return [self stringByAppendingFormat:@"/%@", businessAddress];
    }
    return [self stringByAppendingString:businessAddress];
}

//随机产生N个字符串
+ (NSString *)randomNSString:(NSUInteger)numOfChars {
    char data[numOfChars];
    for (NSUInteger x = 0; x < numOfChars; x++) {
        data[x] = (char)('A' + (arc4random_uniform(26)));
    }
    return [[NSString alloc] initWithBytes:data length:numOfChars encoding:NSUTF8StringEncoding];
}

- (NSString *_Nonnull)getRequestAddParams:(NSDictionary *_Nullable)params {
    if (dictionaryIsEmpty(params)) {
        return [self copy];
    } else {
        __block NSString *tmpURLString = [self copy];
        if ([tmpURLString hasSuffix:@"/"]) {
            tmpURLString = [tmpURLString substringToIndex:tmpURLString.length - 1];
        }
        if ([tmpURLString containsString:@"?"]) {
            tmpURLString = [tmpURLString stringByAppendingString:@"&"];
        } else {
            tmpURLString = [tmpURLString stringByAppendingString:@"?"];
        }
        [params enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, NSString *_Nonnull obj, BOOL *_Nonnull stop) {
            tmpURLString = [tmpURLString stringByAppendingFormat:@"%@=%@&", key, obj];
        }];

        if ([tmpURLString hasSuffix:@"&"]) {
            tmpURLString = [tmpURLString substringToIndex:tmpURLString.length - 1];
        }
        return tmpURLString;
    }
}

- (BOOL)isPhoneNum {
    if (self.length > 0) {
        NSArray *numList = @[@"0",
                             @"1",
                             @"2",
                             @"3",
                             @"4",
                             @"5",
                             @"6",
                             @"7",
                             @"8",
                             @"9"];
        BOOL isNum = YES;
        for (NSInteger i = 0; i < self.length; i++) {
            NSString *charString = [self substringWithRange:NSMakeRange(i, 1)];
            if (![numList containsObject:charString]) {
                isNum = NO;
                break;
            }
        }
        return isNum;
    }
    return NO;
}

/// 复制到剪切板
- (void)copyToGeneralPasteboard {
    [[UIPasteboard generalPasteboard] setString:self];
}

- (NSString *)getUrlValueWithKey:(NSString *)key {
    if ([key length] <= 0) {
        return nil;
    }

    //添加后缀
    if (![key hasSuffix:@"="]) {
        key = [key stringByAppendingString:@"="];
    }

    NSString *str = nil;
    NSString *url = self;
    NSRange start = [url rangeOfString:key];
    if (start.location != NSNotFound) {
        NSRange end = [[url substringFromIndex:start.location + start.length] rangeOfString:@"&"];
        NSUInteger offset = start.location + start.length;
        str = end.location == NSNotFound
        ? [url substringFromIndex:offset]
        : [url substringWithRange:NSMakeRange(offset, end.location)];
        str =   [str stringByRemovingPercentEncoding];
    }
    return str;
}

//字符串反转
- (NSString *)reversed {
    NSMutableString *s = [NSMutableString string];
    for (NSUInteger i = self.length; i > 0; i--) {
        [s appendString:[self substringWithRange:NSMakeRange(i - 1, 1)]];
    }
    return s;
}


//判断是否为整形：
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

@end

@implementation NSString (SystemPath)

+ (NSString *)documentPath {
    static NSString *documentPath;
    if (!documentPath) {
        documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    }
    return documentPath;
}

+ (NSString *)libraryPath {
    static NSString *libraryPath;
    if (!libraryPath) {
        libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
    }
    return libraryPath;
}

+ (NSString *)cachesPath {
    static NSString *libraryCachesPath;
    if (!libraryCachesPath) {
        libraryCachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    }
    return libraryCachesPath;
}

+ (NSString *)tempPath {
    return NSTemporaryDirectory();
}

/// 应用全局缓存根目录
+ (NSString *)appCachesPath {
    static NSString *appRootCachesFolder;
    if (!appRootCachesFolder) {
        appRootCachesFolder = [[self appRootPath] stringByAppendingPathComponent:@"Caches"];
        NSFileManager *fileManager = NSFileManager.defaultManager;
        if (![fileManager fileExistsAtPath:appRootCachesFolder]) {
            [fileManager createDirectoryAtPath:appRootCachesFolder
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:nil];
        }
    }
    return appRootCachesFolder;
}

/// 应用全局根目录
+ (NSString *)appRootPath {
    static NSString *appRootFolder;
    if (!appRootFolder) {
        appRootFolder = [[self cachesPath] stringByAppendingPathComponent:@"AILesson"];
        NSFileManager *fileManager = NSFileManager.defaultManager;
        if (![fileManager fileExistsAtPath:appRootFolder]) {
            [fileManager createDirectoryAtPath:appRootFolder
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:nil];
        }
    }
    return appRootFolder;
}

///判断路径是否存在
+ (BOOL)fileExistAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    return [fileManager fileExistsAtPath:path];
}

//判断字符串是否纯数字
- (BOOL)isPureInt {
  NSScanner *scan = [NSScanner scannerWithString:self];
  int val;
  return [scan scanInt:&val] && [scan isAtEnd];
}

+ (NSString *)timeStampConvertToTime:(NSString *)timestamp andDateFormat:(NSString *)dateFormat isReturnWeek:(BOOL)isReturnWeek {
  // 时间字符串
   NSString *timeStr = timestamp;
   // 时间字符串转换时段
   NSTimeInterval time = [timeStr doubleValue];
   // 时段转换时间
   NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
   // 时间格式
   NSDateFormatter *dataformatter = [[NSDateFormatter alloc] init];
   dataformatter.dateFormat = dateFormat;
   // 时间转换字符串
   NSString *resultStr = [dataformatter stringFromDate:date];

   if (!isReturnWeek) return resultStr;
   
   NSCalendar *gregorian = [[NSCalendar alloc]
                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   NSDateComponents *weekdayComponents =
   [gregorian components:NSCalendarUnitWeekday fromDate:date];
   NSInteger _weekday = [weekdayComponents weekday];
   NSString *weekStr;
   if (_weekday == 1) {
       weekStr = @"周日";
   } else if (_weekday == 2) {
       weekStr = @"周一";
   } else if (_weekday == 3) {
       weekStr = @"周二";
   } else if (_weekday == 4) {
       weekStr = @"周三";
   } else if (_weekday == 5) {
       weekStr = @"周四";
   } else if (_weekday == 6) {
       weekStr = @"周五";
   } else if (_weekday == 7) {
       weekStr = @"周六";
   }
  
   NSString *returnStr =  [NSString stringWithFormat:@"%@ %@",resultStr, weekStr];
   return returnStr;
}

- (NSDate *)timeStringToDateWithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter dateFromString:self];
}

+ (NSString *)removeSpecialCharacterWithContentStr:(NSString *)content {
    NSString *urlStr = content;
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return urlStr;
}

- (NSString *)URLEncodedString {
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

@end
