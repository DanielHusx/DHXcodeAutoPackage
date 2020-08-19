//
//  DHImageTextCellViewModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHImageTextCellViewModel : NSObject

+ (instancetype)viewModelWithImageName:(NSString *)imageName
                           stringValue:(NSString *)stringValue
                            identifier:(NSNumber *)identifier;
@end

NS_ASSUME_NONNULL_END
