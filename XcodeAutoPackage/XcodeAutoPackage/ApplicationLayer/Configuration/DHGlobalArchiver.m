//
//  DHGlobalArchiver.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/27.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHGlobalArchiver.h"
#import <DHXcodeSDK/DHXcodeSDK.h>
#import "DHGlobalConfigration.h"
//#import "DHDistributionModel.h"
//#import "DHDistributionFirModel.h"
//#import "DHDistributionPgyerModel.h"
//#import "DHDBConfig.h"

@implementation DHGlobalArchiver
+ (BOOL)archiveGlobalConfiguration {
    
    NSString *file = [self file];
    DHGlobalConfigration *config = [DHGlobalConfigration configuration];
    
    return [DHArchiver archiveObject:config withFile:file];
}

+ (BOOL)unarchiveGlobalConfiguration {
    
    NSString *file = [self file];
    NSSet *classes = [self suppportUnarchivedClasses];
    DHGlobalConfigration *config;
    DHERROR_CODE ret = [DHArchiver unarchivedObjectOfClasses:classes
                                                      withFile:file
                                              unarchivedObject:&config];
    DHLogDebug(@"Unarchive global settings result: %zd\n\
[fromPath: %@]", ret, file);
    if (ret != DHERROR_NO_ERROR) { return NO; }
    // 更新到单例
    [[DHGlobalConfigration configuration] updateWithConfiguration:config];
    return YES;
}

// 可解档类
+ (NSSet *)suppportUnarchivedClasses {
    return [NSSet setWithArray:@[
        NSMutableArray.class,
        NSArray.class,
        DHGlobalConfigration.class,
        DHDistributionModel.class,
        DHDistributionFirModel.class,
        DHDistributionPgyerModel.class
    ]];
}

+ (NSString *)boxDocumentDirectory {
    return [DHCommonTools systemAppCachesDirectory];
//    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)filename {
    return @"global.archive";
}

+ (NSString *)file {
    return [[self boxDocumentDirectory] stringByAppendingPathComponent:[self filename]];
}

@end
