//
//  XAPScriptPathManager.m
//  XAPSDK
//
//  Created by Daniel on 2020/11/30.
//

#import "XAPScriptPathManager.h"
#import "XAPScriptExecutor.h"
#import "XAPScriptModel.h"

XAPScriptPathKey const kXAPScriptPathKeyXcodebuild = @"xcodebuild";
XAPScriptPathKey const kXAPScriptPathKeySecurity = @"security";
XAPScriptPathKey const kXAPScriptPathKeyLipo = @"lipo";
XAPScriptPathKey const kXAPScriptPathKeyPlistbuddy = @"plistbuddy";
XAPScriptPathKey const kXAPScriptPathKeyCodesign = @"codesign";
XAPScriptPathKey const kXAPScriptPathKeyRuby  = @"ruby";
XAPScriptPathKey const kXAPScriptPathKeyGit = @"git";
XAPScriptPathKey const kXAPScriptPathKeyOtool = @"otool";
XAPScriptPathKey const kXAPScriptPathKeyPod = @"pod";
XAPScriptPathKey const kXAPScriptPathKeyWhich = @"which";
XAPScriptPathKey const kXAPScriptPathKeyXcrun = @"xcrun";
XAPScriptPathKey const kXAPScriptPathKeyRM = @"rm";
XAPScriptPathKey const kXAPScriptPathKeyUnzip = @"unzip";
/**
总体逻辑：当不存在某个脚本路径属性值时，执行which命令得到脚本路径 后 保存到属性
*/
@interface XAPScriptPathManager ()

/// 缓存的命令路径
@property (nonatomic, strong) NSMutableDictionary *scriptPathPool;
/// 缓存获取命令
@property (nonatomic, strong) NSMutableDictionary *scriptPool;

@end

@implementation XAPScriptPathManager

+ (instancetype)manager {
    static XAPScriptPathManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XAPScriptPathManager alloc] init];
    });
    return _instance;
}


#pragma mark - public method
- (NSString *)scriptPathForKey:(XAPScriptPathKey)key {
    NSString *scriptPath = [self.scriptPathPool objectForKey:key];
    
    // 已缓存的脚本路径
    if (scriptPath) { return scriptPath; }
    
    // 未缓存，当存在配置缓存命令时，则
    if ([self.scriptPool objectForKey:key]) {
        
        NSError *error;
        XAPScriptModel *command = [self.scriptPool objectForKey:key];
        scriptPath = [[XAPScriptExecutor sharedExecutor] execute:command
                                                           error:&error];
        if (error || !scriptPath) { return nil; }
        
        if ([key isEqualToString:kXAPScriptPathKeyPod]) {
            scriptPath = [[self exportEnglishEnvirmentPath] stringByAppendingString:scriptPath];
        }
        
        [self.scriptPathPool setObject:scriptPath forKey:key];
    }
    
    return scriptPath;
}


#pragma mark - getter
- (NSMutableDictionary *)scriptPathPool {
    if (!_scriptPathPool) {
        _scriptPathPool = [NSMutableDictionary dictionary];
        
        [_scriptPathPool setObject:[self which] forKey:kXAPScriptPathKeyWhich];
        [_scriptPathPool setObject:[self plistbuddy] forKey:kXAPScriptPathKeyPlistbuddy];
    }
    return _scriptPathPool;
}

- (NSMutableDictionary *)scriptPool {
    if (!_scriptPool) {
        _scriptPool = [NSMutableDictionary dictionary];
        
        [_scriptPool setObject:[self fetchXcodebuildScriptCommand] forKey:kXAPScriptPathKeyXcodebuild];
        [_scriptPool setObject:[self fetchSecurityScriptCommand] forKey:kXAPScriptPathKeySecurity];
        [_scriptPool setObject:[self fetchLipoScriptCommand] forKey:kXAPScriptPathKeyLipo];
        
        [_scriptPool setObject:[self fetchCodesignScriptCommand] forKey:kXAPScriptPathKeyCodesign];
        [_scriptPool setObject:[self fetchRubyScriptCommand] forKey:kXAPScriptPathKeyRuby ];
        [_scriptPool setObject:[self fetchGitScriptCommand] forKey:kXAPScriptPathKeyGit];
        [_scriptPool setObject:[self fetchOtoolScriptCommand] forKey:kXAPScriptPathKeyOtool];
        [_scriptPool setObject:[self fetchPodScriptCommand] forKey:kXAPScriptPathKeyPod];
        
        [_scriptPool setObject:[self fetchXcrunScriptCommand] forKey:kXAPScriptPathKeyXcrun];
        [_scriptPool setObject:[self fetchRmScriptCommand] forKey:kXAPScriptPathKeyRM];
        [_scriptPool setObject:[self fetchUnzipScriptCommand] forKey:kXAPScriptPathKeyUnzip];
    }
    return _scriptPool;
}

/// bash交互登录shell执行环境变量
/// 将bash作为交互式登录shell调用时,/etc/paths 和/etc/paths.d/* 中的路径是由/usr/libexec /path_helper添加到PATH
/// 该路径从/etc/profile运行. do shell脚本以sh和非交互非登录shell(不读取/etc/profile)的形式调用bash.
/// 参考资料：http://www.cocoachina.com/cms/wap.php?action=article&id=105930
- (NSString *)bashInactionLoginEnvirmentPath {
    return @"eval `/usr/libexec/path_helper -s`;";
}

- (NSString *)exportEnglishEnvirmentPath {
    return @"export LANG=en_US.UTF-8;";
}

- (NSString *)plistbuddy {
    return @"/usr/libexec/PlistBuddy";
}

- (NSString *)which {
    return @"/usr/bin/which";
}


#pragma mark - command
- (XAPScriptModel *)whichScriptModel {
    XAPScriptModel *command = [[XAPScriptModel alloc] init];
    command.scriptPath = [self scriptPathForKey:kXAPScriptPathKeyWhich];
    return command;
}

- (XAPScriptModel *)fetchGitScriptCommand {
    XAPScriptModel *model = [self whichScriptModel];
    model.scriptArguments = @[@"git"];
    return model;
}

- (XAPScriptModel *)fetchXcodebuildScriptCommand {
    XAPScriptModel *model = [self whichScriptModel];
    model.scriptArguments = @[@"xcodebuild"];
    return model;
}

- (XAPScriptModel *)fetchOtoolScriptCommand {
    XAPScriptModel *model = [self whichScriptModel];
    model.scriptArguments = @[@"otool"];
    return model;
}

- (XAPScriptModel *)fetchSecurityScriptCommand {
    XAPScriptModel *model = [self whichScriptModel];
    model.scriptArguments = @[@"security"];
    return model;
}

- (XAPScriptModel *)fetchLipoScriptCommand {
    XAPScriptModel *model = [self whichScriptModel];
    model.scriptArguments = @[@"lipo"];
    return model;
}

- (XAPScriptModel *)fetchCodesignScriptCommand {
    XAPScriptModel *model = [self whichScriptModel];
    model.scriptArguments = @[@"codesign"];
    return model;
}

- (XAPScriptModel *)fetchXcrunScriptCommand {
    XAPScriptModel *model = [self whichScriptModel];
    model.scriptArguments = @[@"xcrun"];
    return model;
}

- (XAPScriptModel *)fetchRmScriptCommand {
    XAPScriptModel *model = [self whichScriptModel];
    model.scriptArguments = @[@"rm"];
    return model;
}

- (XAPScriptModel *)fetchUnzipScriptCommand {
    XAPScriptModel *model = [self whichScriptModel];
    model.scriptArguments = @[@"unzip"];
    return model;
}

- (XAPScriptModel *)fetchPodScriptCommand {
    XAPScriptModel *model = [[XAPScriptModel alloc] init];
    // 由于内置中断的环境变量问题（/bin/sh)，无法直接通过which pod得到正确的路径
    // 或者可以说此情况下，无法通过which得到mac内置脚本以外的脚本路径
    model.scriptPath = [self bashInactionLoginEnvirmentPath];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"which"];
    [component addObject:@"pod"];
    model.scriptArguments = [component copy];
    
    return model;
}

- (XAPScriptModel *)fetchRubyScriptCommand {
    XAPScriptModel *model = [[XAPScriptModel alloc] init];
    model.scriptPath = [self bashInactionLoginEnvirmentPath];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"which"];
    [component addObject:@"ruby"];
    model.scriptArguments = [component copy];
    
    return model;
}

@end
