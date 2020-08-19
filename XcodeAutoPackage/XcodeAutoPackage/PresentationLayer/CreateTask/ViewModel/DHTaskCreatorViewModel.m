//
//  DHTaskCreatorViewModel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/23.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskCreatorViewModel.h"
#import "DHTaskModel.h"
#import "DHTaskUtils.h"
#import "DHTaskCreatorPanel.h"
#import "DHTaskCreatorDetailPanel.h"

@interface DHTaskCreatorViewModel ()
/// 控制器
@property (nonatomic, weak) NSViewController *viewController;
/// 任务
@property (nonatomic, strong) DHTaskModel *task;
/// callback
@property (nonatomic, copy) void (^callback) (DHTaskModel *);
@end

@implementation DHTaskCreatorViewModel

#pragma mark - public method
- (instancetype)initWithViewController:(NSViewController *)viewController
                              callback:(nonnull void (^)(DHTaskModel * _Nonnull))callback{
    self = [super init];
    if (self) {
        _viewController = viewController;
        _callback = callback;
    }
    return self;
}

- (void)createTask {
    [self showCreateTaskPanelWithPath:@""];
}

- (void)nextStepWithPath:(NSString *)path {
    [self showCreatorDetailTaskPanel:path];
}


#pragma mark - show method
- (void)showCreateTaskPanelWithPath:(NSString *)path {
    __weak typeof(self) weakself = self;
    [DHTaskCreatorPanel showWithWindow:self.viewController.view.window
                           defaultPath:path
                              callback:^(NSString * _Nullable path) {
        [weakself nextStepWithPath:path];
    }];
}

- (void)showCreatorDetailTaskPanel:(NSString *)path {
    
    __weak typeof(self) weakself = self;
    [DHTaskCreatorDetailPanel showWithWindow:self.viewController.view.window
                                        path:path
                                        task:nil
                                    backwark:^{
        // 返回上一步
        [weakself showCreateTaskPanelWithPath:path];
    } callback:^(DHTaskModel * _Nonnull task) {
        // 得到编辑后的任务
        if (weakself.callback) { weakself.callback(task); }
    }];
}


#pragma mark - getters
- (DHTaskModel *)task {
    if (!_task) {
        _task = [[DHTaskModel alloc] init];
    }
    return _task;
}

@end
