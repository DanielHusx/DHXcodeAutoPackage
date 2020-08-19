//
//  DHMineRowView.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHMineRowView.h"

@interface DHMineRowView ()

/// 监听
@property (nonatomic, strong) NSTrackingArea *mouseTrackArea;

@end

@implementation DHMineRowView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if (![self.trackingAreas containsObject:self.mouseTrackArea]) {
        [self addTrackingArea:self.mouseTrackArea];
    }
    
}

- (void)mouseExited:(NSEvent *)event {
    if (self.isSelected) { return ; }
    self.backgroundColor = [NSColor clearColor];
}

- (void)mouseEntered:(NSEvent *)event {
    if (self.isSelected) { return ; }
    self.backgroundColor = [NSColor colorNamed:@"mouseover_color"];
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

- (NSTableViewSelectionHighlightStyle)selectionHighlightStyle {
    return NSTableViewSelectionHighlightStyleNone;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundColor = [NSColor colorNamed:@"mouseover_color"];
        });
    } else {
        self.backgroundColor = [NSColor clearColor];
    }
}



@end
