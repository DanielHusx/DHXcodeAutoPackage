//
//  DHTaskCreatorArchiveItem.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/6.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DHCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DHTaskCreatorArchiveItemDelegate;
@interface DHTaskCreatorArchiveItem : NSCollectionViewItem <DHCellProtocol>
/// 代理
@property (nonatomic, weak) id<DHTaskCreatorArchiveItemDelegate> delegate;

@end


@protocol DHTaskCreatorArchiveItemDelegate <NSObject>
- (void)archiveCell:(DHTaskCreatorArchiveItem *)archiveCell didChangedIPADir:(NSString *)ipaDir;
@end

NS_ASSUME_NONNULL_END
