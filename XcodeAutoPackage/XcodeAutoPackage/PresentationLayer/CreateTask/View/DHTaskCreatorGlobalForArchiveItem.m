//
//  DHTaskCreatorGlobalForArchiveItem.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskCreatorGlobalForArchiveItem.h"
#import "DHTaskModel.h"

@interface DHTaskCreatorGlobalForArchiveItem ()
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSPopUpButton *platformPopupButton;
@property (weak) IBOutlet NSTextField *apiKeyTextField;
@property (weak) IBOutlet NSTextField *passwordTextField;

@property (weak) IBOutlet NSTextField *ipaDirTextField;
@property (weak) IBOutlet NSTextField *ipaFileLabel;
@property (weak) IBOutlet NSButton *ipaDirButton;
@end

@implementation DHTaskCreatorGlobalForArchiveItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}


#pragma mark - setup method
- (void)setupPlatfomOptions:(NSArray *)options {
    [_platformPopupButton removeAllItems];
    [_platformPopupButton addItemsWithTitles:options];
}


#pragma mark - event response

// 分发平台选择
- (IBAction)platformAction:(NSPopUpButton *)sender {
    
}

// 选择ipa存放目录
- (IBAction)ipaDirAction:(id)sender {
    
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
    return 221.f;
}

+ (NSSize)cellSizeWithWidth:(CGFloat)width {
    return CGSizeMake(width, [self cellHeight]);
}


#pragma mark - getter & setter
- (void)setRepresentedObject:(DHTaskModel *)representedObject {
    [self setupPlatfomOptions:[representedObject.distributionPlatformOptions mutableArrayValueForKeyPath:@"nickname"]];
    [self.platformPopupButton selectItemWithTitle:representedObject.distributionPlatform.nickname];
    // FIXME: change log
    self.apiKeyTextField.stringValue = representedObject.distributionPlatform.platformKey?:@"";
    self.passwordTextField.stringValue = representedObject.distributionPlatform.installPassword?:@"";
    self.apiKeyTextField.enabled = representedObject.distributionPlatform?YES:NO;
    self.passwordTextField.enabled = representedObject.distributionPlatform?YES:NO;
    
    self.ipaDirTextField.stringValue = representedObject.exportIPADirectory?:@"";
    
    
}


@end
