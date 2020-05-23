//
//  CNUnits.m
//  Pods
//
//  Created by Caven on 2020/5/23.
//

#import "CNUnits.h"
#import <CommonCrypto/CommonDigest.h>

/// 线程安全
/// @param block 线程执行
void cThreadSafe(dispatch_block_t block)
{
    if ([[NSThread currentThread] isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/// 16进制颜色
/// @param color 色值
/// @param alpha 透明度
UIColor *cColorA(NSInteger color, CGFloat alpha)
{
    return [UIColor colorWithRed:((CGFloat)((color & 0xFF0000) >> 16)) / 255.0f
    green:((CGFloat)((color & 0xFF00) >> 8)) / 255.0f
     blue:((CGFloat)(color & 0xFF)) / 255.0f
    alpha:alpha];
}

/// 16进制颜色
/// @param color 色值
UIColor *cColor(NSInteger color)
{
    return cColorA(color, 1.0);
}

/// 平方常规字体
/// @param fontSize 字号
UIFont *cFontDefault(CGFloat fontSize)
{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
}

/// 平方中间字体
/// @param fontSize 字号
UIFont *cFontMedium(CGFloat fontSize)
{
    return [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize];
}

/// 平方加粗字体
/// @param fontSize 字号
UIFont *cFontBold(CGFloat fontSize)
{
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize];
}

/// md5字符串
/// @param string 字符串
NSString *cMD5(NSString *string)
{
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result);
    NSMutableString *results = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [results appendFormat:@"%02x", result[i]];
    }
    return results;
}

NSDate *_cDate2YMD(NSDate *date)
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:date];
    return [fmt dateFromString:selfStr];
}

/// 获取NSDateFormatter
/// @param format 日期格式
NSDateFormatter *cDateFormatter(NSString *format)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    return dateFormatter;
}

/// NSDate转字符串
/// @param date 日期
/// @param format 日期格式
NSString *cDate2String(NSDate *date, NSString *format)
{
    return [cDateFormatter(format) stringFromDate:date];
}

/// 日期字符串转NSDate
/// @param date 日期字符串
/// @param format 日期格式
NSDate *cString2Date(NSString *date, NSString *format)
{
    return [cDateFormatter(format) dateFromString:date];
}

/// 日期字符串转时间戳
/// @param date 日期字符串
/// @param format 日期格式
NSTimeInterval cString2Timestamp(NSString *date, NSString *format)
{
    return [cString2Date(date, format) timeIntervalSince1970];
}

/// 时间戳转日期字符串
/// @param timestamp 时间戳
/// @param format 日期格式
NSString *cTimestamp2String(NSTimeInterval timestamp, NSString *format)
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return cDate2String(date, format);
}

/// 是否为今天
/// @param date 日期
BOOL cIsToday(NSDate *date)
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    return (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/// 是否为昨天
/// @param date 日期
BOOL cIsYesterday(NSDate *date)
{
    NSDate *nowDate = _cDate2YMD([NSDate date]);
    NSDate *selfDate = _cDate2YMD(date);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

