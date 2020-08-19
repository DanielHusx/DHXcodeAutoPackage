//
//  DHCellProtocol.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/23.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DHCellProtocol <NSObject>

@optional
+ (NSString *)reuseIdentifier;
+ (void)registerByView:(NSView *)view;
+ (CGFloat)cellHeight;
+ (instancetype)cellWithCollectionView:(NSCollectionView *)collectionView
                             indexPath:(NSIndexPath *)indexPath
                                target:(id)target;
+ (NSSize)cellSizeWithWidth:(CGFloat)width;
+ (NSSize)cellSizeWithWidth:(CGFloat)width
                     object:(id)object;

@end

NS_ASSUME_NONNULL_END
