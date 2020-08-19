//
//  DHMainWindowController.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/14.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHMainWindowController.h"
#import "DHTaskExecutor.h"

@interface DHMainWindowController () <DHLoggerStatusDelegate>

@property (weak) IBOutlet NSToolbarItem *runToolbarItem;
@property (weak) IBOutlet NSToolbarItem *stopToolbarItem;
@property (weak) IBOutlet NSToolbarItem *deleteToolbarItem;
@property (weak) IBOutlet NSToolbarItem *addToolbarItem;
@property (weak) IBOutlet NSToolbarItem *settingToolItem;
@property (weak) IBOutlet NSToolbarItem *statusToolbarItem;
@property (weak) IBOutlet NSButton *statusButton;
@property (weak) IBOutlet NSProgressIndicator *statusProgressIndicator;
@property (weak) IBOutlet NSTextField *statusLabel;

@end

@implementation DHMainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self setupUI];
    [self addNotifications];
    [self addObservers];
}

// MARK: - setup
- (void)setupUI {
    [[DHLogger shareLogger] setStatusDelegate:self];
    
    self.runToolbarItem.toolTip = @"Run the Selected Task";
    self.stopToolbarItem.toolTip = @"Stop the Running Task";
    self.addToolbarItem.toolTip = @"Create a Task";
    self.deleteToolbarItem.toolTip = @"Delete the Selected Task";
    self.settingToolItem.toolTip = @"Global Settings";
    
}


// MARK: - DHLoggerDelegate
- (void)logger:(DHLogger *)logger didReceivedInfo:(NSString *)info {
    [self setupStatusString:info];
}

- (void)logger:(DHLogger *)logger didReceivedError:(NSString *)error {
    [self setupStatusString:error];
}

- (void)logger:(DHLogger *)logger didReceivedWarning:(NSString *)warning {
    [self setupStatusString:warning];
}

// MARK: - notifications
- (void)addNotifications {}

- (void)receivedListExistSelectionDidChangedNotify:(NSNotification *)sender {
    BOOL existSelection = [sender.object boolValue];
    [self setupRunToolbarItemEnable:existSelection];
}


#pragma mark - observer
- (void)addObservers {
    // 监听任务执行者的运行情况
    [[DHTaskExecutor executor] addObserver:self
                                forKeyPath:@"running"
                                   options:NSKeyValueObservingOptionNew
                                   context:nil];
    // 监听任务执行者的运行情况
    [[DHTaskExecutor executor] addObserver:self
                                forKeyPath:@"taskProgress"
                                   options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                                   context:nil];
    // 监听任务执行者的运行情况
    [[DHTaskExecutor executor].taskProgress addObserver:self
                                             forKeyPath:@"completedUnitCount"
                                                options:NSKeyValueObservingOptionNew
                                                context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"running"]) {
        // 正在执行状态 改变中断按钮的状态
        BOOL isRunning = [change[NSKeyValueChangeNewKey] boolValue];
        [self setupStopToolbarItemEnable:isRunning];
        
    } else if ([keyPath isEqualToString:@"taskProgress"]) {
        // 进度管理对象改变，进而监听完成进度
        NSProgress *oldProgress = change[NSKeyValueChangeOldKey];
        NSProgress *newProgress = change[NSKeyValueChangeNewKey];
        if (![oldProgress isKindOfClass:[NSNull class]]) {
            [[DHTaskExecutor executor].taskProgress removeObserver:self
                                                        forKeyPath:@"completedUnitCount"];
        }
        if (![newProgress isKindOfClass:[NSNull class]]) {
            // 监听任务执行者的进度
            [[DHTaskExecutor executor].taskProgress addObserver:self
                                                     forKeyPath:@"completedUnitCount"
                                                        options:NSKeyValueObservingOptionNew
                                                        context:nil];
            [self setupStatusProgressIndicatorEnable:YES];
        } else {
            [self setupStatusProgressIndicatorEnable:NO];
        }
        
    } else if ([keyPath isEqualToString:@"completedUnitCount"]) {
        // 进度改变
        [self setupStatusProgressIndicatorWithCompletedUnitCount:[DHTaskExecutor executor].taskProgress.completedUnitCount
                                                  totalUnitCount:[DHTaskExecutor executor].taskProgress.totalUnitCount];
    }
}

#pragma mark - setup
- (void)setupStopToolbarItemEnable:(BOOL)enable {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakself.stopToolbarItem.enabled = enable;
    });
}

- (void)setupStatusProgressIndicatorEnable:(BOOL)enable {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakself.statusProgressIndicator.hidden = !enable;
        if (!enable) { return ; }
        [weakself setupStatusProgressIndicatorValue:0];
    });
}

- (void)setupStatusProgressIndicatorWithCompletedUnitCount:(int64_t)completedUnitCount
                                            totalUnitCount:(int64_t)totalUnitCount {
    double value = completedUnitCount * 100.0  / totalUnitCount;
    [self setupStatusProgressIndicatorValue:value];
}

- (void)setupStatusProgressIndicatorValue:(double)value {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakself.statusProgressIndicator.doubleValue = value;
    });
}

- (void)setupStatusString:(NSString *)string {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakself.statusLabel.stringValue = string?:@"";
    });
}

- (void)setupRunToolbarItemEnable:(BOOL)enable {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakself.runToolbarItem.enabled = enable;
    });
}


// MARK: - event response
- (IBAction)statusButtonAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDHToolbarStatusNotificationName object:nil];
}

- (IBAction)runToolbarItemAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDHToolbarRunNotificationName object:nil];
}
- (IBAction)stopToolbarItemAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDHToolbarStopNotificationName object:nil];
}

- (IBAction)addToolbarItemAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDHToolbarAddNotificationName object:nil];
}
- (IBAction)deleteToolbarItemAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDHToolbarDeleteNotificationName object:nil];
}

- (IBAction)settingToolbarItemAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDHToolbarSettingNotificationName object:nil];
}


@end
