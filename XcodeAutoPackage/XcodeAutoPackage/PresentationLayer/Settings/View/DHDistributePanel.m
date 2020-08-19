//
//  DHDistributePanel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/8.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHDistributePanel.h"
#import "DHGlobalConfigration.h"
#import "DHTaskUtils.h"

@interface DHDistributePanel ()
@property (weak) IBOutlet NSPopUpButton *platformPopUpButton;
@property (weak) IBOutlet NSTextField *nicknameTextField;
@property (weak) IBOutlet NSTextField *apiKeyTextField;
@property (weak) IBOutlet NSTextField *passwordTextField;
@property (weak) IBOutlet NSButton *doneButton;

/// exist
@property (nonatomic, copy) NSArray *existNicknames;


@property (nonatomic, copy) NSString *platformString;
@property (nonatomic, copy) NSString *apiKeyString;
@property (nonatomic, copy) NSString *passwordString;
@property (nonatomic, copy) NSString *nicknameString;
@property (nonatomic, copy) void (^callback) (DHDistributionPlatform platform, NSString *nickname, NSString *apiKey, NSString *installPassword);
@end

@implementation DHDistributePanel

#pragma mark - initialization
+ (instancetype)panel {
    DHDistributePanel *panel;
    NSArray *topLevelObjects;
    
    if (![[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil topLevelObjects:&topLevelObjects]) { return nil; }
    for (id object in topLevelObjects) {
        if ([object isKindOfClass:[DHDistributePanel class]]) {
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

- (void)setupData {
    [self setupPlatformPopUpButtonOptions];
    
    self.nicknameTextField.stringValue = [self generateDefaultNicknameWithPlatform:[self fetchPlatformPopUpButtonSelectedPlatform]
                                                                  existedNicknames:self.existNicknames];
    
    [self refreshDoneButtonState];
}

- (void)setupPlatformPopUpButtonOptions {
    [_platformPopUpButton removeAllItems];
    NSArray *options = [DHTaskUtils distributionPlatformNameOptions];
    [_platformPopUpButton addItemsWithTitles:options];
    
    [_platformPopUpButton selectItemWithTitle:options.firstObject];
    self.passwordTextField.enabled = ![[self fetchPlatformPopUpButtonSelectedPlatform] isEqualToString:kDHDistributionPlatformFir];
}

- (void)setupPlatformPopUpButtonSelectPlatform:(NSString *)platform {
    NSString *platformName = [DHTaskUtils convertDistributionPlatformToPlatformName:platform];
    [_platformPopUpButton selectItemWithTitle:platformName];
}

- (NSString *)fetchPlatformPopUpButtonSelectedPlatform {
    NSString *platform = [DHTaskUtils convertDistributionPlatformNameToPlatform:_platformPopUpButton.titleOfSelectedItem];
    return platform;
}


#pragma mark - public method
+ (void)showWithWindow:(NSWindow *)window
              platform:(nullable DHDistributionPlatform)platform
              nickname:(nullable NSString *)nickname
                apiKey:(nullable NSString *)apiKey
       installPassword:(nullable NSString *)installPassword
              callback:(nonnull void (^)(DHDistributionPlatform _Nonnull, NSString * _Nonnull, NSString * _Nonnull, NSString * _Nonnull))callback {
    DHDistributePanel *panel = [DHDistributePanel panel];
    panel.parentWindow = window;
    panel.platformString = platform;
    panel.apiKeyString = apiKey;
    panel.nicknameString = nickname;
    panel.passwordString = installPassword;
    panel.callback = callback;;
    // 显示
    [window beginSheet:panel completionHandler:nil];
}

#pragma mark - event response
- (IBAction)platformPopupButton:(NSPopUpButton *)sender {
    self.nicknameTextField.stringValue = sender.titleOfSelectedItem;
    self.passwordTextField.enabled = ![[self fetchPlatformPopUpButtonSelectedPlatform] isEqualToString:kDHDistributionPlatformFir];
    [self refreshDoneButtonState];
}

- (IBAction)nicknameAction:(NSTextField *)sender {
    NSString *nickname = sender.stringValue;
    if (![self checkNicknameValid:nickname]) {
        // 重置默认
        sender.stringValue = [self generateDefaultNicknameWithPlatform:self.platformPopUpButton.titleOfSelectedItem
                                                      existedNicknames:self.existNicknames];
    }
    [self refreshDoneButtonState];
}
- (IBAction)apiKeyAction:(NSTextField *)sender {
    [self refreshDoneButtonState];
}
- (IBAction)passwordAction:(NSTextField *)sender {
    
}

- (IBAction)doneAction:(id)sender {
    if (self.callback) {
        self.callback([self fetchPlatformPopUpButtonSelectedPlatform], self.nicknameTextField.stringValue, self.apiKeyTextField.stringValue, self.passwordTextField.stringValue);
    }
    [self.parentWindow endSheet:self];
}

- (IBAction)cancelAction:(id)sender {
    [self.parentWindow endSheet:self];
}


#pragma mark - private method
- (void)refreshDoneButtonState {
    self.doneButton.enabled = [self checkOK];
    self.doneButton.state = NSControlStateValueOn;
}

- (BOOL)checkOK {
    // apiKey，nickname是必要参数
    if (![DHCommonTools isValidString:self.apiKeyTextField.stringValue]) { return NO; }
    if (![DHCommonTools isValidString:self.nicknameTextField.stringValue]) { return NO; }
    return YES;
}
- (BOOL)checkNicknameValid:(NSString *)nickname {
    if (![DHCommonTools isValidString:nickname]) { return NO; }
    // 不存在已存储的nickname
    if (![DHCommonTools isValidArray:self.existNicknames]) { return YES; }
    // 如果与已存在的重复，那么返回NO
    return ![self.existNicknames containsObject:nickname];
}

- (NSString *)generateDefaultNicknameWithPlatform:(DHDistributionPlatform)platform
                                 existedNicknames:(NSArray *)existNicknames {
    if (![DHCommonTools isValidArray:existNicknames]) return platform;
    
    NSInteger i = 0;
    NSString *nickname = platform;
    do {
        i += 1;
        nickname = [platform stringByAppendingString:@(i).stringValue];
        if ([self.existNicknames containsObject:nickname]) { continue; }
        break;
    } while (1);
    
    return nickname;
}

#pragma mark - getters
- (NSArray *)existNicknames {
    if (!_existNicknames) {
        _existNicknames = [[[DHGlobalConfigration configuration].distributionPlatforms mutableArrayValueForKey:@"nickname"] copy];
    }
    return _existNicknames;
}

- (void)setPlatformString:(NSString *)platformString {
    if (!platformString) { return ; }
    [self.platformPopUpButton selectItemWithTitle:[DHTaskUtils convertDistributionPlatformToPlatformName:platformString]];
}

- (void)setApiKeyString:(NSString *)apiKeyString {
    if (!apiKeyString) { return ; }
    self.apiKeyTextField.stringValue = apiKeyString;
}

- (void)setNicknameString:(NSString *)nicknameString {
    if (!nicknameString) { return ; }
    self.nicknameTextField.stringValue = [self generateDefaultNicknameWithPlatform:nicknameString
                             existedNicknames:self.existNicknames];
}

- (void)setPasswordString:(NSString *)passwordString {
    if (!passwordString) { return ; }
    self.passwordTextField.stringValue = passwordString;
}
@end
