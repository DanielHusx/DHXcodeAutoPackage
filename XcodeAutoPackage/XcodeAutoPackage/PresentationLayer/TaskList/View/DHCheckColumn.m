//
//  DHCheckColumn.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHCheckColumn.h"
#import "DHCheckColumnHeaderCell.h"

@interface DHCheckColumn ()

@end

@implementation DHCheckColumn

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSUserInterfaceItemIdentifier)identifier {
    self = [super initWithIdentifier:identifier];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (void)commonSetup {
    // 设置自定义的cell
    self.headerCell = [[DHCheckColumnHeaderCell alloc] initTextCell:@"NAME"];
}


@end
