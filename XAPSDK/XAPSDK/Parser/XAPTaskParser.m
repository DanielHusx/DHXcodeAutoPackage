//
//  XAPTaskParser.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/10.
//

#import "XAPTaskParser.h"
#import "XAPTaskModel.h"
#import "XAPEngineerParser.h"
#import "XAPEngineerModel.h"
#import "XAPConfigurationParser.h"
#import "XAPConfigurationModel.h"

@interface XAPTaskParser ()

/// 工程解析器
@property (nonatomic, strong) XAPEngineerParser *engineerParser;
/// 配置解析器
@property (nonatomic, strong) XAPConfigurationParser *configurationParser;

@end

@implementation XAPTaskParser

+ (instancetype)sharedParser {
    static XAPTaskParser *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XAPTaskParser alloc] init];
    });
    return _instance;
}


#pragma mark - 解析
- (XAPTaskModel *)parse:(NSString *)path
                  error:(NSError *__autoreleasing  _Nullable *)error {
    // 解析工程信息
    XAPEngineerModel *engineerInfo = [self.engineerParser parseEngineerWithPath:path error:error];
    if (![engineerInfo isKindOfClass:[XAPEngineerModel class]]) {
        return nil;
    }
    // 配置对应配置
    XAPConfigurationModel *configuration = [self.configurationParser parseConfigurationWithEngineerInfo:engineerInfo error:error];
    
    XAPTaskModel *task = [[XAPTaskModel alloc] init];
    task.path = path;
    task.engineer = engineerInfo;
    task.configuration = configuration;
    
    return task;
}


#pragma mark - getter
- (XAPEngineerParser *)engineerParser {
    if (!_engineerParser) {
        _engineerParser = [XAPEngineerParser sharedParser];
    }
    return _engineerParser;
}

- (XAPConfigurationParser *)configurationParser {
    if (!_configurationParser) {
        _configurationParser = [XAPConfigurationParser sharedParser];
    }
    return _configurationParser;
}

@end
