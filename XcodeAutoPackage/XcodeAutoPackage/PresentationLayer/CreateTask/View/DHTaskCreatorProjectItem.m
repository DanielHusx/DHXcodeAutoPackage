//
//  DHTaskCreatorProjectItem.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/23.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskCreatorProjectItem.h"
#import "DHTaskModel.h"
#import "DHCheckButton.h"
#import "DHTaskUtils.h"

@interface DHTaskCreatorProjectItem () <NSTextFieldDelegate>

@property (weak) IBOutlet NSPopUpButton *xcodeprojPopupButton;
/// 现在是displayName
@property (weak) IBOutlet NSTextField *productNameTextField;
@property (weak) IBOutlet NSPopUpButton *schemePopUpButton;
@property (weak) IBOutlet NSPopUpButton *teamPopUpButton;
@property (weak) IBOutlet NSTextField *bundleIdTextField;
@property (weak) IBOutlet NSTextField *versionTextField;
@property (weak) IBOutlet NSTextField *buildTextField;
@property (weak) IBOutlet NSPopUpButton *enableBitcodePopUpButton;
@property (weak) IBOutlet NSPopUpButton *configurationPopUpButton;
@property (weak) IBOutlet NSPopUpButton *channelPopUpButton;
@property (weak) IBOutlet NSView *contentView;

@property (weak) IBOutlet NSTextField *ipaDirTextField;
@property (weak) IBOutlet NSTextField *ipaFileLabel;
@property (weak) IBOutlet NSSwitch *keepXcarchiveSwitch;

@property (weak) IBOutlet NSTextField *archiveDirTextField;
@property (weak) IBOutlet NSTextField *archiveFileLabel;

@property (weak) IBOutlet DHCheckButton *displayNameForceButton;
@property (weak) IBOutlet DHCheckButton *enableBitcodeForceButton;
@property (weak) IBOutlet DHCheckButton *buildVersionForceButton;
@property (weak) IBOutlet DHCheckButton *versionForceButton;
@property (weak) IBOutlet DHCheckButton *bundleIdForceButton;
@property (weak) IBOutlet DHCheckButton *teamForceButton;

@end

@implementation DHTaskCreatorProjectItem

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}


#pragma mark - setup methods
- (void)setupUI {
    [self.contentView creatorCellContentViewStyle];
}

- (void)setupSchemeOptions:(NSArray *)options {
    [_schemePopUpButton removeAllItems];
    [_schemePopUpButton addItemsWithTitles:options];
}

- (void)setupTeamOptions:(NSArray *)options {
    [_teamPopUpButton removeAllItems];
    [_teamPopUpButton addItemsWithTitles:options];
}

- (void)setupEnableBitcodeOptions:(NSArray *)options {
    [_enableBitcodePopUpButton removeAllItems];
    [_enableBitcodePopUpButton addItemsWithTitles:options];
}

- (void)setupChannelOptions:(NSArray *)options {
    [_channelPopUpButton removeAllItems];
    [_channelPopUpButton addItemsWithTitles:options];
}

- (void)setupChannelPopUpButtonSelectChannel:(NSString *)channel {
    NSString *channelName = [DHTaskUtils convertChannelToChannelName:channel];
    [_channelPopUpButton selectItemWithTitle:channelName];
}

- (NSString *)fetchChannelPopUpButtonSelectedChannel {
    NSString *channel = [DHTaskUtils convertChannelNameToChannel:self.channelPopUpButton.titleOfSelectedItem];
    return channel;
}

- (void)setupConfigurationOptions:(NSArray *)options {
    [_configurationPopUpButton removeAllItems];
    [_configurationPopUpButton addItemsWithTitles:options];
}

- (void)setupXcodeprojOptions:(NSArray *)options {
    [_xcodeprojPopupButton removeAllItems];
    [_xcodeprojPopupButton addItemsWithTitles:options];
}


#pragma mark - NSTextFieldDelegate
- (void)controlTextDidEndEditing:(NSNotification *)obj {
    NSTextField *view = obj.object;
    if (view == self.productNameTextField) {
        [_delegate projectCell:self didChangedDisplayName:self.productNameTextField.stringValue];
    } else if (view == self.bundleIdTextField) {
        [_delegate projectCell:self didChangedBundleId:self.bundleIdTextField.stringValue];
    } else if (view == self.versionTextField) {
        [_delegate projectCell:self didChangedVersion:self.versionTextField.stringValue];
    } else if (view == self.buildTextField) {
        [_delegate projectCell:self didChangedBuild:self.buildTextField.stringValue];
    } else if (view == self.archiveDirTextField) {
        [_delegate projectCell:self didChangedArchiveDir:self.archiveDirTextField.stringValue];
    } else if (view == self.ipaDirTextField) {
        [_delegate projectCell:self didChangedIPADir:self.ipaDirTextField.stringValue];
    }
    
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
    DHTaskCreatorProjectItem *cell = [collectionView makeItemWithIdentifier:[self reuseIdentifier]
                                     forIndexPath:indexPath];
    cell.delegate = target;
    return cell;
}

+ (CGFloat)cellHeight {
    return 440.f;
}

+ (NSSize)cellSizeWithWidth:(CGFloat)width {
    return CGSizeMake(width, [self cellHeight]);
}


#pragma mark - event response
// 选择EnableBitcode
- (IBAction)enableBitcodeAction:(NSPopUpButton *)sender {
    [_delegate projectCell:self didChangedEnableBitcode:sender.titleOfSelectedItem];
}

// 选择scheme
- (IBAction)schemeAction:(NSPopUpButton *)sender {
    [_delegate projectCell:self didChangedScheme:sender.titleOfSelectedItem];
}

// 选择team
- (IBAction)teamAction:(NSPopUpButton *)sender {
    [_delegate projectCell:self didChangedTeam:sender.titleOfSelectedItem];
}

// 选择channel
- (IBAction)channelAction:(NSPopUpButton *)sender {
    [_delegate projectCell:self didChangedChannel:[self fetchChannelPopUpButtonSelectedChannel]];
}

// 选择configuration
- (IBAction)configurationAction:(NSPopUpButton *)sender {
    [_delegate projectCell:self didChangedConfiguration:sender.selectedItem.title];
}

// 保留.xcarchive
- (IBAction)keepXcarchiveAction:(NSSwitch *)sender {
    [_delegate projectCell:self didChangedKeepXcarchive:sender.state==NSControlStateValueOn];
}

// 选择xcodeproj路径
- (IBAction)xcodeprojAction:(NSPopUpButton *)sender {
    [_delegate projectCell:self didChangedXcodeprojFile:sender.titleOfSelectedItem];
}

// archive选择路径
- (IBAction)archiveChooseDirAction:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = NO;
    openPanel.canChooseDirectories = YES;
    openPanel.allowsMultipleSelection = NO;
    [openPanel beginSheetModalForWindow:self.view.window
                      completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSString *path = [[openPanel URL] path];
            self.archiveDirTextField.stringValue = path;
            [self.delegate projectCell:self didChangedArchiveDir:path];
        }
    }];
}

// ipa选择路径
- (IBAction)ipaChooseDirAction:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = NO;
    openPanel.canChooseDirectories = YES;
    openPanel.allowsMultipleSelection = NO;
    [openPanel beginSheetModalForWindow:self.view.window
                      completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSString *path = [[openPanel URL] path];
            self.ipaDirTextField.stringValue = path;
            [self.delegate projectCell:self didChangedIPADir:path];
        }
    }];
}

- (IBAction)displayNameLabelDidClick:(id)sender {
    self.displayNameForceButton.dh_selected = !self.displayNameForceButton.isDh_selected;
    [_delegate projectCell:self didChangedDisplayNameForceSet:self.displayNameForceButton.isDh_selected];
}

- (IBAction)teamLabelDidClick:(id)sender {
    self.teamForceButton.dh_selected = !self.teamForceButton.isDh_selected;
    [_delegate projectCell:self didChangedTeamIdForceSet:self.teamForceButton.isDh_selected];
}

- (IBAction)bundleIdLabelDidClick:(id)sender {
    self.bundleIdForceButton.dh_selected = !self.bundleIdForceButton.isDh_selected;
    [_delegate projectCell:self didChangedBundlIdForceSet:self.bundleIdForceButton.isDh_selected];
}

- (IBAction)versionLabelDidClick:(id)sender {
    self.versionForceButton.dh_selected = !self.versionForceButton.isDh_selected;
    [_delegate projectCell:self didChangedVersionForceSet:self.versionForceButton.isDh_selected];
}

- (IBAction)buildVersionLabelDidClick:(id)sender {
    self.buildVersionForceButton.dh_selected = !self.buildVersionForceButton.isDh_selected;
    [_delegate projectCell:self didChangedBuildVersionForceSet:self.buildVersionForceButton.isDh_selected];
}

- (IBAction)enableBitcodeLabelDidClick:(id)sender {
    self.enableBitcodeForceButton.dh_selected = !self.enableBitcodeForceButton.isDh_selected;
    [_delegate projectCell:self didChangedEnableBitcodeForceSet:self.enableBitcodeForceButton.isDh_selected];
}


#pragma mark - setter & getter
- (void)setRepresentedObject:(DHTaskModel *)representedObject {
    self.productNameTextField.stringValue = representedObject.currentDisplayName?:@"";
    self.bundleIdTextField.stringValue = representedObject.currentBundleId?:@"";
    self.versionTextField.stringValue = representedObject.currentVersion?:@"";
    self.buildTextField.stringValue = representedObject.currentBuildVersion?:@"";
    
    self.displayNameForceButton.dh_selected = representedObject.isForceSetDisplayName;
    self.teamForceButton.dh_selected = representedObject.isForceSetTeamId;
    self.bundleIdForceButton.dh_selected = representedObject.isForceSetBundleId;
    self.versionForceButton.dh_selected = representedObject.isForceSetVersion;
    self.buildVersionForceButton.dh_selected = representedObject.isForceSetBuildVersion;
    self.enableBitcodeForceButton.dh_selected = representedObject.isForceSetEnableBitcode;
    
    [self setupXcodeprojOptions:representedObject.xcodeprojFileOptions];
    [self.xcodeprojPopupButton selectItemWithTitle:representedObject.currentXcodeprojFile];

    [self setupEnableBitcodeOptions:[DHTaskUtils enableBitcodeOptions]];
    [self.enableBitcodePopUpButton selectItemWithTitle:representedObject.currentEnableBitcode];

    [self setupSchemeOptions:representedObject.targetNameOptions];
    [self.schemePopUpButton selectItemWithTitle:representedObject.currentTargetName];

    [self setupTeamOptions:representedObject.teamNameOptions];
    [self.teamPopUpButton selectItemWithTitle:representedObject.currentTeamName];

    [self setupChannelOptions:[DHTaskUtils channelNameOptions]];
    [self setupChannelPopUpButtonSelectChannel:representedObject.channel];

    [self setupConfigurationOptions:[DHTaskUtils configurationNameOptions]];
    [self.configurationPopUpButton selectItemWithTitle:representedObject.configurationName];

    self.archiveDirTextField.stringValue = representedObject.exportArchiveDirectory?:@"";
    self.archiveFileLabel.stringValue = [representedObject.exportArchiveFile lastPathComponent]?:@"";

    self.ipaDirTextField.stringValue = representedObject.exportIPADirectory?:@"";
    self.ipaFileLabel.stringValue = [representedObject.exportIPAFile lastPathComponent]?:@"";

    self.keepXcarchiveSwitch.state = representedObject.isKeepXcarchive?NSControlStateValueOn:NSControlStateValueOff;
}

@end
