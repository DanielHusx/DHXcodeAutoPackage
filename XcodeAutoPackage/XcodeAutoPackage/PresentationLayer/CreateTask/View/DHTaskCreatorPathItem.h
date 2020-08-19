//
//  DHTaskCreatorPathItem.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/23.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DHCellProtocol.h"

@protocol DHTaskCreatorPathItemDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface DHTaskCreatorPathItem : NSCollectionViewItem <DHCellProtocol>
/// cell代理
@property (nonatomic, weak) id<DHTaskCreatorPathItemDelegate> delegate;

@end

@protocol DHTaskCreatorPathItemDelegate <NSObject>

- (void)pathCell:(DHTaskCreatorPathItem *)pathCell didChangedPath:(NSString *)path;
- (void)pathCell:(DHTaskCreatorPathItem *)pathCell didChangedTaskName:(NSString *)taskName;
@end

NS_ASSUME_NONNULL_END
