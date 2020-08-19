//
//  DHTaskCreatorDistributeItem.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/6.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskCreatorDistributeItem.h"
#import "DHTaskModel.h"
#import "DHTaskUtils.h"

@interface DHTaskCreatorDistributeItem () <NSComboBoxDataSource, NSComboBoxDelegate, NSTextDelegate>

@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSPopUpButton *platformPopupButton;
@property (weak) IBOutlet NSTextField *apiKeyTextField;
@property (weak) IBOutlet NSTextField *passwordTextField;
@property (unsafe_unretained) IBOutlet NSTextView *changeLogTextView;
@property (weak) IBOutlet NSComboBox *nicknameComboBox;

/// comboData
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation DHTaskCreatorDistributeItem


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}


#pragma mark - setup method
- (void)setupUI {
    [self.contentView creatorCellContentViewStyle];
    [self setupPlatfomPopUpButtonOptions];
}


- (void)setupDataSource:(NSArray *)dataSource {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:dataSource];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.nicknameComboBox reloadData];
    });
}
#pragma mark *** platformPopUpButton ***
- (void)setupPlatfomPopUpButtonOptions {
    [_platformPopupButton removeAllItems];
    [_platformPopupButton addItemsWithTitles:[DHTaskUtils distributionPlatformNameOptions]];
}

- (void)setupPlatformPopUpButtonSelectPlatform:(NSString *)platform {
    NSString *platformName = [DHTaskUtils convertDistributionPlatformToPlatformName:platform];
    [_platformPopupButton selectItemWithTitle:platformName];
}

- (NSString *)fetchPlatformPopUpButtonSelectedPlatform {
    NSString *platform = [DHTaskUtils convertDistributionPlatformNameToPlatform:self.platformPopupButton.titleOfSelectedItem];
    return platform;
}

#pragma mark - event response

// 分发平台选择
- (IBAction)platformAction:(NSPopUpButton *)sender {
    [_delegate distributeCell:self
           didChangedPlatform:[self fetchPlatformPopUpButtonSelectedPlatform]];
}

- (IBAction)nicknameAction:(NSComboBox *)sender {
    [_delegate distributeCell:self didChangedNickname:sender.stringValue];
}
- (IBAction)apiKeyAction:(NSTextField *)sender {
    [_delegate distributeCell:self didChangedAPIKey:sender.stringValue];
}
- (IBAction)installPasswordAction:(NSTextField *)sender {
    [_delegate distributeCell:self didChangedInstallPassword:sender.stringValue];
}

#pragma mark - NSComboBoxDataSource, NSComboBoxDelegate
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox {
    return [self.dataSource count];
}

- (id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index {
    return self.dataSource[index];
}

#pragma mark - NSTextViewDelegate
- (void)textDidEndEditing:(NSNotification *)notification {
    if (notification.object == self.changeLogTextView) {
        [_delegate distributeCell:self didChangedChangeLog:self.changeLogTextView.string];
    }
}

- (void)textDidChange:(NSNotification *)notification {
    if (notification.object == self.changeLogTextView) {
        [_delegate distributeCell:self didChangedChangeLog:self.changeLogTextView.string];
    }
}

#pragma mark - DHCellProtocol
+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

+ (void)registerByView:(NSView *)view {
    [((NSCollectionView *)view) registerNib:[[NSNib alloc] initWithNibNamed:NSStringFromClass([self class]) bundle:nil]
                      forItemWithIdentifier:[self reuseIdentifier]];
}

+ (instancetype)cellWithCollectionView:(NSCollectionView *)collectionView
                             indexPath:(NSIndexPath *)indexPath
                                target:(nonnull id)target {
    DHTaskCreatorDistributeItem *cell = [collectionView makeItemWithIdentifier:[self reuseIdentifier]
                                     forIndexPath:indexPath];
    cell.delegate = target;
    return cell;
}

+ (CGFloat)cellHeight {
    return 221.f;
}

+ (NSSize)cellSizeWithWidth:(CGFloat)width {
    return CGSizeMake(width, [self cellHeight]);
}


#pragma mark - getter & setter
- (void)setRepresentedObject:(DHTaskModel *)representedObject {
    [self setupPlatformPopUpButtonSelectPlatform:representedObject.currentDistributionPlatformType];
    
    BOOL workable = [DHTaskUtils checkDistributionPlatformValid:representedObject.currentDistributionPlatformType];
    
    self.nicknameComboBox.enabled = workable;
    self.nicknameComboBox.stringValue = representedObject.currentDistributionNickname?:@"";
    
    self.apiKeyTextField.enabled = workable;
    self.apiKeyTextField.stringValue = representedObject.currentDistributionPlatformApiKey?:@"";
    
    BOOL passwordSupportable = [DHTaskUtils checkDistributionInstallPasswordSupportableWithPlatform:representedObject.currentDistributionPlatformType];
    self.passwordTextField.enabled = workable && passwordSupportable;
    self.passwordTextField.stringValue = !passwordSupportable?@"":(representedObject.currentDistributionInstallPassword?:@"");
    
    self.changeLogTextView.editable = workable;
    self.changeLogTextView.string = representedObject.currentDistributionChangeLog?:@"";
    
    [self setupDataSource:representedObject.distributionNicknameOptions];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
