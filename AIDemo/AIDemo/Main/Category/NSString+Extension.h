//
//  NSString+Extension.h
//  AIDemo
//
//  Created by fengsl on 2021/5/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)


- (NSString *)al_stringByURLEncode;

//拼接业务地址
- (NSString *)hostByAppendingBusinessAddress:(NSString *_Nonnull)businessAddress;

//随机产生N个字符串
+ (NSString *)randomNSString:(NSUInteger)numOfChars;

- (NSString *_Nonnull)getRequestAddParams:(NSDictionary *_Nullable)params;


/// 是不是手机号码
- (BOOL)isPhoneNum;


/// 复制到剪切板(全设备)
- (void)copyToGeneralPasteboard;


/// 从url取值
/// @param key 健值对
- (NSString *)getUrlValueWithKey:(NSString *)key;


//字符串反转
- (NSString *)reversed;


- (NSDictionary *)getUrlParmas;

//判断是否为整形：
- (BOOL)isPureInt;

//判断是否为浮点形：
- (BOOL)isPureFloat;
@end

//系统地址
@interface NSString (SystemPath)

/**
 用于存储不可再生用户数据。
 可通过配置实现iTunes共享文件。
 可被iTunes备份。

 Documents/Inbox：该目录用来保存由外部应用请求当前应用程序打开的文件。
 可被iTunes备份。
 eg：应用A向系统注册了几种可打开的文件格式。
 B应用有一个A支持的格式的文件F，并且申请调用A打开F。
 沙盒机制是不允许A访问B沙盒中的文件。
 因此苹果的解决方案是讲F拷贝一份到A应用的Documents/Inbox目录下，再让A打开F。

 @return document路径
 */
+ (NSString *)documentPath;

/**
 苹果建议用来存放默认设置或其它状态信息。
 可创建子文件夹。
 除Caches子目录外都会被被iTunes同步。

 Library/Preferences：应用程序的偏好设置文件。不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好.
 Library/Caches：用于保存可再生的文件,比如网络请求的数据。应用程序通常还需要负责删除这些文件。

 @return library路径
 */
+ (NSString *)libraryPath;

/**
 用于保存可再生的文件,比如网络请求的数据。应用程序通常还需要负责删除这些文件。

 @return libraryCaches路径
 */
+ (NSString *)cachesPath;

/**
 这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息。
 该目录下的文件随时有可能被系统清理掉。eg：系统磁盘存储空间不足的时候。
 该路径下的文件不会被iTunes备份。

 @return temp路径
 */
+ (NSString *)tempPath;



/// 应用全局缓存根目录，可以清除的
+ (NSString *)appCachesPath;

/// 应用全局根目录
+ (NSString *)appRootPath;

///判断path是否存在
+ (BOOL)fileExistAtPath: (NSString *)path;

//判断字符串是否纯数字
- (BOOL)isPureInt;

+ (NSString *)timeStampConvertToTime:(NSString *)timestamp andDateFormat:(NSString *)dateFormat isReturnWeek:(BOOL)isReturnWeek;

///把时间格式的字符串转换成NSDate
- (NSDate *)timeStringToDateWithDateFormat:(NSString *)dateFormat;

///去除不需要的字符
+ (NSString *)removeSpecialCharacterWithContentStr:(NSString *)content;

///自动处理url字符串含有中文的情况：如果含有中文，就进行转义
- (NSString *)URLEncodedString;

@end

NS_ASSUME_NONNULL_END
