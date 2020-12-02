//
//  XAPZipTools.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/2.
//

#import "XAPZipTools.h"
#import "ZipArchive.h"

@interface XAPZipTools () <SSZipArchiveDelegate>

/// 解压路径
@property (nonatomic, copy) NSString *unzippedPath;

@end

@implementation XAPZipTools


+ (instancetype)sharedInstance {
    static XAPZipTools *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XAPZipTools alloc] init];
    });
    return _instance;
}

+ (NSString * _Nullable)unzipIPAFile:(NSString *)ipaFile {
    NSString *ipaDirectory = [ipaFile stringByDeletingPathExtension];
    NSString *unzippedPath = [self unzipIPAFile:ipaFile
                                  toDestination:ipaDirectory];
    return unzippedPath;
}

+ (NSString * _Nullable)unzipIPAFile:(NSString *)ipaFile
                       toDestination:(NSString *)destination {
    // 解压
    NSString *unzipPath;
    NSError *error;
    BOOL ret = [self unzipFileAtPath:ipaFile
                       toDestination:destination
                        unzippedPath:&unzipPath
                               error:&error];

    if (!ret && error) { return nil; }

    return unzipPath;
}


/// 解压缩
+ (BOOL)unzipFileAtPath:(NSString *)path
          toDestination:(NSString *)destination
           unzippedPath:(NSString * _Nullable __autoreleasing * _Nullable)unzippedPath
                  error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPZipTools *handler = [XAPZipTools sharedInstance];
    handler.unzippedPath = nil;
    
    BOOL ret = [SSZipArchive unzipFileAtPath:path
                               toDestination:destination
                                   overwrite:YES
                                    password:nil
                                       error:error
                                    delegate:handler];
    // 理论上代理会比return回来的早
    if (unzippedPath) { *unzippedPath = handler.unzippedPath; }
    
    return ret;
}

/// 压缩
+ (BOOL)createZipFileAtPath:(NSString *)path
    withContentsOfDirectory:(NSString *)directory {
    BOOL ret = [SSZipArchive createZipFileAtPath:path
                         withContentsOfDirectory:directory];
    return ret;
}


#pragma mark - SSZipArchiveDelegate
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path
                                zipInfo:(unz_global_info)zipInfo
                           unzippedPath:(NSString *)unzippedPath {
    self.unzippedPath = unzippedPath;
}

@end
