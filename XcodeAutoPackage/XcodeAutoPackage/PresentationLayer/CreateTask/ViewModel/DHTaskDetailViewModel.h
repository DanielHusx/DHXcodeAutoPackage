//
//  DHTaskDetailViewModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/8.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class DHTaskModel;
@interface DHTaskDetailViewModel : NSObject

- (instancetype)initWithViewController:(NSViewController *)viewController;

- (void)showTask:(DHTaskModel *)task
        callback:(nonnull void (^)(DHTaskModel * _Nonnull))callback;

@end

NS_ASSUME_NONNULL_END
