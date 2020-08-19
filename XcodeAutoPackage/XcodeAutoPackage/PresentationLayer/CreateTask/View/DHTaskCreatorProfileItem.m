//
//  DHTaskCreatorProfileItem.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/23.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskCreatorProfileItem.h"
#import "DHTaskModel.h"
#import "DHTaskUtils.h"

@interface DHTaskCreatorProfileItem ()

@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSPopUpButton *profilePopUpButton;
@property (weak) IBOutlet NSTextField *teamNameLabel;
@property (weak) IBOutlet NSTextField *appIdLabel;
@property (weak) IBOutlet NSTextField *createToExpireLabel;
@property (weak) IBOutlet NSTextField *expireDaysLabel;
@property (weak) IBOutlet NSTextField *channelLabel;
@property (weak) IBOutlet NSTextField *uuidLabel;
@property (weak) IBOutlet NSTextField *profilePathTextField;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation DHTaskCreatorProfileItem

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}


#pragma mark - setup method
- (void)setupUI {
    [self.contentView creatorCellContentViewStyle];
}

- (void)setupProfilePopUpButtonOptions:(NSArray *)options {
    [_profilePopUpButton removeAllItems];
    [_profilePopUpButton addItemsWithTitles:options];
}

- (void)setupChannelLabelWithChannel:(NSString *)channel {
    NSString *channelName = [DHTaskUtils convertChannelToChannelName:channel];
    _channelLabel.stringValue = channelName;
}

#pragma mark - DHCellProtocol
+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

+ (void)registerByView:(NSView *)view {
    [((NSCollectionView *)view) registerNib:[[NSNib alloc] initWithNibNamed:NSStringFromClass([self class]) bundle:nil] forItemWithIdentifier:[self reuseIdentifier]];
}

+ (instancetype)cellWithCollectionView:(NSCollectionView *)collectionView
                             indexPath:(NSIndexPath *)indexPath
                                target:(nonnull id)target {
    DHTaskCreatorProfileItem *cell = [collectionView makeItemWithIdentifier:[self reuseIdentifier]
                                     forIndexPath:indexPath];
    cell.delegate = target;
    return cell;
}

+ (CGFloat)cellHeight {
    return 258.f;
}

+ (NSSize)cellSizeWithWidth:(CGFloat)width {
    return CGSizeMake(width, [self cellHeight]);
}


#pragma mark - NSTextFieldDelegate
- (IBAction)profilePathAction:(NSComboBox *)sender {
    [_delegate profileCell:self
            didChangedPath:sender.stringValue];
}


#pragma mark - NSComboBoxDataSource, NSComboBoxDelegate
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox {
    return [self.dataSource count];
}

- (id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index {
    return self.dataSource[index];
}


// MARK: - event response
- (IBAction)profileNamePopUpButtonAction:(NSPopUpButton *)sender {
    [_delegate profileCell:self didChangedName:sender.titleOfSelectedItem];
}

- (IBAction)profileFilePathAction:(NSTextField *)sender {
    // 不给编辑
}

- (IBAction)chooseProfilePathAction:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = YES;
    openPanel.canChooseDirectories = NO;
    openPanel.allowsMultipleSelection = NO;
    openPanel.allowedFileTypes = @[@"mobileprovision"];
    [openPanel beginSheetModalForWindow:self.view.window
                      completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSString *path = [[openPanel URL] path];
            self.profilePathTextField.stringValue = path;
            [self.delegate profileCell:self didChangedPath:path];
        }
    }];
}



#pragma mark - getter & setter
- (void)setRepresentedObject:(DHTaskModel *)representedObject {
    self.profilePathTextField.stringValue = representedObject.currentProfilePath?:@"";
    
    [self setupProfilePopUpButtonOptions:representedObject.profileNameOptions];
    [self.profilePopUpButton selectItemWithTitle:representedObject.currentProfileName?:@""];
    
    [self setupChannelLabelWithChannel:representedObject.currentProfileChannel];
    
    self.teamNameLabel.stringValue = representedObject.currentProfileTeamName?:@"";
    self.appIdLabel.stringValue = representedObject.currentProfileAppId?:@"";
    self.expireDaysLabel.stringValue = representedObject.currentProfileExpireDays?:@"";
    self.createToExpireLabel.stringValue = representedObject.currentProfileCreatToExpireTime?:@"";
    self.uuidLabel.stringValue = representedObject.currentProfileUUID?:@"";
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
