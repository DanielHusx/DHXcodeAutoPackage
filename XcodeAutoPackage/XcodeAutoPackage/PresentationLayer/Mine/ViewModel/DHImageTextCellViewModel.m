//
//  DHImageTextCellViewModel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHImageTextCellViewModel.h"

@interface DHImageTextCellViewModel ()

/// 图片名称
@property (nonatomic, copy) NSString *imageName;
/// 标题名称
@property (nonatomic, copy) NSString *stringValue;
/// 标识
@property (nonatomic, copy) NSNumber *identifier;

@end

@implementation DHImageTextCellViewModel

+ (instancetype)viewModelWithImageName:(NSString *)imageName
                           stringValue:(NSString *)stringValue
                            identifier:(NSNumber *)identifier {
    return [[DHImageTextCellViewModel alloc] initWithImageName:imageName stringValue:stringValue identifier:identifier];
}

- (instancetype)initWithImageName:(NSString *)imageName
                      stringValue:(NSString *)stringValue
                       identifier:(NSNumber *)identifier {
    self = [super init];
    if (self) {
        _imageName = imageName;
        _stringValue = stringValue;
        _identifier = identifier;
    }
    return self;
}

@end
