//
//  XAPScriptModel.m
//  XAPSDK
//
//  Created by Daniel on 2020/11/30.
//

#import "XAPScriptModel.h"

@implementation XAPScriptModel

+ (instancetype)scriptModelWithScriptPath:(NSString *)scriptPath {
    XAPScriptModel *model = [[XAPScriptModel alloc] init];
    model.asAdministrator = NO;
    model.scriptPath = scriptPath;
    model.scriptType = XAPScriptTypeDefault;
    return model;
}

@end
