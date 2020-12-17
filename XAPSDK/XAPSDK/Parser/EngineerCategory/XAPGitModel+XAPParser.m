//
//  XAPGitModel+XAPParser.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPGitModel+XAPParser.h"
#import <objc/runtime.h>

@implementation XAPGitModel (XAPParser)

- (id<XAPChainOfResponsibilityProtocol>)nextHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNextHandler:(id<XAPChainOfResponsibilityProtocol>)nextHandler {
    objc_setAssociatedObject(self, @selector(nextHandler), nextHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XAPEngineerModel *)handlePath:(NSString *)path {
    if (![XAPTools isGitFile:path]) {
        return [self.nextHandler handlePath:path];
    }
    return nil;
}

@end
