//
//  DHTaskCreatorGlobalForAppItem.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DHCellProtocol.h"

@protocol DHTaskCreatorGlobalForAppItemDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface DHTaskCreatorGlobalForAppItem : NSCollectionViewItem <DHCellProtocol>

/// 代理
@property (nonatomic, weak) id<DHTaskCreatorGlobalForAppItemDelegate> delegate;

@end

@protocol DHTaskCreatorGlobalForAppItemDelegate <NSObject>

- (void)ipaCell:(DHTaskCreatorGlobalForAppItem *)ipaCell didChangedPlatform:(NSString *)platform;
- (void)ipaCell:(DHTaskCreatorGlobalForAppItem *)ipaCell didChangedApiKey:(NSString *)apiKey;
- (void)ipaCell:(DHTaskCreatorGlobalForAppItem *)ipaCell didChangedPassword:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
