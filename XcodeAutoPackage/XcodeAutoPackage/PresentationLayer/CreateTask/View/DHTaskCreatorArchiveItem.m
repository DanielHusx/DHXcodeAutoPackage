//
//  DHTaskCreatorArchiveItem.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/6.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskCreatorArchiveItem.h"
#import "DHTaskModel.h"

@interface DHTaskCreatorArchiveItem ()
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSTextField *ipaDirTextField;
@property (weak) IBOutlet NSTextField *ipaFileLabel;
@property (weak) IBOutlet NSButton *ipaDirButton;
@end

@implementation DHTaskCreatorArchiveItem


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    [self.contentView creatorCellContentViewStyle];
}


#pragma mark - event response
// 选择ipa存放目录
- (IBAction)ipaDirAction:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = NO;
    openPanel.canChooseDirectories = YES;
    openPanel.allowsMultipleSelection = NO;
    [openPanel beginSheetModalForWindow:self.view.window
                      completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSString *path = [[openPanel URL] path];
            self.ipaDirTextField.stringValue = path;
            [self.delegate archiveCell:self didChangedIPADir:path];
        }
    }];
}

- (IBAction)ipaDirTextFieldAction:(NSTextField *)sender {
    [_delegate archiveCell:self didChangedIPADir:sender.stringValue];
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
    DHTaskCreatorArchiveItem *cell = [collectionView makeItemWithIdentifier:[self reuseIdentifier]
                                     forIndexPath:indexPath];
    cell.delegate = target;
    return cell;
}

+ (CGFloat)cellHeight {
    return 114.f;
}

+ (NSSize)cellSizeWithWidth:(CGFloat)width {
    return CGSizeMake(width, [self cellHeight]);
}


#pragma mark - getter & setter
- (void)setRepresentedObject:(DHTaskModel *)representedObject {
    self.ipaDirTextField.stringValue = representedObject.exportIPADirectory?:@"";
    self.ipaFileLabel.stringValue = [representedObject.exportIPAFile lastPathComponent]?:@"";
}

@end
