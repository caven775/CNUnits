//
//  CNUnitsDefine.h
//  Pods
//
//  Created by Caven on 2020/5/23.
//

#ifndef CNUnitsDefine_h
#define CNUnitsDefine_h
#import "CNUnits.h"

#define CNMD5(string) cMD5(string)
#define CNVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define CNScreenWidth [UIScreen mainScreen].bounds.size.width
#define CNScreenHeight [UIScreen mainScreen].bounds.size.height
#define CNIsFullScreen UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
#define CNStatusBarHeight (CNVersion >= 8.0 ? ([[UIApplication sharedApplication] statusBarFrame].size.height) : (CNIsFullScreen ? ([[UIApplication sharedApplication] statusBarFrame].size.width) : ([[UIApplication sharedApplication] statusBarFrame].size.height)))
#define CNNaviHeight (CNStatusBarHeight + 44)

#ifdef DEBUG
#define CNFILENAME [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define CNLog(...) NSLog(@"%s 第%d行: %s\n", [CNFILENAME UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define CNLog(...)
#endif

#ifndef cweakify
#if __has_feature(objc_arc)

#define cweakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#else

#define cweakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif
#endif /* weakify */

#ifndef cstrongify
#if __has_feature(objc_arc)

#define cstrongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop") \
if(!self) return;
#else

#define cstrongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")

#endif
#endif /* strongify */

#endif /* CNUnitsDefine_h */
