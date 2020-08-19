//
//  DHTaskCreatorAppItem.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/24.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskCreatorAppItem.h"
#import "DHTaskModel.h"

@interface DHTaskCreatorAppItem ()
@property (weak) IBOutlet NSTextField *productNameLabel;
@property (weak) IBOutlet NSTextField *bundleIdLabel;
@property (weak) IBOutlet NSTextField *versionLabel;
@property (weak) IBOutlet NSTextField *buildVersionLabel;
@property (weak) IBOutlet NSTextField *enableBitcodeLabel;
@property (weak) IBOutlet NSTextField *contentView;

@end

@implementation DHTaskCreatorAppItem

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}


#pragma mark - setup method
- (void)setupUI {
    [self.contentView creatorCellContentViewStyle];
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
    DHTaskCreatorAppItem *cell = [collectionView makeItemWithIdentifier:[self reuseIdentifier]
                                     forIndexPath:indexPath];
    
    return cell;
}

+ (CGFloat)cellHeight {
    return 181.f;
}

+ (NSSize)cellSizeWithWidth:(CGFloat)width {
    return CGSizeMake(width, [self cellHeight]);
}


#pragma mark - getter & setter
- (void)setRepresentedObject:(DHTaskModel *)representedObject {
    self.productNameLabel.stringValue = representedObject.currentDisplayName?:@"";
    self.bundleIdLabel.stringValue = representedObject.currentBundleId?:@"";
    self.versionLabel.stringValue = representedObject.currentVersion?:@"";
    self.buildVersionLabel.stringValue = representedObject.currentBuildVersion?:@"";
    self.enableBitcodeLabel.stringValue = representedObject.currentEnableBitcode?:@"";
}

@end
