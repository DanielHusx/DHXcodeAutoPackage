//
//  DHAlert.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHAlert : NSObject

+ (void)showInfoAlertWithTitle:(NSString *)title
                       message:(NSString *)message
                   doneHandler:(void (^ _Nullable)(void))doneHandler;

+ (void)showWarningAlertWithTitle:(NSString *)title
                          message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
