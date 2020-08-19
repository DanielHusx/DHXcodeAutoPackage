//
//  DHCheckCellView.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/16.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHCheckCellView.h"
#import "DHTaskModel.h"

@interface DHCheckCellView ()
/// 校验——弃用
@property (weak) IBOutlet NSButton *checkButton;

@end

@implementation DHCheckCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setObjectValue:(NSString *)objectValue {
    self.textField.stringValue = objectValue?:@"";
}

@end
