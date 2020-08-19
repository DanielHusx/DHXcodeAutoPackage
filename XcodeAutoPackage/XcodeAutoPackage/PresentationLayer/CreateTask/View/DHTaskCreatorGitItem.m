//
//  DHTaskCreatorGitItem.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/6.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskCreatorGitItem.h"
#import "DHTaskModel.h"

@interface DHTaskCreatorGitItem ()
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSPopUpButton *branchPopupButton;
@property (weak) IBOutlet NSSwitch *gitPullSwitch;

@end

@implementation DHTaskCreatorGitItem

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}


#pragma mark - setup methods
- (void)setupUI {
    [self.contentView creatorCellContentViewStyle];
}

- (void)setupBranchOptions:(NSArray *)options {
    [_branchPopupButton removeAllItems];
    [_branchPopupButton addItemsWithTitles:options];
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
    DHTaskCreatorGitItem *cell = [collectionView makeItemWithIdentifier:[self reuseIdentifier]
                                     forIndexPath:indexPath];
    return cell;
}

+ (CGFloat)cellHeight {
    return 95.f;
}

+ (NSSize)cellSizeWithWidth:(CGFloat)width {
    return CGSizeMake(width, [self cellHeight]);
}


#pragma mark - event response
- (IBAction)branchAction:(NSPopUpButton *)sender {
    [_delegate gitCell:self didChangedBranch:sender.titleOfSelectedItem];
}

- (IBAction)gitPullAction:(NSSwitch *)sender {
    BOOL on = converStateToBoolean(sender.state);
    [_delegate gitCell:self didChangedGitPull:on];
}


#pragma mark - getter & setter
- (void)setRepresentedObject:(DHTaskModel *)representedObject {
    [self setupBranchOptions:representedObject.branchNameOptions];
    [self.branchPopupButton selectItemWithTitle:representedObject.currentBranch];
    
    self.gitPullSwitch.state = representedObject.isNeedGitPull?NSControlStateValueOn:NSControlStateValueOff;
}

@end
