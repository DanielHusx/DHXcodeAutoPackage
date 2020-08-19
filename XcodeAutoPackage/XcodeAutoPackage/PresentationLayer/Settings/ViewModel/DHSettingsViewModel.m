//
//  DHSettingsViewModel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHSettingsViewModel.h"
#import "DHSettingsPanel.h"

@interface DHSettingsViewModel ()
/// 控制器
@property (nonatomic, weak) NSViewController *viewController;

@end

@implementation DHSettingsViewModel
#pragma mark - public method
- (instancetype)initWithViewController:(NSViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
        
    }
    return self;
}

- (void)showSettings {
    [DHSettingsPanel showWithWindow:self.viewController.view.window];
}

@end
