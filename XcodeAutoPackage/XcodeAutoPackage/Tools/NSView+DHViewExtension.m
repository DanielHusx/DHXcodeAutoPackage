//
//  NSView+DHViewExtension.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/8.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "NSView+DHViewExtension.h"

@implementation NSView (DHViewExtension)

- (void)creatorCellContentViewStyle {
    self.wantsLayer = YES;
    self.layer.borderColor = [NSColor grayColor].CGColor;
    self.layer.borderWidth = 2.f;
}

@end
