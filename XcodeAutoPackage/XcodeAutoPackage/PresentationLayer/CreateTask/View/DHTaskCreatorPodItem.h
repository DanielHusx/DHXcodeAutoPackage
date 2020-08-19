//
//  DHTaskCreatorPodItem.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/6.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DHCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DHTaskCreatorPodItemDelegate;
@interface DHTaskCreatorPodItem : NSCollectionViewItem <DHCellProtocol>

/// 代理
@property (nonatomic, weak) id<DHTaskCreatorPodItemDelegate> delegate;

@end


@protocol DHTaskCreatorPodItemDelegate <NSObject>
- (void)podCell:(DHTaskCreatorPodItem *)podCell didChangedPodInstall:(BOOL)podInstall;
@end

NS_ASSUME_NONNULL_END
