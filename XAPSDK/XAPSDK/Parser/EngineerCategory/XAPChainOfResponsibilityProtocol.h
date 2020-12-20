//
//  XAPChainOfResponsibilityProtocol.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 责任链
 */
@protocol XAPChainOfResponsibilityProtocol <NSObject>

/// 下一个责任人
@property (nonatomic, strong) id <XAPChainOfResponsibilityProtocol> nextHandler;

/// 接收处理信息
///
/// @param path 路径
/// @param externalInfo 扩展信息，参考XAPChainOfResponsibilityExternalKey
/// @param error [out] 错误信息
- (id)handlePath:(NSString *)path externalInfo:(NSDictionary * _Nullable)externalInfo error:(NSError * __autoreleasing _Nullable * _Nullable)error;

@end


typedef NSString * XAPChainOfResponsibilityExternalKey;
/// git路径或解析后的git信息
static XAPChainOfResponsibilityExternalKey kXAPChainOfResponsibilityExternalKeyGit = @"kXAPChainOfResponsibilityExternalKeyGit";
/// pod路径或解析后的pod信息
static XAPChainOfResponsibilityExternalKey kXAPChainOfResponsibilityExternalKeyPod = @"kXAPChainOfResponsibilityExternalKeyPod";

NS_ASSUME_NONNULL_END
