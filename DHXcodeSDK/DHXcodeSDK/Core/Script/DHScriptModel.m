//
//  DHScriptModel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/17.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHScriptModel.h"

@implementation DHScriptModel

- (NSString *)description {
    return [NSString stringWithFormat:@"Scriptcommand:\n\
[asAdministrator: %@] [shellCommand: %@ %@]",
            self.isAsAdministrator?@"YES":@"NO",
            self.scriptCommand,
            self.scriptComponent?[self.scriptComponent componentsJoinedByString:@" "]:@""];
}

@end
