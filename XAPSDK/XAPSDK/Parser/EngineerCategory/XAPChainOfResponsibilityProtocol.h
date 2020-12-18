//
//  XAPChainOfResponsibilityProtocol.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XAPEngineerModel;

@protocol XAPChainOfResponsibilityProtocol <NSObject>

/// 下一个责任人
@property (nonatomic, strong) id <XAPChainOfResponsibilityProtocol> nextHandler;
/// 接收处理信息
- (XAPEngineerModel *)handlePath:(NSString *)path error:(NSError * __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
