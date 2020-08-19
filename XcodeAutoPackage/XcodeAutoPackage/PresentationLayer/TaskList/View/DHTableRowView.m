//
//  DHTableRowView.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/27.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTableRowView.h"

@interface DHTableRowView ()
/// 编辑
@property (nonatomic, strong) NSButton *editButton;
/// 删除
@property (nonatomic, strong) NSButton *deleteButton;
/// 监听
@property (nonatomic, strong) NSTrackingArea *mouseTrackArea;
/// 校验按钮
@property (nonatomic, strong) NSButton *checkButton;

@end

@implementation DHTableRowView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if (![self.trackingAreas containsObject:self.mouseTrackArea]) {
        [self addTrackingArea:self.mouseTrackArea];
    }
    if (!self.editButton.superview) {
        [self addSubview:self.editButton];
        _editButton.hidden = YES;
    }
    if (!self.deleteButton.superview) {
        [self addSubview:self.deleteButton];
        _deleteButton.hidden = YES;
    }
    if (!self.checkButton.superview) {
        [self addSubview:self.checkButton];
    }
    CGRect firstColumnRect = ((NSView *)[self viewAtColumn:0]).frame;
    CGRect columnRect = ((NSView *)[self viewAtColumn:self.numberOfColumns-1]).frame;
    CGRect rect = CGRectZero;
    
    rect.size.width = 14.f;
    rect.size.height = 14.f;
    rect.origin.x = CGRectGetMinX(firstColumnRect) + 5.f;
    rect.origin.y = CGRectGetMinY(firstColumnRect) + (CGRectGetHeight(firstColumnRect) - rect.size.height) /2.f;
    _checkButton.frame = rect;
    
    rect.size.width = 30.f;
    rect.size.height = 30.f;
    rect.origin.x = CGRectGetMaxX(columnRect) - rect.size.width;
    rect.origin.y = CGRectGetMinY(columnRect) + (CGRectGetHeight(dirtyRect) - rect.size.height) /2.f;
    _deleteButton.frame = rect;
    
    rect.origin.x = CGRectGetMinX(_deleteButton.frame) - rect.size.width;
    _editButton.frame = rect;
    
}

- (void)mouseExited:(NSEvent *)event {
    [self switchButtonHidden:YES];
    
    if (self.isSelected) { return ; }
    self.backgroundColor = [NSColor clearColor];
}

- (void)mouseEntered:(NSEvent *)event {
    [self switchButtonHidden:NO];
    
    if (self.isSelected) { return ; }
    self.backgroundColor = [NSColor colorNamed:@"mouseover_color"];
   
}

- (void)switchButtonHidden:(BOOL)hidden {
    self.editButton.hidden = hidden;
    self.deleteButton.hidden = hidden;
}

- (void)editButtonAction:(NSButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDHRowModifyNotificationName
                                                        object:@(self.rowIndex)];
}

- (void)deleteButtonAction:(NSButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDHRowDeleteNotificationName
                                                        object:[NSIndexSet indexSetWithIndex:self.rowIndex]];
}

- (void)checkButtonAction:(NSButton *)sender {
    BOOL selected = converStateToBoolean(sender.state);
    // 直接设置self.selected，会造成tableView选中状态未更新，从而再次通过点击cell会没有效果
    [[NSNotificationCenter defaultCenter] postNotificationName:kDHRowSelectNotificationName
                                                        object:@(self.rowIndex)
                                                      userInfo:@{@"selected":@(selected),
                                                                 @"isAll":@(NO)}];
}



// MARK: getters & setters
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.checkButton.state = converBooleanToState(selected);
}

- (NSButton *)editButton {
    if (!_editButton) {
        _editButton = [NSButton buttonWithImage:[NSImage imageNamed:@"NSTouchBarComposeTemplate"]
                                         target:self
                                         action:@selector(editButtonAction:)];
        
        _editButton.imageScaling = NSImageScaleProportionallyDown;
        _editButton.bordered = NO;
    }
    return _editButton;
}

- (NSButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [NSButton buttonWithImage:[NSImage imageNamed:@"NSTouchBarDeleteTemplate"]
                                           target:self
                                           action:@selector(deleteButtonAction:)];
        _deleteButton.imageScaling = NSImageScaleProportionallyDown;
        _deleteButton.bordered = NO;
    }
    return _deleteButton;
}

- (NSButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [NSButton checkboxWithTitle:@""
                                            target:self
                                            action:@selector(checkButtonAction:)];
    }
    return _checkButton;
}
- (NSTrackingArea *)mouseTrackArea {
    if (!_mouseTrackArea) {
        // 监听鼠标进入离开
        _mouseTrackArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                            options:NSTrackingMouseEnteredAndExited
                                | NSTrackingActiveInKeyWindow
                                                              owner:self
                                                           userInfo:nil];
    }
    return _mouseTrackArea;
}


@end
