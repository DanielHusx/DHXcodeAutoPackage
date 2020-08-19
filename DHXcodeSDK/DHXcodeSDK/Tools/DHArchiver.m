//
//  DHArchiver.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHArchiver.h"

@implementation DHArchiver

// 序列化该类的对象
+ (DHERROR_CODE)archiveObject:(NSObject *)object withFile:(NSString *)file {
    if (!object) { return DHERROR_ARCHIVE_PARAMETER_INVALID; }
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object
                                         requiringSecureCoding:YES
                                                         error:&error];
    if (error) { return DHERROR_ARCHIVE_FAILED; }
    
    BOOL ret = [data writeToFile:file atomically:YES];
    
    return ret?DHERROR_NO_ERROR:DHERROR_ARCHIVE_FILE_WRITE_FAILED;
}

// 反序列化该类的对象
+ (DHERROR_CODE)unarchivedObjectOfClasses:(NSSet *)classes
                                 withFile:(NSString *)file
                         unarchivedObject:(NSObject **)unarchivedObject {
    if (![file isKindOfClass:[NSString class]]) { return DHERROR_UNARCHIVE_PARAMETER_INVALID; }
    BOOL isDir = NO;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:file
                                                       isDirectory:&isDir];
    // 是目录 或者 文件不存在
    if (isDir || !result) { return DHERROR_UNARCHIVE_FILE_NOT_EXIST; }
    
    NSData *oldData = [NSData dataWithContentsOfFile:file];
    NSError *error;
    NSObject *obj = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes
                                                        fromData:oldData
                                                           error:&error];
    if (error) { return DHERROR_UNARCHIVE_FAILED; }
    
    *unarchivedObject = obj;
    return DHERROR_NO_ERROR;
}

@end
