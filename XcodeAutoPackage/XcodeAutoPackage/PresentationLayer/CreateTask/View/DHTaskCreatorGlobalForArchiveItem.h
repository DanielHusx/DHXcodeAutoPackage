//
//  DHTaskCreatorGlobalForArchiveItem.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DHCellProtocol.h"

@protocol DHTaskCreatorGlobalForArchiveItemDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface DHTaskCreatorGlobalForArchiveItem : NSCollectionViewItem <DHCellProtocol>

/// 代理
@property (nonatomic, weak) id<DHTaskCreatorGlobalForArchiveItemDelegate> delegate;

@end

@protocol DHTaskCreatorGlobalForArchiveItemDelegate <NSObject>
- (void)archiveCell:(DHTaskCreatorGlobalForArchiveItem *)archiveCell didChangedPlatform:(NSString *)platform;
- (void)archiveCell:(DHTaskCreatorGlobalForArchiveItem *)archiveCell didChangedApiKey:(NSString *)apiKey;
- (void)archiveCell:(DHTaskCreatorGlobalForArchiveItem *)archiveCell didChangedPassword:(NSString *)password;
- (void)archiveCell:(DHTaskCreatorGlobalForArchiveItem *)archiveCell didChangedIPADir:(NSString *)IPADir;
- (void)archiveCellDidClickIPAChooseDirectory:(DHTaskCreatorGlobalForArchiveItem *)archiveCell;
@end

NS_ASSUME_NONNULL_END
