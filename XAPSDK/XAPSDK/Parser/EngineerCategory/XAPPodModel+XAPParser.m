//
//  XAPPodModel+XAPParser.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPPodModel+XAPParser.h"
#import <objc/runtime.h>

@implementation XAPPodModel (XAPParser)

- (id<XAPChainOfResponsibilityProtocol>)nextHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNextHandler:(id<XAPChainOfResponsibilityProtocol>)nextHandler {
    objc_setAssociatedObject(self, @selector(nextHandler), nextHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)handlePath:(NSString *)path externalInfo:(NSDictionary *)externalInfo error:(NSError *__autoreleasing  _Nullable *)error {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:externalInfo];
    if (externalInfo) {
        id podInfo = externalInfo[kXAPChainOfResponsibilityExternalKeyPod];
        // 如果podInfo为字符串则是Podfile的路径；如果是此类，则是已经解析的pod信息；其他情况，搞错信息，则移除校正
        if ([podInfo isKindOfClass:[NSString class]]) {
            if (![XAPTools isPodfileFile:path]) {
                // TODO: 暴露路径错误信息
                [result removeObjectForKey:kXAPChainOfResponsibilityExternalKeyPod];
            } else {
                // 解析
                XAPPodModel *pod = [self parsePodWithPodFile:podInfo];
                [result setValue:pod forKey:kXAPChainOfResponsibilityExternalKeyPod];
            }
        } else if (![podInfo isKindOfClass:[self class]]) {
            // 未知错误信息被赋值，移除
            [result removeObjectForKey:kXAPChainOfResponsibilityExternalKeyPod];
        }
    }
    return [self.nextHandler handlePath:path externalInfo:result error:error];
}

#pragma mark - parse method
- (XAPPodModel *)parsePodWithPodFile:(NSString *)podFile {
    if (![XAPTools isPodfileFile:podFile]) {
        return nil;
    }
    XAPPodModel *podModel = [[XAPPodModel alloc] init];
    podModel.podfileFilePath = podFile;
    return podModel;
}

@end
