//
//  XAPIPAModel+XAPParser.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPIPAModel+XAPParser.h"
#import <objc/runtime.h>
#import "XAPAppModel.h"
#import "XAPInfoPlistModel.h"
#import "XAPEngineerModel.h"
#import "XAPInfoPlistTools.h"
#import "XAPProvisioningProfileManager.h"

@implementation XAPIPAModel (XAPParser)

- (id<XAPChainOfResponsibilityProtocol>)nextHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNextHandler:(id<XAPChainOfResponsibilityProtocol>)nextHandler {
    objc_setAssociatedObject(self, @selector(nextHandler), nextHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XAPEngineerModel *)handlePath:(NSString *)path error:(NSError * __autoreleasing _Nullable * _Nullable)error {
    if (![XAPTools isIPAFile:path]) {
        return [self.nextHandler handlePath:path error:error];
    }
    
    XAPEngineerModel *engineer = [self parseEngineerWithIPAFile:path];
    return engineer;
}

#pragma mark - parser method
- (XAPEngineerModel *)parseEngineerWithIPAFile:(NSString *)ipaFile {
    XAPIPAModel *ipa = [self parseIPAWithIPAFile:ipaFile];
    if (!ipa) {
        return nil;
    }
    
    XAPEngineerModel *engineer = [[XAPEngineerModel alloc] init];
    engineer.ipa = ipa;
    return engineer;
}

- (XAPIPAModel *)parseIPAWithIPAFile:(NSString *)ipaFile {
    if (![XAPTools isIPAFile:ipaFile]) {
        return nil;
    }
    NSString *unzippedPath;
    NSString *appFile = [XAPTools appFileWithIPAFile:ipaFile unzippedPath:&unzippedPath];
    if (!appFile) {
        return nil;
    }
    
    XAPIPAModel *ipa = [[XAPIPAModel alloc] init];
    ipa.ipaFilePath = ipaFile;
    ipa.app = [self parseAppWithAppFile:appFile];
    return ipa;
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
