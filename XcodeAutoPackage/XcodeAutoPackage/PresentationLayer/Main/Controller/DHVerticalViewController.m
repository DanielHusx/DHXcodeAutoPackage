//
//  DHVerticalViewController.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/21.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHVerticalViewController.h"
#import "DHVerticalSplitView.h"

@interface DHVerticalViewController () <DHVerticalSplitViewDelegate>

@end

@implementation DHVerticalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    // 折叠视图自定义代理
    ((DHVerticalSplitView *)self.splitView).verticalSplitViewDelegate = self;
}


// MARK: - DHVerticalSplitViewDelegate
- (void)splitView:(DHVerticalSplitView *)splitView shouldCollapse:(BOOL)collapse atIndex:(NSInteger)index {
    NSSplitViewItem *item = self.splitViewItems[index];
    
    BOOL collapsed = !item.isCollapsed;
    item.collapsed = collapsed;
    [[item animator] setCollapsed:collapsed];
}


- (NSRect)splitView:(DHVerticalSplitView *)splitView
      effectiveRect:(NSRect)proposedEffectiveRect
       forDrawnRect:(NSRect)drawnRect
   ofDividerAtIndex:(NSInteger)dividerIndex {
    CGRect rect = [super splitView:splitView
                     effectiveRect:proposedEffectiveRect
                      forDrawnRect:drawnRect
                  ofDividerAtIndex:dividerIndex];
    rect.origin.x = [splitView effectiveWidth];
    return rect;
}


// MARK: - private method


@end
