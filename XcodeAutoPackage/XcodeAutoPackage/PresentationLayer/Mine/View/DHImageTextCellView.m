//
//  DHImageTextCellView.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHImageTextCellView.h"

@implementation DHImageTextCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


- (void)setObjectValue:(id)objectValue {
    NSString *imageName = [objectValue valueForKeyPath:@"imageName"];
    self.imageView.image = [NSImage imageNamed:imageName];
    NSString *stringValue = [objectValue valueForKeyPath:@"stringValue"];
    self.textField.stringValue = stringValue?:@"";
}
@end
