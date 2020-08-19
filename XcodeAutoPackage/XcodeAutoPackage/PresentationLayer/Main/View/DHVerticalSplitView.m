//
//  DHVerticalSplitView.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/21.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHVerticalSplitView.h"

@interface DHVerticalSplitView ()
/// 折叠按钮
@property (nonatomic, strong) NSButton *collapseButton;
/// 调试按钮
@property (nonatomic, strong) NSButton *verboseButton;
/// 折叠标识
@property (nonatomic, assign, getter=isCollapse) BOOL collapse;

@end

@implementation DHVerticalSplitView

// MARK: - public method
- (CGFloat)effectiveWidth {
    return CGRectGetMaxX(self.verboseButton.frame);
}


// MARK: - override method
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [self addSubview:self.collapseButton];
    [self addSubview:self.verboseButton];
}

/// 绘制分割区域
- (void)drawDividerInRect:(NSRect)rect {
    [super drawDividerInRect:rect];
    
    CGRect cRect = rect;
    cRect.origin.x = 5.f;
    cRect.origin.y = CGRectGetMinY(rect);
    cRect.size.width = CGRectGetHeight(rect);
    cRect.size.height = cRect.size.width;
    self.collapseButton.frame = cRect;
    
    cRect.origin.x = CGRectGetMaxX(self.collapseButton.frame) + 5.f;
    self.verboseButton.frame = cRect;
    
    [self checkToCollapse];
}

/// 分割区域的高度
- (CGFloat)dividerThickness {
    return 25.f;
}

- (NSColor *)dividerColor {
    return [NSColor clearColor];
}

// FIXME: 设置无效
- (CGFloat)minPossiblePositionOfDividerAtIndex:(NSInteger)dividerIndex {
    return 200.f;
}

// FIXME: 设置无效
- (CGFloat)maxPossiblePositionOfDividerAtIndex:(NSInteger)dividerIndex {
    return 300.f;
}

// MARK: - private method
- (void)setupCollapseButtonForCollapse:(BOOL)collapse {
    if (collapse) {
        _collapseButton.toolTip = @"Show the Debug Area";
        [_collapseButton setImage:[self uncollapseImage]];
    } else {
        _collapseButton.toolTip = @"Hide the Debug Area";
        [_collapseButton setImage:[self collapseImage]];
    }
}

- (void)setupVerboseButtonForVerbose:(BOOL)verbose {
    if (verbose) {
        _verboseButton.toolTip = @"Activate Verbose";
        [_verboseButton setImage:[self verboseEnableImage]];
    } else {
        _verboseButton.toolTip = @"Deactivate Verbose";
        [_verboseButton setImage:[self verboseDisableImage]];
    }
}

- (void)setupPositionForCollapse:(BOOL)collapse  {
    if (collapse) {
        [self setPosition:(CGRectGetHeight(self.bounds) - 25.f) ofDividerAtIndex:0];
    } else {
        [self setPosition:(CGRectGetHeight(self.bounds) - 100.f) ofDividerAtIndex:0];
    }
}

- (void)checkToCollapse {
    self.collapse = [self isSubviewCollapsed:self.arrangedSubviews[[self indexOfCollapseView]]];
}

- (NSUInteger)indexOfCollapseView {
    return [self.arrangedSubviews count] - 1;
}


// MARK: - event response
- (void)collapseButtonDidClick:(NSButton *)sender {
    self.collapse = !self.isCollapse;
    // 执行collapse事件
    [_verticalSplitViewDelegate splitView:self
                           shouldCollapse:self.isCollapse
                                  atIndex:[self indexOfCollapseView]];
    // 然后设置位置才会触发draw事件更新视图
    [self setupPositionForCollapse:self.collapse];
}

- (void)verboseButtonDidClick:(NSButton *)sender {
    BOOL verbose = ![DHLogger shareLogger].verbose;
    [[DHLogger shareLogger] setVerbose:verbose];
    [self setupVerboseButtonForVerbose:verbose];
}


// MARK: - getters & setter
- (NSButton *)collapseButton {
    if (!_collapseButton) {
        _collapseButton = [NSButton buttonWithImage:[self collapseImage]
                                             target:self
                                             action:@selector(collapseButtonDidClick:)];
        _collapseButton.bordered = NO;
        _collapseButton.imagePosition = NSImageOnly;
        [self setupCollapseButtonForCollapse:self.collapse];
    }
    return _collapseButton;
}

/// 未折叠时的图片
- (NSImage *)collapseImage {
    static NSImage *collapseImage;
    if (!collapseImage) {
        collapseImage = [NSImage imageNamed:@"collapse"];
    }
    return collapseImage;
}

/// 折叠时的图片
- (NSImage *)uncollapseImage {
    static NSImage *uncollapseImage;
    if (!uncollapseImage) {
        uncollapseImage = [NSImage imageNamed:@"uncollapse"];
    }
    return uncollapseImage;
}

- (void)setCollapse:(BOOL)collapse {
    if (_collapse == collapse) { return ; }
    _collapse = collapse;
    // 统一设置按钮折叠状态
    [self setupCollapseButtonForCollapse:collapse];
}

- (NSImage *)verboseEnableImage {
    static NSImage *verboseEnableImage;
    if (!verboseEnableImage) {
        verboseEnableImage = [NSImage imageNamed:@"verbose_enable"];
    }
    return verboseEnableImage;
}

- (NSImage *)verboseDisableImage {
    static NSImage *verboseDisableImage;
    if (!verboseDisableImage) {
        verboseDisableImage = [NSImage imageNamed:@"verbose_disable"];
    }
    return verboseDisableImage;
}

- (NSButton *)verboseButton {
    if (!_verboseButton) {
        _verboseButton = [NSButton buttonWithImage:[self verboseDisableImage]
                                             target:self
                                             action:@selector(verboseButtonDidClick:)];
        _verboseButton.bordered = NO;
        _verboseButton.imagePosition = NSImageOnly;
        [self setupVerboseButtonForVerbose:[DHLogger shareLogger].verbose];
    }
    return _verboseButton;
}

@end
