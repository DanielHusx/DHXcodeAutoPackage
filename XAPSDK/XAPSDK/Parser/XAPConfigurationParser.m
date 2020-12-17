//
//  XAPConfigurationParser.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPConfigurationParser.h"

@implementation XAPConfigurationParser

+ (instancetype)sharedParser {
    XAPConfigurationParser *instance = [[XAPConfigurationParser alloc] init];
    return instance;
}

- (XAPConfigurationModel *)parseConfigurationWithEngineerInfo:(XAPEngineerModel *)engineerInfo
                                                        error:(NSError *__autoreleasing  _Nullable *)error {
    return nil;
}
@end
