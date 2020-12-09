//
//  XAPDistributorProtocol.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XAPDistributorProtocol <NSObject>
/// 标识
@property (nonatomic, copy) NSString *identifier;
/// 名称
@property (nonatomic, copy) NSString *name;
/// 接口key
@property (nonatomic, copy) NSString *apiKey;
/// 更新日志
@property (nonatomic, copy) NSString *changeLog;

/// 发布ipa
- (void)distributeIPAFile:(NSString *)ipaFile
    uploadProgressHandler:(nullable void (^) (NSProgress *uploadProgress))uploadProgressHandler
        completionHandler:(nonnull void (^) (BOOL succeed, NSError *_Nullable error))completionHandler;
/// 中断发布进程
- (void)interruptDistribution;

@end

NS_ASSUME_NONNULL_END
