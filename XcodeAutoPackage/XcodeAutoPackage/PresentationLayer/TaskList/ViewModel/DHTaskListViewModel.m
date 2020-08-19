//
//  DHTaskListViewModel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/16.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskListViewModel.h"
#import "DHTaskArchiver.h"
#import "DHTaskModel.h"
#import "NSArray+DHArrayExtension.h"
#import "DHTaskExecutor.h"

#import "DHSettingsViewModel.h"
#import "DHTaskCreatorViewModel.h"
#import "DHTaskDetailViewModel.h"
#import "DHTaskUtils.h"

@interface DHTaskListViewModel ()
/// 关联控制器
@property (nonatomic, weak) NSViewController *viewController;
/// 创建任务viewModel
@property (nonatomic, strong) DHTaskCreatorViewModel *creatorViewModel;
/// 全局设置viewModel
@property (nonatomic, strong) DHSettingsViewModel *settingsViewModel;
/// 任务详情viewModel
@property (nonatomic, strong) DHTaskDetailViewModel *detailViewModel;

/// 源数据
@property (nonatomic, strong) NSMutableArray *originalDataSource;
/// 筛选条件
@property (nonatomic, assign) DHFilterCondition filterCondition;

@end

@implementation DHTaskListViewModel

- (instancetype)initWithViewController:(NSViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
        // 添加归档的内容
        [self unarchiveDataSource];
        // 监听通知
        [self addNotfications];
    }
    return self;
}

- (void)addNotfications {
    // 修改单个
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedRowModifyNotify:)
                                                 name:kDHRowModifyNotificationName
                                               object:nil];
    // 删除已选项
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedRowDeleteNotify:)
                                                 name:kDHRowDeleteNotificationName
                                               object:nil];
    // 添加任务
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedAddNotify:)
                                                 name:kDHToolbarAddNotificationName
                                               object:nil];
    // 设置
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedSettingNotify:)
                                                 name:kDHToolbarSettingNotificationName
                                               object:nil];
    
    // 停止
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedStopNotify:)
                                                 name:kDHToolbarStopNotificationName
                                               object:nil];
    // 日志
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedStatusNotify:)
                                                 name:kDHToolbarStatusNotificationName
                                               object:nil];
    // 监听筛选条件更新
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedFilterConditionDidChangedNotify:)
                                                 name:kDHFilterConditionDidChangedNotificationName
                                               object:nil];
}

- (void)receivedFilterConditionDidChangedNotify:(NSNotification *)sender {
    DHFilterCondition filterCondition = [sender.object integerValue];
    self.filterCondition = filterCondition;
}

- (void)receivedRowModifyNotify:(NSNotification *)sender {
    NSInteger row = [sender.object integerValue];
    [self modifyTaskAtIndex:row];
}

- (void)receivedRowDeleteNotify:(NSNotification *)sender {
    NSIndexSet *rowIndexSet = sender.object;
    [self deleteTaskAtIndexSet:rowIndexSet];
}

- (void)receivedAddNotify:(NSNotification *)sender {
    [self showCreateTaskPanel];
}

- (void)receivedSettingNotify:(NSNotification *)sender {
    [self showSettingPanel];
}

- (void)receivedStopNotify:(NSNotification *)sender {
    [self interrupTask];
}

- (void)receivedStatusNotify:(NSNotification *)sender {
    [self showLoggerPanel];
}


// MARK: - public method
- (id)objectValueForIdentifier:(NSString *)identifier
                           row:(NSInteger)row {
    DHTaskModel *taskModel = [self.dataSource safeObjectAtIndex:row];
    
    if ([identifier isEqualToString:@"taskName"]) {
        return taskModel.taskName;
    } else if ([identifier isEqualToString:@"product"]) {
        return taskModel.currentDisplayName;
    } else if ([identifier isEqualToString:@"type"]) {
        return taskModel.taskTypeName; 
    }
    return nil;
}


// MARK: - 视图
- (void)showModifyTaskPanelWithTask:(DHTaskModel *)task {
    __weak typeof(self) weakself = self;
    [self.detailViewModel showTask:task
                          callback:^(DHTaskModel * _Nonnull aTask) {
        [weakself modifyTask:aTask];
    }];
}

- (void)showCreateTaskPanel {
    [self.creatorViewModel createTask];
}

- (void)showSettingPanel {
    [self.settingsViewModel showSettings];
}

- (void)showLoggerPanel {
    // 暂时没有什么用处
}


// MARK: - private method
- (void)appendTask:(DHTaskModel *)task {
    if (!task) { return ; }
    [self dataSourceAppendTask:task];
    // 存储当前的所有任务
    [self archiveDataSource];
    [self reloadData];
}

- (void)modifyTaskAtIndex:(NSInteger)index {
    DHTaskModel *taskModel = [self.dataSource safeObjectAtIndex:index];
    if (!taskModel) { return ; }
    // 展示修改
    [self showModifyTaskPanelWithTask:taskModel];
}

- (void)modifyTask:(DHTaskModel *)task {
    if (!task) { return ; }
    NSInteger index = [self.dataSource indexOfObject:task];
    if (index == NSNotFound) {
        DHLogDebug(@"未找到需要修改的任务");
        return ;
    }
    [self dataSourceModifyTask:task];
    [self archiveDataSource];
    [self reloadDataAtRow:index];
}

- (void)deleteTaskAtIndexSet:(NSIndexSet *)indexSet {
    
    if (![indexSet count]) {
        DHLogDebug(@"尚未选择任务去删除");
        return ;
    }
    
    __weak typeof(self) weakself = self;
    [DHAlert showInfoAlertWithTitle:@"确定删除已选任务？"
                            message:@"一旦删除将无法恢复！"
                        doneHandler:^{

        [weakself dataSourceDeleteTask:indexSet];
        [weakself archiveDataSource];
        [weakself reloadData];
    }];
}

- (void)executeTaskAtIndexSet:(NSIndexSet *)indexSet {
    if (![indexSet count]) { return ; }
    
    // 判断是否存在任务尚在执行
    if ([[DHTaskExecutor executor] isRunning]) {
        [DHAlert showWarningAlertWithTitle:@"执行任务警告"
                                   message:@"存在任务尚在执行，请稍后..."];
        return ;
    }
    NSArray *tasks = [self.dataSource objectsAtIndexes:indexSet];
    // 执行
    [[DHTaskExecutor executor] executeTasks:tasks];
}

- (void)interrupTask {
    if (![[DHTaskExecutor executor] isRunning]) { return ; }
    // 中断所有任务
    [[DHTaskExecutor executor] interruptAllTask];
}


// MARK: - dataSource
- (void)dataSourceAppendTask:(DHTaskModel *)task {
    [self.originalDataSource addObject:task];
    
    self.dataSource = [[DHTaskUtils filterTaskModels:self.originalDataSource
                                       withCondition:self.filterCondition] mutableCopy];
}

- (void)dataSourceDeleteTask:(NSIndexSet *)indexSet {
    NSArray *deleteTasks = [self.dataSource objectsAtIndexes:indexSet];
    [self.originalDataSource removeObjectsInArray:deleteTasks];
    [self.dataSource removeObjectsAtIndexes:indexSet];
}

- (void)dataSourceModifyTask:(DHTaskModel *)task {
    NSInteger indexInOriginal = [self.originalDataSource indexOfObject:task];
    [self.originalDataSource replaceObjectAtIndex:indexInOriginal withObject:task];
    
    NSInteger index = [self.dataSource indexOfObject:task];
    [self.dataSource replaceObjectAtIndex:index withObject:task];
}


// MARK: - archive & unarchive
- (void)unarchiveDataSource {
    NSArray *tasks = [DHTaskArchiver unarchivedTaskArray];
    if (![DHCommonTools isValidArray:tasks]) { return ; }
    
    [self.originalDataSource addObjectsFromArray:tasks];
    [self.dataSource addObjectsFromArray:tasks];
    [self reloadData];
}

- (void)archiveDataSource {
    [DHTaskArchiver archiveTaskArray:self.originalDataSource];
}


// MARK: - reload
- (void)reloadData {
    if (!_delegate) { return ; }
    if (![_delegate respondsToSelector:@selector(reloadData)]) { return ; }
    [_delegate reloadData];
}

- (void)reloadDataAtRow:(NSInteger)row {
    [self reloadDataAtRowIndexSet:[NSIndexSet indexSetWithIndex:row]];
}

- (void)reloadDataAtRowIndexSet:(NSIndexSet *)rowIndexSet {
    if (!_delegate) { return ; }
    if (![_delegate respondsToSelector:@selector(reloadDataAtRowIndexSet:)]) { return ; }
    [_delegate reloadDataAtRowIndexSet:rowIndexSet];
}



// MARK: - getters & setters
- (void)setFilterCondition:(DHFilterCondition)filterCondition {
    _filterCondition = filterCondition;
    
    self.dataSource = [[DHTaskUtils filterTaskModels:self.originalDataSource
                                       withCondition:self.filterCondition] mutableCopy];
    [self reloadData];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (DHTaskCreatorViewModel *)creatorViewModel {
    if (!_creatorViewModel) {
        __weak typeof(self) weakself = self;
        _creatorViewModel = [[DHTaskCreatorViewModel alloc] initWithViewController:_viewController callback:^(DHTaskModel * _Nonnull task) {
            // 新增task
            [weakself appendTask:task];
        }];
    }
    return _creatorViewModel;
}

- (DHSettingsViewModel *)settingsViewModel  {
    if (!_settingsViewModel) {
        _settingsViewModel = [[DHSettingsViewModel alloc] initWithViewController:_viewController];
    }
    return _settingsViewModel;
}

- (DHTaskDetailViewModel *)detailViewModel {
    if (!_detailViewModel) {
        _detailViewModel = [[DHTaskDetailViewModel alloc] initWithViewController:_viewController];
    }
    return _detailViewModel;
}

- (NSMutableArray *)originalDataSource {
    if (!_originalDataSource) {
        _originalDataSource = [NSMutableArray array];
    }
    return _originalDataSource;
}
@end
