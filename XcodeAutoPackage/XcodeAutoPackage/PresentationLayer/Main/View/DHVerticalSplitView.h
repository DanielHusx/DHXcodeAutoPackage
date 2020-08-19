//
//  DHVerticalSplitView.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/21.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DHVerticalSplitViewDelegate;

@interface DHVerticalSplitView : NSSplitView
/// 代理
@property (nonatomic, weak) id<DHVerticalSplitViewDelegate> verticalSplitViewDelegate;

/// 获取不可接受分割事件的宽度（剩下区域，鼠标放置自动会变成分割箭头）
- (CGFloat)effectiveWidth;

@end

@protocol DHVerticalSplitViewDelegate <NSObject>

/// 代理通知该折叠或者取消折叠
///
/// @param splitView 分割视图
/// @param collapse YES: 折叠；NO: 取消折叠
/// @param index 在分割视图中的排序
- (void)splitView:(DHVerticalSplitView *)splitView shouldCollapse:(BOOL)collapse atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
