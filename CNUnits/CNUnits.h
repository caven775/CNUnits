//
//  CNUnits.h
//  Pods
//
//  Created by Caven on 2020/5/23.
//

#import <UIKit/UIKit.h>

/// 线程安全
/// @param block 线程执行
extern void cThreadSafe(dispatch_block_t block);

/// 16进制颜色
/// @param color 色值
/// @param alpha 透明度
extern UIColor *cColorA(NSInteger color, CGFloat alpha);

/// 16进制颜色
/// @param color 色值
extern UIColor *cColor(NSInteger color);

/// 平方常规字体
/// @param fontSize 字号
extern UIFont *cFontDefault(CGFloat fontSize);

/// 平方中间字体
/// @param fontSize 字号
extern UIFont *cFontMedium(CGFloat fontSize);

/// 平方加粗字体
/// @param fontSize 字号
extern UIFont *cFontBold(CGFloat fontSize);

/// md5字符串
/// @param string 字符串
extern NSString *cMD5(NSString *string);

/// NSDate转字符串
/// @param date 日期
/// @param format 日期格式
extern NSString *cDate2String(NSDate *date, NSString *format);

/// 日期字符串转NSDate
/// @param date 日期字符串
/// @param format 日期格式
extern NSDate *cString2Date(NSString *date, NSString *format);

/// 日期字符串转时间戳
/// @param date 日期字符串
/// @param format 日期格式
extern NSTimeInterval cString2Timestamp(NSString *date, NSString *format);

/// 时间戳转日期字符串
/// @param timestamp 时间戳
/// @param format 日期格式
extern NSString *cTimestamp2String(NSTimeInterval timestamp, NSString *format);

/// 是否为今天
/// @param date 日期
extern BOOL cIsToday(NSDate *date);

/// 是否为昨天
/// @param date 日期
extern BOOL cIsYesterday(NSDate *date);

/// OC对象转JSON字符串
/// @param obj OC对象
extern NSString *cObj2Json(id obj);

/// JSON字符串转OC对象
/// @param json JSON字符串
extern id cJson2Obj(NSString *json);

/// 获取渐变图层
/// @param rect 图层大小
/// @param colors 渐变色
extern CAGradientLayer *cGradientLayer(CGRect rect, NSArray <UIColor *>*colors);
