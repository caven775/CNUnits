//
//  NSObject+CNObjectSafety.m
//  CardView
//
//  Created by Caven on 2019/1/26.
//  Copyright © 2019 Caven. All rights reserved.
//

#import "NSObject+CNObjectSafety.h"
#import <objc/runtime.h>

@implementation NSObject (CNObjectSafety)

+ (void)cn_safetyMethodSwizzlingWithOriginalSelector:(SEL)originalSelector
                                  bySwizzledSelector:(SEL)swizzledSelector
{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class,originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (id)objectForKeyedSubscript:(NSString *)key
{
    [self _debugLog:_cmd];
    return nil;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    [self _debugLog:_cmd];
    return nil;
}

- (id)objectForKey:(NSString *)key
{
    [self _debugLog:_cmd];
    return nil;
}

- (id)objectAtIndex:(NSUInteger)idx
{
    [self _debugLog:_cmd];
    return nil;
}

- (void)_debugLog:(SEL)sel
{
#if DEBUG
    NSLog(@"%@ 未实现方法-->%@，调用栈 == %@", NSStringFromClass(self.class), NSStringFromSelector(sel), [NSThread callStackSymbols]);
#endif
}

@end


#pragma mark NSDictionary

@interface NSDictionary (HXDictionaryObjectSafety)
@end

@implementation NSDictionary (HXDictionaryObjectSafety)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSPlaceholderDictionary");
        [class cn_safetyMethodSwizzlingWithOriginalSelector:@selector(initWithObjects:forKeys:count:)
                                         bySwizzledSelector:@selector(cn_safetyInitWithObjects:forKeys:count:)];
    });
}

- (instancetype)cn_safetyInitWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt
{
    id safetyObjects[cnt];
    id safetyKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
#if DEBUG
            NSLog(@">>>>>> object is nil, 调用栈 == %@", [NSThread callStackSymbols]);
#endif
        }
        safetyKeys[j] = key;
        safetyObjects[j] = obj;
        j++;
    }
    return [self cn_safetyInitWithObjects:safetyObjects forKeys:safetyKeys count:j];
}

@end


#pragma mark NSMutableDictionary

@interface NSMutableDictionary (HXMutableDictionaryObjectSafety)
@end

@implementation NSMutableDictionary (HXMutableDictionaryObjectSafety)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _NSDictionaryM = NSClassFromString(@"__NSDictionaryM");
        [_NSDictionaryM cn_safetyMethodSwizzlingWithOriginalSelector:@selector(removeObjectForKey:)
                                                  bySwizzledSelector:@selector(cn_safetyMRemoveObjectForKey:)];
    });
}

- (void)cn_safetyMRemoveObjectForKey:(id)aKey
{
    if (!aKey) {
        aKey = @"";
#if DEBUG
        NSLog(@">>>>>> aKey is nil, remove object failed, 调用栈 == %@", [NSThread callStackSymbols]);
#endif
    }
    [self cn_safetyMRemoveObjectForKey:aKey];
}

@end


#pragma mark NSArray
@interface NSArray (HXArrayObjectSafety)
@end

@implementation NSArray (HXArrayObjectSafety)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class placeClass = NSClassFromString(@"__NSPlaceholderArray");
        [placeClass cn_safetyMethodSwizzlingWithOriginalSelector:@selector(initWithObjects:count:)
                                              bySwizzledSelector:@selector(cn_safetyInitWithObjects:count:)];
        
        Class _NSArrayI = NSClassFromString(@"__NSArrayI");
        Class __NSSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
        
        [_NSArrayI cn_safetyMethodSwizzlingWithOriginalSelector:@selector(objectAtIndexedSubscript:)
                                              bySwizzledSelector:@selector(cn_safetyObjectAtIndexedSubscript:)];
        
        [_NSArrayI cn_safetyMethodSwizzlingWithOriginalSelector:@selector(objectAtIndex:)
                                             bySwizzledSelector:@selector(cn_safetyObjectAtIndex:)];
        [__NSSingleObjectArrayI cn_safetyMethodSwizzlingWithOriginalSelector:@selector(objectAtIndex:)
                                                          bySwizzledSelector:@selector(cn_safetySingleObjectAtIndex:)];
    });
}

- (instancetype)cn_safetyInitWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    id safetyObjects[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id obj = objects[i];
        if (!obj) {
            obj = [NSNull null];
#if DEBUG
            NSLog(@"insert object is nil, 调用栈 == %@", [NSThread callStackSymbols]);
#endif
        }
        safetyObjects[j] = obj;
        j++;
    }
    return [self cn_safetyInitWithObjects:safetyObjects count:j];
}

- (id)cn_safetyObjectAtIndexedSubscript:(NSUInteger)idx
{
    if (idx >= 0 && idx < self.count) {
        return [self cn_safetyObjectAtIndexedSubscript:idx];
    }
    [self cn_safetyDescriptionForIndex:idx];
    return nil;
}

- (id)cn_safetyObjectAtIndex:(NSUInteger)index
{
    if (index >= 0 && index < self.count) {
        return [self cn_safetyObjectAtIndex:index];
    }
    [self cn_safetyDescriptionForIndex:index];
    return nil;
}

- (id)cn_safetySingleObjectAtIndex:(NSUInteger)index
{
    if (index >= 0 && index < self.count) {
        return [self cn_safetySingleObjectAtIndex:index];
    }
    [self cn_safetyDescriptionForIndex:index];
    return nil;
}

- (void)cn_safetyDescriptionForIndex:(NSUInteger)idx
{
#if DEBUG
    NSLog(@">>>>>> array (%@) count is %ld, %ld beyond bounds, 调用栈 == %@", self, (long)self.count, (long)idx, [NSThread callStackSymbols]);
#endif
}

@end


#pragma mark NSMutableArray
@interface NSMutableArray (HXMutableArrayObjectSafety)
@end

@implementation NSMutableArray (HXMutableArrayObjectSafety)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _NSArrayM = NSClassFromString(@"__NSArrayM");
        [_NSArrayM cn_safetyMethodSwizzlingWithOriginalSelector:@selector(objectAtIndexedSubscript:)
                                             bySwizzledSelector:@selector(cn_safetyMObjectAtIndexedSubscript:)];
        
        [_NSArrayM cn_safetyMethodSwizzlingWithOriginalSelector:@selector(objectAtIndex:)
                                             bySwizzledSelector:@selector(cn_safetyMObjectAtIndex:)];
        
        [_NSArrayM cn_safetyMethodSwizzlingWithOriginalSelector:@selector(insertObject:atIndex:)
                                             bySwizzledSelector:@selector(cn_safetyMInsertObject:atIndex:)];
    });
}

- (id)cn_safetyMObjectAtIndexedSubscript:(NSUInteger)idx
{
    if (idx >= 0 && idx < self.count) {
        return [self cn_safetyMObjectAtIndexedSubscript:idx];
    }
    [self cn_safetyMDescriptionForIndex:idx];
    return nil;
}

- (id)cn_safetyMObjectAtIndex:(NSUInteger)idx
{
    if (idx >= 0 && idx < self.count) {
        return [self cn_safetyMObjectAtIndex:idx];
    }
    [self cn_safetyMDescriptionForIndex:idx];
    return nil;
}

- (void)cn_safetyMInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (!anObject) {
        anObject = NSNull.null;
#if DEBUG
        NSLog(@">>>>>> %@ insert object is nil, replace it with NSNull.null, 调用栈 == %@", self, [NSThread callStackSymbols]);
#endif
    }
    if (index > self.count) {
        index = self.count;
#if DEBUG
        NSLog(@">>>>>> %@ index (%ld) beyond bounds, insert it in last, 调用栈 == %@", self, (long)index, [NSThread callStackSymbols]);
#endif
    }
    [self cn_safetyMInsertObject:anObject atIndex:index];
}

- (void)cn_safetyMDescriptionForIndex:(NSUInteger)idx
{
#if DEBUG
    NSLog(@">>>>>> array (%@) count is %ld, %ld beyond bounds, 调用栈 == %@", self, (long)self.count, (long)idx, [NSThread callStackSymbols]);
#endif
}

@end
