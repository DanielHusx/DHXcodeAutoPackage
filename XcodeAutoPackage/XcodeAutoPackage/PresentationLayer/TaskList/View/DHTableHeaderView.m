//
//  DHTableHeaderView.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/16.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTableHeaderView.h"

@interface DHTableHeaderView ()

/// 全选按钮
@property (nonatomic, strong) NSButton *checkButton;

@end

@implementation DHTableHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.checkButton];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    CGRect checkColumn = [self headerRectOfColumn:0];
    _checkButton.frame = CGRectMake(CGRectGetMinX(checkColumn) + 5, CGRectGetMinY(checkColumn)+(CGRectGetHeight(checkColumn)-14.f)/2.f, 14, 14);
    self.layer.backgroundColor = [NSColor whiteColor].CGColor;
}

- (BOOL)wantsLayer {
    return YES;
}

- (void)checkButtonAction:(NSButton *)sender {
    BOOL selected = converStateToBoolean(sender.state);
    _selected = selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDHRowSelectNotificationName
                                                        object:nil
                                                      userInfo:@{@"selected":@(selected),
                                                                 @"isAll":@(YES)}];
}

- (NSButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [NSButton checkboxWithTitle:@""
                                            target:self
                                            action:@selector(checkButtonAction:)];
        _checkButton.imagePosition = NSImageOnly;
    }
    return _checkButton;
}

- (void)setSelected:(BOOL)selected {
    if (_selected == selected) { return ; }
    _selected = selected;
    self.checkButton.state = converBooleanToState(selected);
}

@end
