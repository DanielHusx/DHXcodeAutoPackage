//
//  DHSettingsPanel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHSettingsPanel : NSPanel
/// 显示创建任务panel
/// @param window 展示所在的window
+ (void)showWithWindow:(NSWindow *)window;

@end

NS_ASSUME_NONNULL_END
