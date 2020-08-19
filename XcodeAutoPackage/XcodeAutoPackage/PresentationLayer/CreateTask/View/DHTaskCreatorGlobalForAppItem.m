//
//  DHTaskCreatorGlobalForAppItem.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskCreatorGlobalForAppItem.h"
#import "DHTaskModel.h"

@interface DHTaskCreatorGlobalForAppItem ()
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSPopUpButton *platformPopupButton;
@property (weak) IBOutlet NSTextField *apiKeyTextField;
@property (weak) IBOutlet NSTextField *passwordTextField;
@end

@implementation DHTaskCreatorGlobalForAppItem

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
    NSLog(@"分发平台选择");
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
    
    self.apiKeyTextField.stringValue = representedObject.distributionPlatform.platformKey?:@"";
    self.passwordTextField.stringValue = representedObject.distributionPlatform.installPassword?:@"";
    
    self.apiKeyTextField.enabled = representedObject.distributionPlatform?YES:NO;
    self.passwordTextField.enabled = representedObject.distributionPlatform?YES:NO;
}




@end
