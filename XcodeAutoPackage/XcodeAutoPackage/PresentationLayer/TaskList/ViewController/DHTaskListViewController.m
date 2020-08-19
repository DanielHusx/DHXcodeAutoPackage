//
//  DHTaskListViewController.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/14.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskListViewController.h"
#import "DHTableRowView.h"
#import "DHCheckColumn.h"
#import "DHCheckCellView.h"
#import "DHTextCellView.h"
#import "DHTaskListViewModel.h"
#import "DHTableHeaderView.h"

@interface DHTaskListViewController () <NSTableViewDataSource,
NSTableViewDelegate,
DHTaskListViewModelDelegate,
NSWindowDelegate>
/// tableView
@property (weak) IBOutlet NSTableView *tableView;
/// viewModel
@property (nonatomic, strong) DHTaskListViewModel *viewModel;

@end

@implementation DHTaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 监听通知
    [self addNotfications];
}


// MARK: - notification methods
- (void)addNotfications {
    // 监听rowView选择状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedRowSelectNotify:)
                                                 name:kDHRowSelectNotificationName
                                               object:nil];
    // 监听删除已选择的任务
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedDeleteNotify:)
                                                 name:kDHToolbarDeleteNotificationName
                                               object:nil];
    // 监听执行已选择的任务
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedRunNotify:)
                                                 name:kDHToolbarRunNotificationName
                                               object:nil];
    // 监听手动改变window尺寸
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedWindowDidResizeNotify:)
                                                 name:NSWindowDidResizeNotification
                                               object:nil];
    // 监听弹出window
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedWindowWillBeginSheetNotify:)
                                                 name:NSWindowWillBeginSheetNotification
                                               object:nil];
}

- (void)receivedWindowWillBeginSheetNotify:(NSNotification *)sender {
    if (sender.object == self.view.window) {
        [self setupTableHeaderViewSelected:NO];
    }
}

- (void)receivedRowSelectNotify:(NSNotification *)sender {
    NSInteger row = sender.object?[sender.object integerValue]:0;
    BOOL selected = [sender.userInfo[@"selected"] boolValue];
    BOOL isAll = [sender.userInfo[@"isAll"] boolValue];
    
    [self tableViewDidSelect:selected rowAtIndex:row isAll:isAll];
}

- (void)receivedDeleteNotify:(NSNotification *)sender {
    NSIndexSet *selectedRows = self.tableView.selectedRowIndexes;
    [self.viewModel deleteTaskAtIndexSet:selectedRows];
}

- (void)receivedRunNotify:(NSNotification *)sender {
    NSIndexSet *selectedRows = self.tableView.selectedRowIndexes;
    [self.viewModel executeTaskAtIndexSet:selectedRows];
}

- (void)receivedWindowDidResizeNotify:(NSNotification *)sender {
    // window改变尺寸，如果不刷新tableView视图将导致rowView识别区域还是改变size之前的区域
    [self.tableView reloadData];
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
    DHTableRowView *rowView = [tableView makeViewWithIdentifier:@"listRowView" owner:self];
    if (!rowView) {
        rowView = [[DHTableRowView alloc] init];
        rowView.identifier = @"listRowView";
    }
    rowView.rowIndex = row;
    return rowView;
}

- (CGFloat)tableView:(NSTableView *)tableView
         heightOfRow:(NSInteger)row {
    return 50.f;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    // 是否全选
    BOOL selectAll = self.tableView.numberOfSelectedRows == self.tableView.numberOfRows;
    [self setupTableHeaderViewSelected:selectAll];
}


// MARK: - DHTaskListViewModelDelegate
- (void)reloadData {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself setupTableHeaderViewSelected:NO];
        [weakself.tableView reloadData];
    });
}

- (void)reloadDataAtRowIndexSet:(NSIndexSet *)rowIndexSet {
    NSIndexSet *columnIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tableView.numberOfColumns)];
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.tableView reloadDataForRowIndexes:rowIndexSet columnIndexes:columnIndexSet];
    });
}


// MARK: - private method
- (void)tableViewDidSelect:(BOOL)select rowAtIndex:(NSInteger)row isAll:(BOOL)isAll {
    if (isAll) {
        // 全选
        if (select) {
            [self.tableView selectAll:nil];
        } else {
            [self.tableView deselectAll:nil];
        }
        return ;
    }
    // 单选
    if (select) {
        [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    } else {
        [self.tableView deselectRow:row];
    }
    
}

/// 全选状态同步改变表格顶部的check按钮的选择状态——YES: 全选；NO: 未全选
- (void)setupTableHeaderViewSelected:(BOOL)selected {
    [((DHTableHeaderView *)self.tableView.headerView) setSelected:selected];
}


// MARK: - getter
- (DHTaskListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[DHTaskListViewModel alloc] initWithViewController:self];
        _viewModel.delegate = self;
    }
    return _viewModel;
}



@end
