//
//  DHZIPTools.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHZIPTools.h"
#import "SSZipArchive.h"

@interface DHZIPTools () <SSZipArchiveDelegate>
/// 解压路径
@property (nonatomic, copy) NSString *unzippedPath;

@end

@implementation DHZIPTools

+ (instancetype)zip {
    static DHZIPTools *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DHZIPTools alloc] init];
    });
    return _instance;
}

/// 解压缩
+ (DHERROR_CODE)unzipFileAtPath:(NSString *)path
                  toDestination:(NSString *)destination
                   unzippedPath:(NSString * _Nullable __autoreleasing * _Nullable)unzippedPath
                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    DHZIPTools *handler = [DHZIPTools zip];
    handler.unzippedPath = nil;
    
    BOOL ret = [SSZipArchive unzipFileAtPath:path
                               toDestination:destination
                                   overwrite:YES
                                    password:nil
                                       error:error
                                    delegate:handler];
    // 理论上代理会比return回来的早
    if (unzippedPath) { *unzippedPath = handler.unzippedPath; }
    
    return ret?DHERROR_NO_ERROR:DHERROR_UNZIP_FAILED;
}

/// 压缩
+ (DHERROR_CODE)createZipFileAtPath:(NSString *)path
            withContentsOfDirectory:(NSString *)directory {
    BOOL ret = [SSZipArchive createZipFileAtPath:path
                         withContentsOfDirectory:directory];
    return ret?DHERROR_NO_ERROR:DHERROR_ZIP_FAILED;
}


#pragma mark - SSZipArchiveDelegate
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path
                                zipInfo:(unz_global_info)zipInfo
                           unzippedPath:(NSString *)unzippedPath {
    self.unzippedPath = unzippedPath;
}
@end
