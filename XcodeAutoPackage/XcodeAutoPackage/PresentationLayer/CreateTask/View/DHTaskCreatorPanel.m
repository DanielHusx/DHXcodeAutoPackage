//
//  DHTaskCreatorPanel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/25.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskCreatorPanel.h"
#import "DHTaskUtils.h"

@interface DHTaskCreatorPanel () <NSTextFieldDelegate>

@property (weak) IBOutlet NSTextField *pathTextField;
@property (weak) IBOutlet NSButton *nextButton;
@property (weak) IBOutlet NSProgressIndicator *processIndicator;
@property (weak) IBOutlet NSButton *cancelButton;
/// callback
@property (nonatomic, copy) void (^callback) (NSString * _Nullable);
/// 是否在解析中
@property (nonatomic, assign, getter=isProcessing) BOOL processing;
@end

@implementation DHTaskCreatorPanel
#pragma mark - initialization
+ (instancetype)panel {
    DHTaskCreatorPanel *panel;
    NSArray *topLevelObjects;
    
    if (![[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil topLevelObjects:&topLevelObjects]) { return nil; }
    for (id object in topLevelObjects) {
        if ([object isKindOfClass:[DHTaskCreatorPanel class]]) {
            panel = object;
            break;
        }
    }
    return panel;
}


#pragma mark - public method
+ (void)showWithWindow:(NSWindow *)window
           defaultPath:(NSString *)defaultPath
              callback:(nonnull void (^)(NSString *))callback {
    DHTaskCreatorPanel *panel = [DHTaskCreatorPanel panel];
    panel.parentWindow = window;
    panel.callback = callback;
    [panel configWithPath:defaultPath];
    // 显示
    [window beginSheet:panel completionHandler:nil];
}

#pragma mark - loading
- (void)startProcess {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.processing = YES;
        self.nextButton.enabled = NO;
        [self.processIndicator startAnimation:self];
    });
}

- (void)stopProcessWithNextable:(BOOL)nextable {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.processing = NO;
        [self.processIndicator stopAnimation:self];
        self.nextButton.enabled = nextable;
    });
}

#pragma mark - prviate methods
- (void)configWithPath:(NSString *)path {
    self.pathTextField.stringValue = path?:@"";
    self.cancelButton.state = NSControlStateValueOff;
    if ([DHCommonTools isPathExist:path]) {
        // 去解析
        [self processTaskParsed];
    }
}

- (void)processTaskParsed {
    if (self.isProcessing) { return ; }
    // 加载中
    [self startProcess];
    
    NSString *path = _pathTextField.stringValue;
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 检测路径是否有效
        BOOL nextable = [weakself checkPathValid:path];
        [weakself stopProcessWithNextable:nextable];
        
    });
}

- (BOOL)checkPathValid:(NSString *)path {
    return [DHTaskUtils checkPathValid:path];
}

#pragma mark - event response
// 点击打开文件夹
- (IBAction)openFinderAction:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = YES;
    openPanel.canChooseDirectories = YES;
    openPanel.allowsMultipleSelection = NO;
    openPanel.allowedFileTypes = @[@"xcarchive", @"ipa"];
    [openPanel beginSheetModalForWindow:self
                      completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSString *path = [[openPanel URL] path];
            self.pathTextField.stringValue = path;
            [self processTaskParsed];
        }
    }];
}

// 点击取消按钮
- (IBAction)cancelAction:(id)sender {
    [self.parentWindow endSheet:self];
}

// 点击下一步按钮
- (IBAction)nextAction:(id)sender {
    if (self.callback) {
        self.callback(self.pathTextField.stringValue);
    }
    [self.parentWindow endSheet:self];
}


#pragma mark - NSTextFieldDelegate
- (void)controlTextDidBeginEditing:(NSNotification *)obj {
    // 开始编辑，则停止检测
    [self stopProcessWithNextable:NO];
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    // 回车，开始检测
    [self processTaskParsed];
}

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {
    return !self.isProcessing;
}

@end
