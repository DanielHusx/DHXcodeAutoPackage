//
//  XAPWorkspaceModel+XAPParser.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPWorkspaceModel.h"
#import "XAPChainOfResponsibilityProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XAPWorkspaceModel (XAPParser) <XAPChainOfResponsibilityProtocol>

/// 下一个责任人
@property (nonatomic, strong) id <XAPChainOfResponsibilityProtocol> nextHandler;
/// 接收处理信息
- (XAPEngineerModel *)handlePath:(NSString *)path error:(NSError * __autoreleasing _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
