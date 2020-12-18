//
//  XAPProjectModel+XAPParser.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPProjectModel+XAPParser.h"
#import <objc/runtime.h>

@implementation XAPProjectModel (XAPParser)

- (id<XAPChainOfResponsibilityProtocol>)nextHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNextHandler:(id<XAPChainOfResponsibilityProtocol>)nextHandler {
    objc_setAssociatedObject(self, @selector(nextHandler), nextHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XAPEngineerModel *)handlePath:(NSString *)path error:(NSError * __autoreleasing _Nullable * _Nullable)error {
    if (![XAPTools isXcodeprojFile:path]) {
        return [self.nextHandler handlePath:path error:error];
    }
    return nil;
}

@end
