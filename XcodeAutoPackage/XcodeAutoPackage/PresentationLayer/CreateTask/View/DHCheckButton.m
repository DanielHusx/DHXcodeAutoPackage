//
//  DHCheckButton.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/20.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHCheckButton.h"

@implementation DHCheckButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setState:(NSControlStateValue)state {
    if (state == NSControlStateValueOn) {
        [self setImage:[NSImage imageNamed:@"NSMenuOnStateTemplate"]];
        
    } else {
        [self setImage:nil];
    }
    [super setState:state];
    
}

- (NSString *)toolTip {
    return @"打钩代表你懂的";
}

- (BOOL)isDh_selected {
    return self.state == NSControlStateValueOn;
}

- (void)setDh_selected:(BOOL)dh_selected {
    if (dh_selected) {
        self.state = NSControlStateValueOn;
    } else {
        self.state = NSControlStateValueOff;
    }
}

@end
