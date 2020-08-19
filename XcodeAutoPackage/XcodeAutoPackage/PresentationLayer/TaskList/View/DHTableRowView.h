//
//  DHTableRowView.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/27.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHTableRowView : NSTableRowView
/// 记录rowIndex
@property (nonatomic, assign) NSUInteger rowIndex;

@end

NS_ASSUME_NONNULL_END
