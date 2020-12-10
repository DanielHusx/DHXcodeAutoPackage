//
//  XAPTaskParser.m
//  XAPSDK
//
//  Created by 菲凡数据 on 2020/12/10.
//

#import "XAPTaskParser.h"
#import "XAPTaskModel.h"

@implementation XAPTaskParser

+ (instancetype)sharedParser {
    static XAPTaskParser *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XAPTaskParser alloc] init];
    });
    return _instance;
}

- (XAPTaskModel *)parse:(NSString *)path
                  error:(NSError *__autoreleasing  _Nullable *)error {
    // 判断路径是否真实存在
    if ([XAPTools isPathExist:path]) {
        return nil;
    }
    
    // 判断是否是.xcarchiver
    if ([XAPTools isXcarchiveFile:path]) {
        return nil;
    }
    
    // 判断是否是.ipa
    if ([XAPTools isIPAFile:path]) {
        return nil;
    }
    
    // 判断是否是.xcodeproj
    if ([XAPTools isXcodeprojFile:path]) {
        return nil;
    }
    
    // 判断是否是.xcworkspace
    if ([XAPTools isXcworkspaceFile:path]) {
        return nil;
    }
    
    // 判断是否是文件路径
    if ([XAPTools isFilePath:path]) {
        return nil;
    }
    
    // 解析文档路径下的文件
    NSArray *subpaths = [XAPTools absoluteSubpathsOfDirectory:path];
    __block NSString *gitFile;
    __block NSString *podFile;
    __block NSString *workspaceFile;
    __block NSString *projectFile;
    __block NSString *archiveFile;
    __block NSString *ipaFile;
    [subpaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([XAPTools isXcworkspaceFile:obj]) {
            workspaceFile = obj;
        } else if ([XAPTools isXcodeprojFile:obj]) {
            projectFile = obj;
        } else if ([XAPTools isGitFile:gitFile]) {
            gitFile = obj;
        } else if ([XAPTools isPodfileFile:obj]) {
            podFile = obj;
        } else if ([XAPTools isXcarchiveFile:obj]) {
            archiveFile = obj;
        } else if ([XAPTools isIPAFile:obj]) {
            ipaFile = obj;
        }
    }];
    
    if (gitFile) {
        
    }
    if (podFile) {
        
    }
    if (workspaceFile) {
        return nil;
    }
    if (projectFile) {
        return nil;
    }
    if (archiveFile) {
        return nil;
    }
    if (ipaFile) {
        return nil;
    }
    
    return nil;
}

@end
