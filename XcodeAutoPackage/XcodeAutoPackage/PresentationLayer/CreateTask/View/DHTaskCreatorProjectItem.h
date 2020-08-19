//
//  DHTaskCreatorProjectItem.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/23.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DHCellProtocol.h"

@protocol DHTaskCreatorProjectItemDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface DHTaskCreatorProjectItem : NSCollectionViewItem <DHCellProtocol>

/// 代理
@property (nonatomic, weak) id<DHTaskCreatorProjectItemDelegate> delegate;

@end


@protocol DHTaskCreatorProjectItemDelegate <NSObject>
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedDisplayName:(NSString *)displayName;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedXcodeprojFile:(NSString *)xcodeprojFile;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedScheme:(NSString *)scheme;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedTeam:(NSString *)team;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedBundleId:(NSString *)bundleId;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedVersion:(NSString *)version;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedBuild:(NSString *)build;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedEnableBitcode:(NSString *)enableBitcode;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedChannel:(NSString *)channel;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedConfiguration:(NSString *)configuration;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedArchiveDir:(NSString *)archiveDir;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedIPADir:(NSString *)ipaDir;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedKeepXcarchive:(BOOL)keepXcarchive;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedDisplayNameForceSet:(BOOL)forceSet;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedBundlIdForceSet:(BOOL)forceSet;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedTeamIdForceSet:(BOOL)forceSet;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedVersionForceSet:(BOOL)forceSet;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedBuildVersionForceSet:(BOOL)forceSet;
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedEnableBitcodeForceSet:(BOOL)forceSet;


@end
NS_ASSUME_NONNULL_END
