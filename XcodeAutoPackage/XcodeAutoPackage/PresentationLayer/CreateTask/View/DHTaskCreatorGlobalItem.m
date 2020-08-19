//
//  DHTaskCreatorGlobalItem.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskCreatorGlobalItem.h"
#import "DHTaskModel.h"
/**
全局设置
workspace
configurationName
channelType
exportArchiveDirectory
exportIPADirectory
profilesDirectory
distributionPlatform->pgyer/fir
keepXcarchive
needPodInstall -> 应该判断pod是否存在 & workspace
needGitPull -> 应该判断git是否存在

project
configurationName
channelType
exportArchiveDirectory
exportIPADirectory
profilesDirectory
distributionPlatform->pgyer/fir
keepXcarchive
needGitPull -> 应该判断git是否存在
一定是不存在pod的，应该pod只会存在于workspace才有效

archive
exportIPADirectory
distributionPlatform -> pgyer/fir

ipa
distributionPlatform -> pgyer/fir
*/
@interface DHTaskCreatorGlobalItem ()
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSPopUpButton *platformPopupButton;
@property (weak) IBOutlet NSTextField *apiKeyTextField;
@property (weak) IBOutlet NSTextField *passwordTextField;

@property (weak) IBOutlet NSTextField *archiveDirTextField;
@property (weak) IBOutlet NSTextField *archiveFileLabel;
@property (weak) IBOutlet NSButton *archiveDirButton;

@property (weak) IBOutlet NSTextField *ipaDirTextField;
@property (weak) IBOutlet NSTextField *ipaFileLabel;
@property (weak) IBOutlet NSButton *ipaDirButton;
@property (weak) IBOutlet NSPopUpButton *configurationPopupButton;
@property (weak) IBOutlet NSPopUpButton *channelPopupButton;
@property (weak) IBOutlet NSButton *archiveKeepCheckButton;
@property (weak) IBOutlet NSButton *podInstallCheckButton;
@property (weak) IBOutlet NSButton *gitPullCheckButton;

@end

@implementation DHTaskCreatorGlobalItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)viewDidLayout {
    [super viewDidLayout];
    
}


#pragma mark - setup method
- (void)setupPlatfomOptions:(NSArray *)options {
    [_platformPopupButton removeAllItems];
    [_platformPopupButton addItemsWithTitles:options];
}

- (void)setupChannelOptions:(NSArray *)options {
    [_channelPopupButton removeAllItems];
    [_channelPopupButton addItemsWithTitles:options];
}

- (void)setupConfigurationOptions:(NSArray *)options {
    [_configurationPopupButton removeAllItems];
    [_configurationPopupButton addItemsWithTitles:options];
}


#pragma mark - event response
// 分发平台选择
- (IBAction)platformAction:(NSPopUpButton *)sender {
    
}

// 选择归档文件存放目录
- (IBAction)archiveDirAction:(id)sender {
    
}

// 选择ipa存放目录
- (IBAction)ipaDirAction:(id)sender {
    
}

// 点击Debug/Release
- (IBAction)configurationActioin:(NSPopUpButton *)sender {
    
}

// 点击channel
- (IBAction)channelAction:(NSPopUpButton *)sender {
    
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
                             indexPath:(NSIndexPath *)indexPath {
    return [collectionView makeItemWithIdentifier:[self reuseIdentifier]
                                     forIndexPath:indexPath];
}

+ (CGFloat)cellHeight {
    return 343.f;
}

+ (NSSize)cellSizeWithWidth:(CGFloat)width {
    return CGSizeMake(width, [self cellHeight]);
}

+ (NSSize)cellSizeWithWidth:(CGFloat)width object:(id)object {
    return [self cellSizeWithWidth:width];
}


#pragma mark - getter & setter
- (void)setRepresentedObject:(DHTaskModel *)representedObject {
    // platform
    [self setupPlatfomOptions:[representedObject.distributionPlatformOptions mutableArrayValueForKeyPath:@"nickname"]];
    [self.platformPopupButton selectItemWithTitle:representedObject.distributionPlatform.nickname];
    
    self.apiKeyTextField.stringValue = representedObject.distributionPlatform.platformKey?:@"";
    self.passwordTextField.stringValue = representedObject.distributionPlatform.installPassword?:@"";
    
    self.apiKeyTextField.enabled = representedObject.distributionPlatform?YES:NO;
    self.passwordTextField.enabled = representedObject.distributionPlatform?YES:NO;
    
    
    // archive
    self.archiveDirTextField.stringValue = representedObject.exportArchiveDirectory?:@"";
    self.archiveFileLabel.stringValue = [representedObject.exportArchiveFile lastPathComponent];
    
    // ipa
    self.ipaDirTextField.stringValue = representedObject.exportIPADirectory;
    self.ipaFileLabel.stringValue = [representedObject.exportIPAFile lastPathComponent];
    
    // channel
    [self setupChannelOptions:representedObject.channelOptions];
    [self.channelPopupButton selectItemWithTitle:representedObject.channel];
    
    // configuration
    [self setupConfigurationOptions:representedObject.configurationNameOptions];
    [self.configurationPopupButton selectItemWithTitle:representedObject.configurationName];
    
    // keep archive
    self.archiveKeepCheckButton.state = representedObject.isKeepXcarchive?NSControlStateValueOn:NSControlStateValueOff;
    self.podInstallCheckButton.state = representedObject.isNeedPodInstall?NSControlStateValueOn:NSControlStateValueOff;
    self.gitPullCheckButton.state = representedObject.isNeedGitPull?NSControlStateValueOn:NSControlStateValueOff;
    
    self.podInstallCheckButton.hidden = representedObject.project?YES:NO;
    
    
}


@end
