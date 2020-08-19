//
//  DHMineViewModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHMineViewModel : NSObject

/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

/// 初始化
- (instancetype)initWithViewController:(NSViewController *)viewController;
/// 获取显示数据数据
- (id)objectValueForIdentifier:(NSString *)identifier row:(NSInteger)row;
/// 获取标识数据
- (id)objectValueForIdentifierAtRow:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
