//
//  DHMineViewModel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHMineViewModel.h"
#import "DHImageTextCellViewModel.h"

@interface DHMineViewModel ()

/// 关联控制器
@property (nonatomic, weak) NSViewController *viewController;

@end

@implementation DHMineViewModel

- (instancetype)initWithViewController:(NSViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
        [self setupData];
    }
    return self;
}

- (void)setupData {
    [@[
        @{
            @"image":@"NSListViewTemplate",
            @"text":@"All Task",
            @"identifier":@(DHFilterConditionAll)
        },
        @{
            @"image":@"project_icon",
            @"text":@"Only Project Task",
            @"identifier":@(DHFilterConditionProjectOnly)
        },
        @{
            @"image":@"archive_icon",
            @"text":@"Only Archive Task",
            @"identifier":@(DHFilterConditionArchiveOnly)
        },
        @{
            @"image":@"ipa_icon",
            @"text":@"Only IPA Task",
            @"identifier":@(DHFilterConditionIPAOnly)
        },
    ] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DHImageTextCellViewModel *model = [DHImageTextCellViewModel viewModelWithImageName:obj[@"image"]
                                                                               stringValue:obj[@"text"]
                                                                                identifier:obj[@"identifier"]];
        [self.dataSource addObject:model];
    }];
}

- (id)objectValueForIdentifier:(NSString *)identifier row:(NSInteger)row {
    return self.dataSource[row];
}

- (id)objectValueForIdentifierAtRow:(NSInteger)row {
    DHImageTextCellViewModel *model = self.dataSource[row];
    return [model valueForKeyPath:@"identifier"];
}

// MARK: - getters
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:4];
    }
    return _dataSource;
}


@end
