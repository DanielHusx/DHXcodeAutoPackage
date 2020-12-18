//
//  XAPArchiveModel+XAPParser.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPArchiveModel+XAPParser.h"
#import <objc/runtime.h>
#import "XAPAppModel.h"
#import "XAPInfoPlistModel.h"
#import "XAPInfoPlistTools.h"
#import "XAPProvisioningProfileManager.h"
#import "XAPEngineerModel.h"

@implementation XAPArchiveModel (XAPParser)

- (id<XAPChainOfResponsibilityProtocol>)nextHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNextHandler:(id<XAPChainOfResponsibilityProtocol>)nextHandler {
    objc_setAssociatedObject(self, @selector(nextHandler), nextHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XAPEngineerModel *)handlePath:(NSString *)path error:(NSError * __autoreleasing _Nullable * _Nullable)error {
    if (![XAPTools isXcarchiveFile:path]) {
        return [self.nextHandler handlePath:path error:error];
    }
    
    XAPEngineerModel *engineer = [self parseEngineerWithXcarchiveFile:path];
    return engineer;
}


#pragma mark - parser method
- (XAPEngineerModel *)parseEngineerWithXcarchiveFile:(NSString *)xcarchiverFile {
    XAPArchiveModel *archive = [self parseArchiveWithXcarchiveFile:path];
    if (!archive) {
        return nil;
    }
    
    XAPEngineerModel *engineer = [[XAPEngineerModel alloc] init];
    engineer.archive = archive;
    return engineer;
}

- (XAPArchiveModel *)parseArchiveWithXcarchiveFile:(NSString *)xcarchiveFile {
    if (![XAPTools isXcarchiveFile:xcarchiveFile]) {
        return nil;
    }
    
    NSString *appFile = [XAPTools appFileWithXcarchiveFile:xcarchiveFile];
    
    XAPArchiveModel *archiver = [[XAPArchiveModel alloc] init];
    archiver.xcarchiveFilePath = xcarchiveFile;
    archiver.infoPlist = [self infoPlistModelWithXcarchiveFilePath:xcarchiveFile];
    archiver.app = [self parseAppWithAppFile:appFile];
    return archiver;
}

- (XAPInfoPlistModel *)infoPlistModelWithXcarchiveFilePath:(NSString *)xcarchiveFilePath {
    XAPInfoPlistModel *infoPlistModel = [[XAPInfoPlistModel alloc] init];
    NSString *infoPlistFile = [XAPTools infoPlistFileWithXcarchiveFile:xcarchiveFilePath];
    NSString *schemeName;
    NSString *bundleIdentifier;
    NSString *version;
    NSString *shortVersion;
    [XAPInfoPlistTools parseXcarchiveInfoPlistWithPlistFileOrDictionary:infoPlistFile name:nil
                                                             schemeName:&schemeName
                                                           creationDate:nil
                                                        applicationPath:nil
                                                       bundleIdentifier:&bundleIdentifier
                                                         teamIdentifier:nil
                                                           shortVersion:&shortVersion
                                                                version:&version
                                                          architectures:nil
                                                        signingIdentity:nil];
    infoPlistModel.bundleIdentifier = bundleIdentifier;
    infoPlistModel.bundleName = schemeName;
    infoPlistModel.bundleVersion = version;
    infoPlistModel.bundleShortVersion = shortVersion;
    return infoPlistModel;
}

- (XAPAppModel *)parseAppWithAppFile:(NSString *)appFile {
    if (![XAPTools isAppFile:appFile]) {
        return nil;
    }
    XAPAppModel *app = [[XAPAppModel alloc] init];
    app.appFilePath = appFile;
    app.infoPlist = [self infoPlistModelWithAppFilePath:appFile];
    NSString *embeddedProvisionFile = [XAPTools embeddedProvisionFileWithAppFile:appFile];
    app.embeddedProfile = [[XAPProvisioningProfileManager manager] fetchProvisioningProfilesWithPath:embeddedProvisionFile];
    return app;
}

- (XAPInfoPlistModel *)infoPlistModelWithAppFilePath:(NSString *)appFilePath {
    XAPInfoPlistModel *infoPlistModel = [[XAPInfoPlistModel alloc] init];
    NSString *infoPlistPath = [XAPTools infoPlistFileWithAppFile:appFilePath];
    NSString *displayName;
    NSString *productName;
    NSString *bundleIdentifier;
    NSString *version;
    NSString *shortVersion;
    NSString *executableFile;
    [XAPInfoPlistTools parseProjectOrAppInfoPlistFileWithPlistFileOrDictionary:infoPlistPath
                                                                   displayName:&displayName
                                                                   productName:&productName
                                                              bundleIdentifier:&bundleIdentifier
                                                                  shortVersion:&shortVersion
                                                                       version:&version
                                                                executableFile:&executableFile];
    infoPlistModel.bundleIdentifier = bundleIdentifier;
    infoPlistModel.bundleName = productName;
    infoPlistModel.bundleDisplayName = displayName;
    infoPlistModel.bundleVersion = version;
    infoPlistModel.bundleShortVersion = shortVersion;
    infoPlistModel.executableFile = executableFile;
    return infoPlistModel;
}


@end
