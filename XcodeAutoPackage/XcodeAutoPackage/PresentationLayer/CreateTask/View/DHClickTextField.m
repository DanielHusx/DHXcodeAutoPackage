//
//  DHClickTextField.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/20.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHClickTextField.h"

@implementation DHClickTextField

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    // 点击事件执行
    if (self.action && self.target) {
        if (![self.target respondsToSelector:self.action]) { return ; }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.action withObject:self];
#pragma clang diagnostic pop
    }
}

@end
