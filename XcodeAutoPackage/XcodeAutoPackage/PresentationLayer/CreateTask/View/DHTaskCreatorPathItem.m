//
//  DHTaskCreatorPathItem.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/23.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskCreatorPathItem.h"
#import "DHTaskModel.h"

@interface DHTaskCreatorPathItem () <NSTextFieldDelegate>

@property (weak) IBOutlet NSTextField *pathTextField;
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSTextField *taskNameTextField;

@end

@implementation DHTaskCreatorPathItem

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}


#pragma mark - setup methods
- (void)setupUI {
    [self.contentView creatorCellContentViewStyle];
    self.pathTextField.editable = NO;
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
    DHTaskCreatorPathItem *cell = [collectionView makeItemWithIdentifier:[self reuseIdentifier]
                                                            forIndexPath:indexPath];
    cell.delegate = target;
    return cell;
}

+ (CGFloat)cellHeight {
    return 97.f;
}

+ (NSSize)cellSizeWithWidth:(CGFloat)width {
    return CGSizeMake(width, [self cellHeight]);
}


#pragma mark - event response
- (IBAction)pathAction:(NSTextField *)sender {
    [_delegate pathCell:self didChangedPath:sender.stringValue];
}

- (IBAction)taskNameAction:(NSTextField *)sender {
    [_delegate pathCell:self didChangedTaskName:sender.stringValue];
}


#pragma mark - getter & setter
- (void)setRepresentedObject:(DHTaskModel *)representedObject {
    self.pathTextField.stringValue = representedObject.path?:@"";
    self.taskNameTextField.stringValue = representedObject.taskName?:@"";
}

@end
