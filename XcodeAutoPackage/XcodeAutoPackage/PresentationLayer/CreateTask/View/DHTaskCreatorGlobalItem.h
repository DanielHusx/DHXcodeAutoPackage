//
//  DHTaskCreatorGlobalItem.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DHCellProtocol.h"

@protocol DHTaskCreatorGlobalItemDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface DHTaskCreatorGlobalItem : NSCollectionViewItem <DHCellProtocol>
/// 代理
@property (nonatomic, weak) id<DHTaskCreatorGlobalItemDelegate> delegate;

@end

@protocol DHTaskCreatorGlobalItemDelegate <NSObject>
// platform
- (void)globalCell:(DHTaskCreatorGlobalItem *)globalCell didChangedPlatform:(NSString *)platform;
- (void)globalCell:(DHTaskCreatorGlobalItem *)globalCell didChangedApiKey:(NSString *)apiKey;
- (void)globalCell:(DHTaskCreatorGlobalItem *)globalCell didChangedPassword:(NSString *)password;

// archive
- (void)globalCell:(DHTaskCreatorGlobalItem *)globalCell didChangedArchiveDir:(NSString *)archiveDir;
- (void)globalCellDidClickArchiveChooseDirectory:(DHTaskCreatorGlobalItem *)globalCell;

// ipa
- (void)globalCell:(DHTaskCreatorGlobalItem *)globalCell didChangedIPADir:(NSString *)IPADir;
- (void)globalCellDidClickIPAChooseDirectory:(DHTaskCreatorGlobalItem *)globalCell;


// 改变
- (void)globalCell:(DHTaskCreatorGlobalItem *)globalCell didChangedChannel:(DHChannel)channel;
- (void)globalCell:(DHTaskCreatorGlobalItem *)globalCell didChangedConfiguration:(DHConfigurationName)configuration;

- (void)globalCell:(DHTaskCreatorGlobalItem *)globalCell didChangedKeepArchive:(BOOL)isKeepArchive;
- (void)globalCell:(DHTaskCreatorGlobalItem *)globalCell didChangedGitPull:(BOOL)isGitPull;
- (void)globalCell:(DHTaskCreatorGlobalItem *)globalCell didChangedPodInstall:(BOOL)isPodInstall;

@end

NS_ASSUME_NONNULL_END
