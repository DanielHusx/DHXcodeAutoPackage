//
//  DHLoggerViewModel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/18.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHLoggerViewModel.h"
#import "DHLogger.h"

@interface DHLoggerViewModel () <DHLoggerDelegate>
/// 控制器
@property (nonatomic, weak) NSViewController *viewController;

@end
@implementation DHLoggerViewModel

- (instancetype)initWithViewController:(NSViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
        [self setupData];
    }
    return self;
}

- (void)setupData {
    _delegate = (id<DHLoggerViewModelDelegate>)_viewController;
    
    [DHLogger shareLogger].delegate = self;
}


// MARK: - DHLoggerDelegate
- (void)logger:(DHLogger *)logger withAttributeString:(NSAttributedString *)attributeString {
    [_delegate logger:self withAttributeString:attributeString];
}

- (void)logger:(DHLogger *)logger withString:(NSString *)string {
    [_delegate logger:self withString:string];
}


@end
