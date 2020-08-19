//
//  DHTaskCreatorGitItem.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/6.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DHCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DHTaskCreatorGitItemDelegate;
@interface DHTaskCreatorGitItem : NSCollectionViewItem <DHCellProtocol>

/// 代理
@property (nonatomic, weak) id<DHTaskCreatorGitItemDelegate> delegate;

@end


@protocol DHTaskCreatorGitItemDelegate <NSObject>
- (void)gitCell:(DHTaskCreatorGitItem *)gitCell didChangedBranch:(NSString *)branch;
- (void)gitCell:(DHTaskCreatorGitItem *)gitCell didChangedGitPull:(BOOL)gitPull;
@end

NS_ASSUME_NONNULL_END
