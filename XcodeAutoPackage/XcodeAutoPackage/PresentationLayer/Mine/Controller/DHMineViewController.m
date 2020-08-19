//
//  DHMineViewController.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHMineViewController.h"
#import "DHMineViewModel.h"
#import "DHMineRowView.h"

@interface DHMineViewController () <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
/// viewModel
@property (nonatomic, strong) DHMineViewModel *viewModel;

@end

@implementation DHMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

// MARK: - NSTableViewDataSource, NSTableViewDelegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.viewModel.dataSource.count;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    NSView *cellView = nil;
    cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    return cellView;
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row {
    return [self.viewModel objectValueForIdentifier:tableColumn.identifier
                                                row:row];
}

- (NSTableRowView *)tableView:(NSTableView *)tableView
                rowViewForRow:(NSInteger)row {
    DHMineRowView *rowView = [[DHMineRowView alloc] init];
    return rowView;
}

- (CGFloat)tableView:(NSTableView *)tableView
         heightOfRow:(NSInteger)row {
    return 40.f;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    id identifier = [self.viewModel objectValueForIdentifierAtRow:self.tableView.selectedRow];

    [[NSNotificationCenter defaultCenter] postNotificationName:kDHFilterConditionDidChangedNotificationName
                                                        object:identifier];
}

- (DHMineViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[DHMineViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

@end
