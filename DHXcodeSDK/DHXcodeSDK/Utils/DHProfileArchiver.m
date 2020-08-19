//
//  DHProfileArchiver.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHProfileArchiver.h"
#import "DHProfileModel.h"
#import "DHArchiver.h"
#import "DHProfileCacher.h"

@implementation DHProfileArchiver

+ (BOOL)archiveCachedProfiles {
    return [self archiveProfiles:[DHProfileCacher profilesCaches]];
}

+ (BOOL)archiveProfiles:(NSDictionary *)profiles {
    NSString *file = [self file];
    return [DHArchiver archiveObject:profiles withFile:file];
}

+ (BOOL)unarchiveProfiles {
    NSString *file = [self file];
    NSSet *classes = [self suppportUnarchivedClasses];
    NSDictionary *profiles;
    DHERROR_CODE ret = [DHArchiver unarchivedObjectOfClasses:classes
                                                    withFile:file
                                            unarchivedObject:&profiles];
    // 进行缓存
    DHXcodeLog(@"Unarchive profiles result: %zd", ret);
    if (!dh_isNoError(ret)) { return NO; }
    // 更新到缓存
    [DHProfileCacher cacheProfiles:profiles];
    return YES;
}

// 可解档类
+ (NSSet *)suppportUnarchivedClasses {
    return [NSSet setWithArray:@[
        NSArray.class,
        DHProfileModel.class,
        NSDictionary.class
    ]];
}

+ (NSString *)boxDocumentDirectory {
    return [DHPathTools systemAppCachesDirectory];
}

+ (NSString *)filename {
    return @"profiles.archive";
}

+ (NSString *)file {
    return [[self boxDocumentDirectory] stringByAppendingPathComponent:[self filename]];
}
@end
