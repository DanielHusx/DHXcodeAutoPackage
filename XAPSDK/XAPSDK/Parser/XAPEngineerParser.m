//
//  XAPEngineerParser.m
//  XAPSDK
//
//  Created by 菲凡数据 on 2020/12/10.
//

#import "XAPEngineerParser.h"

@implementation XAPEngineerParser

+ (instancetype)sharedParser {
    static XAPEngineerParser *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XAPEngineerParser alloc] init];
    });
    return _instance;
}

- (XAPWorkspaceModel *)parseWorkspaceWithXcworkspaceFile:(NSString *)xcworkspaceFile {
    if (![XAPTools isXcworkspaceFile:xcworkspaceFile]) {
        return nil;
    }
    
    // 关联工程
    NSArray *relateXcodeprojFiles = [XAPTools xcodeprojFilesWithWorkspaceFile:xcworkspaceFile];
    if (![XAPTools isValidArray:relateXcodeprojFiles]) {
        return nil;
    }
    
    
}

- (XAPProjectModel *)parseProjectWithXcodeprojFile:(NSString *)xcodeprojFile {
    if (![XAPTools isXcodeprojFile:xcodeprojFile]) {
        return nil;
    }
    
    NSString *pbxprojFile = [XAPTools pbxprojFileWithXcodeprojFile:xcodeprojFile];
    NSData *pbxprojData = [NSData dataWithContentsOfFile:pbxprojFile];
    NSError *error;
    NSDictionary *pbxprojDictionary = [NSPropertyListSerialization propertyListWithData:pbxprojData options:NSPropertyListMutableContainersAndLeaves format:nil error:&error];
    if (error) {
        return nil;
    }
    
    NSString *rootObject = pbxprojDictionary[@"rootObject"];
    NSDictionary *projectDictionary = pbxprojDictionary[rootObject];
    
    NSString *projectBuildConfigurationListId = projectDictionary[@"buildConfigurationList"];
    NSArray *targetIds = projectDictionary[@"targets"];
    
    for (NSString *targetId in targetIds) {
        NSDictionary *targetDictionary = projectDictionary[targetId];
        NSString *targetBuildConfigurationListId = targetDictionary[@"buildConfigurationList"];
        NSString *name = targetDictionary[@"name"];
        
        NSDictionary *projectDictionary
    }
}

@end
