//
//  DHSettingsViewModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 全局设置
 */
@interface DHSettingsViewModel : NSObject

- (instancetype)initWithViewController:(NSViewController *)viewController;
- (void)showSettings;

@end

NS_ASSUME_NONNULL_END
