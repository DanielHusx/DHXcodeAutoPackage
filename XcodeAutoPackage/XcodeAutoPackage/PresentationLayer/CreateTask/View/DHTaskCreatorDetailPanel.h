//
//  DHTaskCreatorDetailPanel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/25.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DHTaskModel;
NS_ASSUME_NONNULL_BEGIN

@interface DHTaskCreatorDetailPanel : NSPanel


+ (void)showWithWindow:(NSWindow *)window
                  path:(NSString *_Nullable)path
                  task:(DHTaskModel *_Nullable)task
              backwark:(nullable void (^) (void))backwark
              callback:(void (^) (DHTaskModel *task))callback;


@end

NS_ASSUME_NONNULL_END
