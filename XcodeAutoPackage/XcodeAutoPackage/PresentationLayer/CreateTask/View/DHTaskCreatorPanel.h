//
//  DHTaskCreatorPanel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/25.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>


NS_ASSUME_NONNULL_BEGIN
@class DHTaskModel;
@interface DHTaskCreatorPanel : NSPanel


/// 显示创建任务panel
/// @param window 展示所在的window
/// @param defaultPath 默认路径
/// @param callback 回调结果，一点回调path，那么一定是可解析的
+ (void)showWithWindow:(NSWindow *)window
           defaultPath:(NSString * _Nullable)defaultPath
              callback:(void (^) (NSString *path))callback;

@end


NS_ASSUME_NONNULL_END
