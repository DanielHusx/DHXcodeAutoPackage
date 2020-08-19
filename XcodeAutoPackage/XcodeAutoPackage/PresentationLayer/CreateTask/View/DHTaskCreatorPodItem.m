//
//  DHTaskCreatorPodItem.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/6.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskCreatorPodItem.h"
#import "DHTaskModel.h"

@interface DHTaskCreatorPodItem ()
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSSwitch *podInstallSwitch;

@end

@implementation DHTaskCreatorPodItem

- (void)viewDidLoad {
    [super viewDidLoad];
   [self setupUI];
}


#pragma mark - setup methods
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
    DHTaskCreatorPodItem *cell = [collectionView makeItemWithIdentifier:[self reuseIdentifier]
                                     forIndexPath:indexPath];
    cell.delegate = target;
    return cell;
}

+ (CGFloat)cellHeight {
    return 76.f;
}

+ (NSSize)cellSizeWithWidth:(CGFloat)width {
    return CGSizeMake(width, [self cellHeight]);
}


#pragma mark - event response

- (IBAction)podInstallAction:(NSSwitch *)sender {
    BOOL on = converStateToBoolean(sender.state);
    [_delegate podCell:self didChangedPodInstall:on];
}

#pragma mark - setter
- (void)setRepresentedObject:(DHTaskModel *)representedObject {
    self.podInstallSwitch.state = representedObject.isNeedPodInstall?NSControlStateValueOn:NSControlStateValueOff;
}

@end
