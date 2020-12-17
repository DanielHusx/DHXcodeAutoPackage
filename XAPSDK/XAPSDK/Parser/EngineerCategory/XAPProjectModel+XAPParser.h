//
//  XAPProjectModel+XAPParser.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPProjectModel.h"
#import "XAPChainOfResponsibilityProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XAPProjectModel (XAPParser) <XAPChainOfResponsibilityProtocol>

/// 下一个责任人
@property (nonatomic, strong) id <XAPChainOfResponsibilityProtocol> nextHandler;
/// 接收处理信息
- (XAPEngineerModel *)handlePath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
