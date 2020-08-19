//
//  NSArray+DHArrayExtension.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/16.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (DHArrayExtension)

- (id)safeObjectAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
