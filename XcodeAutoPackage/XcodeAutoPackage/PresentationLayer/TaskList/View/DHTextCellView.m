//
//  DHTextCellView.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/16.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTextCellView.h"

@implementation DHTextCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setObjectValue:(NSString *)objectValue {
    self.textField.stringValue = objectValue?:@"";
}

@end
