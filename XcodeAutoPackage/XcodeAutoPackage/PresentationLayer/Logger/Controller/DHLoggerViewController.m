//
//  DHLoggerViewController.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/21.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHLoggerViewController.h"
#import "DHLoggerViewModel.h"

@interface DHLoggerViewController () <DHLoggerViewModelDelegate>
/// 文字视图
@property (unsafe_unretained) IBOutlet NSTextView *loggerTextView;
/// 底部栏
@property (weak) IBOutlet NSView *bottomContentView;
/// viewModel
@property (nonatomic, strong) DHLoggerViewModel *loggerViewModel;
/// 日志滚动视图
@property (weak) IBOutlet NSScrollView *loggerScrollView;

/// 是否开启滚动底部
@property (nonatomic, assign) BOOL enableAutoScrollBottom;

@end

@implementation DHLoggerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self addNotifications];
}

- (void)setupUI {
    self.bottomContentView.wantsLayer = YES;
    self.bottomContentView.layer.backgroundColor = [NSColor blackColor].CGColor;
    self.loggerViewModel.delegate = self;
    self.enableAutoScrollBottom = YES;
    
}


// MARK: - notification method
- (void)addNotifications {
    // 监听滚动视图将要开始滚动
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedScrollViewWillStartScrollNotify:)
                                                 name:NSScrollViewWillStartLiveScrollNotification
                                               object:nil];
    // 监听滚动视图停止滚动
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedScrollViewDidEndScrollNotify:)
                                                 name:NSScrollViewDidEndLiveScrollNotification
                                               object:nil];
}

- (void)receivedScrollViewWillStartScrollNotify:(NSNotification *)sender {
    if (sender.object != self.loggerScrollView) { return ; }
    _enableAutoScrollBottom = NO;
}

- (void)receivedScrollViewDidEndScrollNotify:(NSNotification *)sender {
    if (sender.object != self.loggerScrollView) { return ; }
    _enableAutoScrollBottom = self.loggerScrollView.verticalScroller.floatValue > 0.98;
}



// MARK: - NSTextViewDelegate


// MARK: - DHLoggerViewModelDelegate
- (void)logger:(DHLoggerViewModel *)logger withString:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self appendLog:string];
        [self scrollToVisible];
    });
}

- (void)logger:(DHLoggerViewModel *)logger withAttributeString:(NSAttributedString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self appendAttributeLog:string];
        [self scrollToVisible];
    });
}

// MARK: - private method
- (void)appendLog:(NSString *)logString {
    static NSAttributedString *attributeString;
    static NSDictionary *attributes;
    if (!attributes) {
        attributes = @{NSForegroundColorAttributeName:[NSColor whiteColor]};
    }
    attributeString = [[NSAttributedString alloc] initWithString:logString attributes:attributes];
    [[self.loggerTextView textStorage] appendAttributedString:attributeString];
}

- (void)appendAttributeLog:(NSAttributedString *)logAttributeString {
    [[self.loggerTextView textStorage] appendAttributedString:logAttributeString];
}

- (void)scrollToVisible {
    if (!_enableAutoScrollBottom) { return ; }
    [self.loggerTextView scrollRangeToVisible:NSMakeRange([self.loggerTextView string].length, 0)];
}



// MARK: - event response
/// 清理已打印的日志
- (IBAction)cleanButtonAction:(id)sender {
    self.loggerTextView.string = @"";
}


// MARK: - getter
- (DHLoggerViewModel *)loggerViewModel {
    if (!_loggerViewModel) {
        _loggerViewModel = [[DHLoggerViewModel alloc] initWithViewController:self];
    }
    return _loggerViewModel;
}

@end
