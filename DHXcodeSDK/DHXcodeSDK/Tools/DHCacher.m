//
//  DHCacher.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHCacher.h"

@interface DHCacher ()
/// 缓存
@property (nonatomic, strong) NSMutableDictionary *cache;
@end

@implementation DHCacher
#pragma mark - singleton
+ (instancetype)cacher {
    static DHCacher *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DHCacher alloc] init];
    });
    return _instance;
}


#pragma mark - public class methods
+ (BOOL)cacheValue:(id)value forKey:(NSString *)key {
    return [[DHCacher cacher] cacheValue:value forKey:key];
}

+ (BOOL)removeCacheForKey:(NSString *)key {
    return [[DHCacher cacher] removeCacheForKey:key];
}

+ (id)cacheValueForKey:(NSString *)key {
    return [[DHCacher cacher] cacheValueForKey:key];
}

+ (NSDictionary *)allCachedMap {
    return [[DHCacher cacher] cache];
}

#pragma mark - private methods
- (BOOL)cacheValue:(id)value forKey:(NSString *)key {
    if (![DHObjectTools isValidString:key]) { return NO; }
    if (!value) { return NO; }
    [self.cache setValue:value forKey:key];
    
    return YES;
}

- (BOOL)removeCacheForKey:(NSString *)key {
    if (![DHObjectTools isValidString:key]) { return NO; }
    [self.cache removeObjectForKey:key];
    return YES;
}

- (id)cacheValueForKey:(NSString *)key {
    if (![DHObjectTools isValidString:key]) { return nil; }
    return [self.cache objectForKey:key];
}


#pragma mark - getter & setter
- (NSMutableDictionary *)cache {
    if (!_cache) {
        _cache = [NSMutableDictionary dictionary];
    }
    return _cache;
}

@end
