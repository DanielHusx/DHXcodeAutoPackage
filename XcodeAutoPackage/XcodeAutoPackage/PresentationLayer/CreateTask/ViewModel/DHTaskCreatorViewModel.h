//
//  DHTaskCreatorViewModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/23.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@class DHTaskModel;
NS_ASSUME_NONNULL_BEGIN
/**
 承载创建任务所有业务逻辑
 */
@interface DHTaskCreatorViewModel : NSObject

- (instancetype)initWithViewController:(NSViewController *)viewController
                              callback:(void (^)(DHTaskModel *task))callback;

- (void)createTask;

@end

NS_ASSUME_NONNULL_END
