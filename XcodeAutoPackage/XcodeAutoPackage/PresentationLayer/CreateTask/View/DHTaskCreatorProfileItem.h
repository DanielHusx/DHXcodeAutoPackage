//
//  DHTaskCreatorProfileItem.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/23.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DHCellProtocol.h"

@protocol DHTaskCreatorProfileItemDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface DHTaskCreatorProfileItem : NSCollectionViewItem <DHCellProtocol>
/// 代理
@property (nonatomic, weak) id<DHTaskCreatorProfileItemDelegate> delegate;

@end

@protocol DHTaskCreatorProfileItemDelegate <NSObject>
/// profile更改了路径
- (void)profileCell:(DHTaskCreatorProfileItem *)profileCell didChangedPath:(NSString *)path;
/// profile更改名称
- (void)profileCell:(DHTaskCreatorProfileItem *)profileCell didChangedName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
