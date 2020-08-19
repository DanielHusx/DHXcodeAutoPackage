//
//  DHCheckColumnHeaderCell.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/16.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHCheckColumnHeaderCell.h"

@implementation DHCheckColumnHeaderCell

- (NSRect)drawingRectForBounds:(NSRect)rect {
    // 标题文字偏移
    return CGRectMake(24, rect.origin.y, rect.size.width, rect.size.height);
}


@end
