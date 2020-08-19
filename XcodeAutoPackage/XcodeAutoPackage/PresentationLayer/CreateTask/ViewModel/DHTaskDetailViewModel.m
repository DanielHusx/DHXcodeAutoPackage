//
//  DHTaskDetailViewModel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/8.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskDetailViewModel.h"
#import "DHTaskModel.h"
#import "DHTaskUtils.h"
#import "DHTaskCreatorDetailPanel.h"

@interface DHTaskDetailViewModel ()

/// 控制器
@property (nonatomic, weak) NSViewController *viewController;
/// 任务
@property (nonatomic, strong) DHTaskModel *task;
/// callback
@property (nonatomic, copy) void (^callback) (DHTaskModel *);

@end

@implementation DHTaskDetailViewModel
#pragma mark - public method
- (instancetype)initWithViewController:(NSViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

- (void)showTask:(DHTaskModel *)task
        callback:(nonnull void (^)(DHTaskModel * _Nonnull))callback {
    [DHTaskCreatorDetailPanel showWithWindow:self.viewController.view.window
                                        path:nil
                                        task:task
                                    backwark:nil
                                    callback:callback];
}

@end
