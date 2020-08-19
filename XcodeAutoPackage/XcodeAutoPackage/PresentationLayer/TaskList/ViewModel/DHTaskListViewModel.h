//
//  DHTaskListViewModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/16.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DHTaskListViewModelDelegate;
@interface DHTaskListViewModel : NSObject

/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 代理
@property (nonatomic, weak) id<DHTaskListViewModelDelegate> delegate;

/// 初始化
- (instancetype)initWithViewController:(NSViewController *)viewController;

/// 获取显示数据数据
- (id)objectValueForIdentifier:(NSString *)identifier row:(NSInteger)row;
/// 删除indexset的数据
- (void)deleteTaskAtIndexSet:(NSIndexSet *)indexSet;
/// 执行indexset的数据
- (void)executeTaskAtIndexSet:(NSIndexSet *)indexSet;

@end

@protocol DHTaskListViewModelDelegate <NSObject>

- (void)reloadData;
- (void)reloadDataAtRowIndexSet:(NSIndexSet *)rowIndexSet;

@end

NS_ASSUME_NONNULL_END
