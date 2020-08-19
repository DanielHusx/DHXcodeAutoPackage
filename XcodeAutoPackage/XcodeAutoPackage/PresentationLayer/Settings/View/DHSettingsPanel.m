//
//  DHSettingsPanel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHSettingsPanel.h"
#import "DHGlobalConfigration.h"
#import "DHDistributePanel.h"
//#import "DHDBFactory.h"
#import "DHGlobalArchiver.h"
//#import "DHDistributionPgyerModel.h"
#import <DHXcodeSDK/DHXcodeSDK.h>
#import "DHTaskUtils.h"

@interface DHSettingsPanel ()
@property (weak) IBOutlet NSPopUpButton *channelPopUpButton;
@property (weak) IBOutlet NSPopUpButton *configurationPopUpButton;
@property (weak) IBOutlet NSTextField *archiveDirTextField;
@property (weak) IBOutlet NSTextField *ipaDirTextField;
@property (weak) IBOutlet NSTextField *profileDirTextField;
@property (weak) IBOutlet NSSwitch *keepXcarchiveSwitch;
@property (weak) IBOutlet NSSwitch *gitPullSwitch;
@property (weak) IBOutlet NSSwitch *podInstallSwitch;
@property (weak) IBOutlet NSPopUpButton *nicknamePopUpButton;
@property (weak) IBOutlet NSTextField *platformLabel;
@property (weak) IBOutlet NSTextField *apiKeyLabel;
@property (weak) IBOutlet NSTextField *passwordLabel;

/// 全局设置
@property (nonatomic, strong) DHGlobalConfigration *globalConfiguration;
/// nickname
@property (nonatomic, strong) NSMutableArray *nicknameDataSource;
@end

@implementation DHSettingsPanel
#pragma mark - initialization
+ (instancetype)panel {
    DHSettingsPanel *panel;
    NSArray *topLevelObjects;
    
    if (![[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil topLevelObjects:&topLevelObjects]) { return nil; }
    for (id object in topLevelObjects) {
        if ([object isKindOfClass:[DHSettingsPanel class]]) {
            panel = object;
            break;
        }
    }
    return panel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupData];
}

#pragma mark - public method
+ (void)showWithWindow:(NSWindow *)window {
    DHSettingsPanel *panel = [DHSettingsPanel panel];
    panel.parentWindow = window;
    // 显示
    [window beginSheet:panel completionHandler:nil];
}


#pragma mark - setup
- (void)setupData {
    [self.channelPopUpButton removeAllItems];
    [self.channelPopUpButton addItemsWithTitles:[DHTaskUtils channelOptions]];
    [self.channelPopUpButton selectItemWithTitle:self.globalConfiguration.channel];
    
    [self.configurationPopUpButton removeAllItems];
    [self.configurationPopUpButton addItemsWithTitles:[DHTaskUtils configurationNameOptions]];
    [self.configurationPopUpButton selectItemWithTitle:self.globalConfiguration.configurationName];
    
    self.archiveDirTextField.stringValue = self.globalConfiguration.exportArchiveDirectory?:@"";
    self.ipaDirTextField.stringValue = self.globalConfiguration.exportIPADirectory?:@"";
    self.profileDirTextField.stringValue = self.globalConfiguration.profilesDirectory?:@"";
    
    self.keepXcarchiveSwitch.state = converBooleanToState(self.globalConfiguration.isKeepXcarchive);
    self.gitPullSwitch.state = converBooleanToState(self.globalConfiguration.isNeedGitPull);
    self.podInstallSwitch.state = converBooleanToState(self.globalConfiguration.isNeedPodInstall);
    
    [self setupWithDistributePlatforms:self.globalConfiguration.distributionPlatforms];
    
}

- (void)setupWithDistributePlatforms:(NSArray <id<DHDistributionProtocol>> *)distributePlatforms {
    [self.nicknamePopUpButton removeAllItems];
    [self.nicknamePopUpButton addItemsWithTitles:[[distributePlatforms mutableArrayValueForKey:@"nickname"] copy]];
    [self setupWithDistributePlatform:distributePlatforms.firstObject];
}

- (void)setupWithDistributePlatforms:(NSArray <id<DHDistributionProtocol>> *)distributePlatforms
                          distribute:(id<DHDistributionProtocol>)distribute {
    [self.nicknamePopUpButton removeAllItems];
    [self.nicknamePopUpButton addItemsWithTitles:[[distributePlatforms mutableArrayValueForKey:@"nickname"] copy]];
    [self setupWithDistributePlatform:distribute];
}

- (void)setupWithDistributePlatform:(id<DHDistributionProtocol>)distributePlatform {
    BOOL enable = distributePlatform?YES:NO;
    self.nicknamePopUpButton.enabled = enable;
    
    [self.nicknamePopUpButton selectItemWithTitle:distributePlatform.nickname?:@""];
    self.platformLabel.stringValue = distributePlatform.platformType?:@"";
    self.apiKeyLabel.stringValue = distributePlatform.platformApiKey?:@"";
    self.passwordLabel.stringValue = distributePlatform.installPassword?:@"";
}


#pragma mark - event response
- (IBAction)archiveDirAction:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = NO;
    openPanel.canChooseDirectories = YES;
    openPanel.allowsMultipleSelection = NO;
    [openPanel beginSheetModalForWindow:self
                      completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSString *path = [[openPanel URL] path];
            self.archiveDirTextField.stringValue = path;
            self.globalConfiguration.exportArchiveDirectory = path;
        }
    }];
}
- (IBAction)ipaDirAction:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = NO;
    openPanel.canChooseDirectories = YES;
    openPanel.allowsMultipleSelection = NO;
    [openPanel beginSheetModalForWindow:self
                      completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSString *path = [[openPanel URL] path];
            self.ipaDirTextField.stringValue = path;
            self.globalConfiguration.exportIPADirectory = path;
        }
    }];
}
- (IBAction)profileDirAction:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = NO;
    openPanel.canChooseDirectories = YES;
    openPanel.allowsMultipleSelection = NO;
    [openPanel beginSheetModalForWindow:self
                      completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSString *path = [[openPanel URL] path];
            self.profileDirTextField.stringValue = path;
            self.globalConfiguration.profilesDirectory = path;
            
        }
    }];
}

- (IBAction)channelAction:(NSPopUpButton *)sender {
    self.globalConfiguration.channel = sender.titleOfSelectedItem;
}

- (IBAction)configurationAction:(NSPopUpButton *)sender {
    self.globalConfiguration.configurationName = sender.titleOfSelectedItem;
}

- (IBAction)archiveDirTextFieldAction:(NSTextField *)sender {
    self.globalConfiguration.exportArchiveDirectory = sender.stringValue;
}

- (IBAction)ipaDirTextFieldAction:(NSTextField *)sender {
    self.globalConfiguration.exportIPADirectory = sender.stringValue;
}

- (IBAction)profileDirTextFieldAction:(NSTextField *)sender {
    self.globalConfiguration.profilesDirectory = sender.stringValue;
}

- (IBAction)keepXcarchiveAction:(NSSwitch *)sender {
    self.globalConfiguration.keepXcarchive = converStateToBoolean(sender.state);
}

- (IBAction)gitPullAction:(NSSwitch *)sender {
    self.globalConfiguration.needGitPull = converStateToBoolean(sender.state);
}

- (IBAction)podInstallAction:(NSSwitch *)sender {
    self.globalConfiguration.needPodInstall = converStateToBoolean(sender.state);
}

- (IBAction)nicknameAction:(NSPopUpButton *)sender {
    [self setupWithDistributePlatform:[self searchDistributeByNicname:sender.titleOfSelectedItem]];
}

- (IBAction)addDistributeAction:(id)sender {
    __weak typeof(self) weakself = self;
    [DHDistributePanel showWithWindow:self
                             platform:nil
                             nickname:nil
                               apiKey:nil
                      installPassword:nil
                             callback:^(DHDistributionPlatform  _Nonnull platform, NSString * _Nonnull nickname, NSString * _Nonnull apiKey, NSString * _Nonnull installPassword) {
        id<DHDistributionProtocol> distribute = [DHGetterUtils fetchDistributeWithPlatform:platform];
        distribute.nickname = nickname;
        distribute.platformApiKey = apiKey;
        distribute.installPassword = installPassword;
        [weakself.globalConfiguration.distributionPlatforms addObject:distribute];
        [weakself setupWithDistributePlatforms:weakself.globalConfiguration.distributionPlatforms];
    }];
}

- (IBAction)editDistributeAction:(id)sender {
    __block id<DHDistributionProtocol> distribute = [self searchDistributeByNicname:self.nicknamePopUpButton.titleOfSelectedItem];
    if (!distribute) {
        DHLogDebug(@"无平台信息可编辑");
        return ;
    }
    __weak typeof(self) weakself = self;
    [DHDistributePanel showWithWindow:self
                             platform:distribute.platformType
                             nickname:distribute.nickname
                               apiKey:distribute.platformApiKey
                      installPassword:distribute.installPassword
                             callback:^(DHDistributionPlatform  _Nonnull platform, NSString * _Nonnull nickname, NSString * _Nonnull apiKey, NSString * _Nonnull installPassword) {
        distribute.platformType = platform;
        distribute.nickname = nickname;
        distribute.platformApiKey = apiKey;
        distribute.installPassword = installPassword;
        [weakself setupWithDistributePlatforms:weakself.globalConfiguration.distributionPlatforms
                                    distribute:distribute];
    }];
}

- (IBAction)deleteDistributeAction:(id)sender {
    id<DHDistributionProtocol> distribute = [self searchDistributeByNicname:self.nicknamePopUpButton.titleOfSelectedItem];
    if (!distribute) {
        DHLogDebug(@"无平台信息可删除");
        return ;
    }
    [self.globalConfiguration.distributionPlatforms removeObject:distribute];
    [self setupWithDistributePlatforms:self.globalConfiguration.distributionPlatforms];
}



- (IBAction)doneAction:(id)sender {
    [DHGlobalArchiver archiveGlobalConfiguration];
    
    [self.parentWindow endSheet:self];
}


#pragma mark - private method
- (id<DHDistributionProtocol>)searchDistributeByNicname:(NSString *)nickname {
    for (id<DHDistributionProtocol> d in self.globalConfiguration.distributionPlatforms) {
        if ([d.nickname isEqualToString:nickname]) {
            return d;
        }
    }
    return nil;
}

#pragma mark - getters
- (DHGlobalConfigration *)globalConfiguration {
    return [DHGlobalConfigration configuration];
}

@end
