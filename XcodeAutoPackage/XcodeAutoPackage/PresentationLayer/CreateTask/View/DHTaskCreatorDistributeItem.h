//
//  DHTaskCreatorDistributeItem.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/6.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DHCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DHTaskCreatorDistributeItemDelegate;
@interface DHTaskCreatorDistributeItem : NSCollectionViewItem <DHCellProtocol>

/// 代理
@property (nonatomic, weak) id<DHTaskCreatorDistributeItemDelegate> delegate;

@end


@protocol DHTaskCreatorDistributeItemDelegate <NSObject>
- (void)distributeCell:(DHTaskCreatorDistributeItem *)distributeCell didChangedPlatform:(NSString *)platform;
- (void)distributeCell:(DHTaskCreatorDistributeItem *)distributeCell didChangedNickname:(NSString *)nickname;
- (void)distributeCell:(DHTaskCreatorDistributeItem *)distributeCell didChangedAPIKey:(NSString *)apiKey;
- (void)distributeCell:(DHTaskCreatorDistributeItem *)distributeCell didChangedInstallPassword:(NSString *)installPassword;
- (void)distributeCell:(DHTaskCreatorDistributeItem *)distributeCell didChangedChangeLog:(NSString *)changeLog;
@end

NS_ASSUME_NONNULL_END
