//
//  DHCheckButton.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/20.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHCheckButton : NSButton
/// 选择困难症
@property (nonatomic, assign, getter=isDh_selected) BOOL dh_selected;

@end

NS_ASSUME_NONNULL_END
