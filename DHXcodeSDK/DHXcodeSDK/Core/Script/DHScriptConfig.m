//
//  DHScriptConfig.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/17.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHScriptConfig.h"
#import "DHScriptExecutor.h"
#import "DHScriptFactory.h"

/**
总体逻辑：当不存在某个脚本路径属性值时，执行which命令得到脚本路径 后 保存到属性
*/
@interface DHScriptConfig ()

/// xcode构建 命令路径， 默认：/usr/bin/xcodebuild
@property (nonatomic, copy) NSString *xcodebuild;
/// security解析证书 命令路径，默认：/usr/bin/security
@property (nonatomic, copy) NSString *security;
/// lipo解析二进制文件命令路径，默认：/usr/bin/lipo
@property (nonatomic, copy) NSString *lipo;
/// plist读写命令路径，默认：/usr/libexec/PlistBuddy
@property (nonatomic, copy) NSString *plistbuddy;
/// 签名命令路径，默认：/usr/bin/codesign
@property (nonatomic, copy) NSString *codesign;
/// git版本管理命令路径，默认：/usr/local/bin/git
@property (nonatomic, copy) NSString *git;
/// cocoapods仓库管理命令路径，默认：/usr/local/bin/pod
@property (nonatomic, copy) NSString *pod;
/// ruby命令，默认：/usr/local/bin/ruby
@property (nonatomic, copy) NSString *ruby;
/// otool命令，默认：/usr/bin/otool
@property (nonatomic, copy) NSString *otool;
/// which命令，默认：/usr/bin/which
@property (nonatomic, copy) NSString *which;

@end

@implementation DHScriptConfig

+ (instancetype)configuation {
    static DHScriptConfig *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DHScriptConfig alloc] init];
    });
    return _instance;
}

/// bash交互登录shell执行环境变量
/// 将bash作为交互式登录shell调用时,/etc/paths 和/etc/paths.d/* 中的路径是由/usr/libexec /path_helper添加到PATH
/// 该路径从/etc/profile运行. do shell脚本以sh和非交互非登录shell(不读取/etc/profile)的形式调用bash.
/// 参考资料：http://www.cocoachina.com/cms/wap.php?action=article&id=105930
- (NSString *)bashInactionLoginEnvirmentPath {
    return @"eval `/usr/libexec/path_helper -s`;";
}

- (NSString *)plistbuddy {
    return @"/usr/libexec/PlistBuddy";
}

- (NSString *)which {
    return @"/usr/bin/which";
}


+ (BOOL)fetchXcodebuildScript:(NSString * _Nonnull __autoreleasing *)script
                        error:(NSError * _Nullable __autoreleasing *)error
              asAdministrator:(BOOL *)asAdministrator {
    if (asAdministrator) { *asAdministrator = NO; }
    
    DHScriptConfig *config = [DHScriptConfig configuation];
    if (config.xcodebuild) {
        if (script) { *script = config.xcodebuild; }
        return YES;
    }
    
    NSString *output = nil;
    DHScriptModel *command = [DHScriptFactory fetchXcodebuildScriptCommand];
    BOOL ret = [DHScriptExecutor executeCommand:command
                                         output:&output
                                          error:error];
    if (output) {
        config.xcodebuild = output;
        if (script) { *script = config.xcodebuild; }
    }
    return ret;
}

+ (BOOL)fetchSecurityScript:(NSString * _Nonnull __autoreleasing *)script
                      error:(NSError * _Nullable __autoreleasing *)error
            asAdministrator:(BOOL *)asAdministrator {
    DHScriptConfig *config = [DHScriptConfig configuation];
    if (config.security) {
        if (script) { *script = config.security; }
        return YES;
    }
    
    NSString *output = nil;
    DHScriptModel *command = [DHScriptFactory fetchSecurityScriptCommand];
    BOOL ret = [DHScriptExecutor executeCommand:command
                                         output:&output
                                          error:error];
    if (output) {
        config.security = output;
        if (script) { *script = config.security; }
    }
    return ret;
}

+ (BOOL)fetchLipoScript:(NSString * _Nonnull __autoreleasing *)script
                  error:(NSError * _Nullable __autoreleasing *)error
        asAdministrator:(BOOL *)asAdministrator {
    if (asAdministrator) { *asAdministrator = NO; }
    
    DHScriptConfig *config = [DHScriptConfig configuation];
    if (config.lipo) {
        if (script) { *script = config.lipo; }
        return YES;
    }
    
    NSString *output = nil;
    DHScriptModel *command = [DHScriptFactory fetchLipoScriptCommand];
    BOOL ret = [DHScriptExecutor executeCommand:command
                                         output:&output
                                          error:error];
    if (output) {
        config.lipo = output;
        if (script) { *script = config.lipo; }
    }
    return ret;
}

+ (BOOL)fetchPlistbuddyScript:(NSString * _Nonnull __autoreleasing *)script
                        error:(NSError * _Nullable __autoreleasing *)error
              asAdministrator:(BOOL *)asAdministrator {
    if (asAdministrator) { *asAdministrator = NO; }
    if (!script) { return NO; }
    
    *script = [DHScriptConfig configuation].plistbuddy;
    return YES;
}

+ (BOOL)fetchCodesignScript:(NSString * _Nonnull __autoreleasing *)script
                      error:(NSError * _Nullable __autoreleasing *)error
            asAdministrator:(BOOL *)asAdministrator {
    if (asAdministrator) { *asAdministrator = NO; }
    
    DHScriptConfig *config = [DHScriptConfig configuation];
    if (config.codesign) {
        if (script) { *script = config.codesign; }
        return YES;
    }
    
    NSString *output = nil;
    DHScriptModel *command = [DHScriptFactory fetchCodesignScriptCommand];
    BOOL ret = [DHScriptExecutor executeCommand:command
                                         output:&output
                                          error:error];
    if (output) {
        config.codesign = output;
        if (script) { *script = config.codesign; }
    }
    return ret;
}

+ (BOOL)fetchRubyScript:(NSString * _Nonnull __autoreleasing *)script
                  error:(NSError * _Nullable __autoreleasing *)error
        asAdministrator:(BOOL *)asAdministrator {
    if (asAdministrator) { *asAdministrator = NO; }
    
    DHScriptConfig *config = [DHScriptConfig configuation];
    if (config.ruby) {
        if (script) { *script = config.ruby; }
        return YES;
    }
    
    NSString *output = nil;
    DHScriptModel *command = [DHScriptFactory fetchRubyScriptCommand];
    BOOL ret = [DHScriptExecutor executeCommand:command
                                         output:&output
                                          error:error];
    if (output) {
        config.ruby = output;
        if (script) { *script = config.ruby; }
    }
    return ret;
}

+ (BOOL)fetchGitScript:(NSString * _Nonnull __autoreleasing *)script
                  error:(NSError * _Nullable __autoreleasing *)error
        asAdministrator:(BOOL *)asAdministrator {
    if (asAdministrator) { *asAdministrator = NO; }
    
    DHScriptConfig *config = [DHScriptConfig configuation];
    if (config.git) {
        if (script) { *script = config.git; }
        return YES;
    }
    
    NSString *output = nil;
    DHScriptModel *command = [DHScriptFactory fetchGitScriptCommand];
    BOOL ret = [DHScriptExecutor executeCommand:command
                                         output:&output
                                          error:error];
    if (output) {
        config.git = output;
        if (script) { *script = config.git; }
    }
    return ret;
}

+ (BOOL)fetchPodScript:(NSString * _Nonnull __autoreleasing *)script
                  error:(NSError * _Nullable __autoreleasing *)error
        asAdministrator:(BOOL *)asAdministrator {
    if (asAdministrator) { *asAdministrator = NO; }
    if (!script) { return NO; }

    DHScriptConfig *config = [DHScriptConfig configuation];
    if (config.pod) {
        if (script) { *script = config.pod; }
        return YES;
    }

    NSString *output = nil;
    DHScriptModel *command = [DHScriptFactory fetchPodScriptCommand];
    BOOL ret = [DHScriptExecutor executeCommand:command
                                         output:&output
                                          error:error];
    if (output) {
        config.pod = [@"export LANG=en_US.UTF-8;" stringByAppendingString:output];
        if (script) { *script = config.pod; }
    }
    return ret;
}

+ (BOOL)fetchOtoolScript:(NSString * _Nonnull __autoreleasing *)script
                    error:(NSError * _Nullable __autoreleasing *)error
          asAdministrator:(BOOL *)asAdministrator {
    if (asAdministrator) { *asAdministrator = NO; }
    
    DHScriptConfig *config = [DHScriptConfig configuation];
    if (config.otool) {
        if (script) { *script = config.otool; }
        return YES;
    }
    
    NSString *output = nil;
    DHScriptModel *command = [DHScriptFactory fetchOtoolScriptCommand];
    BOOL ret = [DHScriptExecutor executeCommand:command
                                         output:&output
                                          error:error];
    if (output) {
        config.otool = output;
        if (script) { *script = config.otool; }
    }
    return ret;
}

+ (BOOL)fetchWhichScript:(NSString * _Nonnull __autoreleasing *)script
                   error:(NSError * _Nullable __autoreleasing *)error
         asAdministrator:(BOOL *)asAdministrator {
    if (asAdministrator) { *asAdministrator = NO; }
    
    DHScriptConfig *config = [DHScriptConfig configuation];
    
    if (script) { *script = config.which; }
    return YES;

}

@end
