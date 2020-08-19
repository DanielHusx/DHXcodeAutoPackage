//
//  DHTaskArchiver.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskArchiver.h"
#import <DHXcodeSDK/DHXcodeSDK.h>
#import "DHTaskModel.h"

@implementation DHTaskArchiver

+ (BOOL)archiveTaskArray:(NSArray<DHTaskModel *> *)taskArray {
    NSString *file = [self file];
    return [DHArchiver archiveObject:taskArray withFile:file];
}

+ (NSArray<DHTaskModel *> *)unarchivedTaskArray {
    NSString *file = [self file];
    NSSet *classes = [self suppportUnarchivedClasses];
    NSObject *result;
    DHERROR_CODE ret = [DHArchiver unarchivedObjectOfClasses:classes
                                                    withFile:file
                                            unarchivedObject:&result];
    DHLogDebug(@"Unarchive task list result: %zd\n\
[fromPath: %@]", ret, file);
    if (ret != DHERROR_NO_ERROR) { return nil; }
    return (NSArray *)result;
}

// 可解档类
+ (NSSet *)suppportUnarchivedClasses {
    // !!!: 注意：一旦DHTaskModel子类或者本类存在新的类型，则都需要在此添加，否则会解档失败
    return [NSSet setWithArray:@[
        NSArray.class,
        NSDictionary.class,
        DHTaskModel.class,
        DHWorkspaceModel.class,
        DHProjectModel.class,
        DHTargetModel.class,
        DHProfileModel.class,
        DHPodModel.class,
        DHArchiveModel.class,
        DHGitModel.class,
        DHDistributionModel.class,
        DHBuildConfigurationModel.class,
        DHDistributionFirModel.class,
        DHDistributionPgyerModel.class,
        DHAppModel.class,
        DHIPAModel.class,
        DHDistributer.class
    ]];
}

+ (NSString *)boxDocumentDirectory {
    return [DHCommonTools systemAppCachesDirectory];
//    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)filename {
    return @"tasks.archive";
}

+ (NSString *)file {
    return [[self boxDocumentDirectory] stringByAppendingPathComponent:[self filename]];
}

@end
