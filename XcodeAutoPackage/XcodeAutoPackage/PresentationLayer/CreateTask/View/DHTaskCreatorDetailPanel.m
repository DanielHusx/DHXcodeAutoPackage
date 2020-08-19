//
//  DHTaskCreatorDetailPanel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/25.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskCreatorDetailPanel.h"
#import "DHTaskCreatorProfileItem.h"
#import "DHTaskCreatorPathItem.h"
#import "DHTaskCreatorProjectItem.h"
#import "DHTaskCreatorAppItem.h"
#import "DHTaskCreatorGitItem.h"
#import "DHTaskCreatorPodItem.h"
#import "DHTaskCreatorDistributeItem.h"
#import "DHTaskCreatorArchiveItem.h"
#import "DHTaskModel.h"
#import "DHTaskUtils.h"
#import "DHTaskFactory.h"
#import "DHTaskSetter.h"

typedef NS_ENUM(NSInteger, DHTaskCreatorItemType) {
    DHTaskCreatorItemTypePath,
    DHTaskCreatorItemTypeProject,
    DHTaskCreatorItemTypeProfile,
    DHTaskCreatorItemTypeArchive,
    DHTaskCreatorItemTypeApp,
    DHTaskCreatorItemTypePod,
    DHTaskCreatorItemTypeGit,
    DHTaskCreatorItemTypeDistribute,
    
};

@interface DHTaskCreatorDetailPanel () <
NSCollectionViewDataSource,
NSCollectionViewDelegate,
NSCollectionViewDelegateFlowLayout,
DHTaskCreatorPathItemDelegate,
DHTaskCreatorProjectItemDelegate,
DHTaskCreatorProfileItemDelegate,
DHTaskCreatorGitItemDelegate,
DHTaskCreatorPodItemDelegate,
DHTaskCreatorDistributeItemDelegate,
DHTaskCreatorArchiveItemDelegate>

@property (weak) IBOutlet NSTextField *statusLabel;
@property (weak) IBOutlet NSButton *cancelButton;
@property (weak) IBOutlet NSButton *previousButton;
@property (weak) IBOutlet NSButton *doneButton;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSCollectionView *collectionView;
/// dataSource
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 任务
@property (nonatomic, strong) DHTaskModel *task;
/// callback
@property (nonatomic, copy) void (^callback) (DHTaskModel *);
/// 返回上一步
@property (nonatomic, copy) void (^backward) (void);

@end

@implementation DHTaskCreatorDetailPanel

#pragma mark - initialization
+ (instancetype)panel {
    DHTaskCreatorDetailPanel *panel;
    NSArray *topLevelObjects;
    if (![[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil topLevelObjects:&topLevelObjects]) { return nil; }
    for (id object in topLevelObjects) {
        if ([object isKindOfClass:[DHTaskCreatorDetailPanel class]]) {
            panel = object;
            break;
        }
    }
    
    return panel;
}


#pragma mark - public method
+ (void)showWithWindow:(NSWindow *)window
                  path:(NSString * _Nullable)path
                  task:(DHTaskModel * _Nullable)task
              backwark:(nullable void (^)(void))backwark
              callback:(nonnull void (^)(DHTaskModel * _Nonnull))callback{
    DHTaskCreatorDetailPanel *panel = [DHTaskCreatorDetailPanel panel];
    panel.parentWindow = window;
    panel.backward = backwark;
    panel.previousButton.hidden = !backwark?YES:NO;
    panel.callback = callback;
    [panel configWithTask:task orPath:path];
    // 显示
    [window beginSheet:panel completionHandler:nil];
}


#pragma mark - ui method
- (void)startProcess {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.hidden = YES;
        self.doneButton.enabled = NO;
        [self.progressIndicator startAnimation:self];
    });
}

- (void)stopProcessWithNextable:(BOOL)nextable {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.doneButton.enabled = YES;
        [self.progressIndicator stopAnimation:self];
    });
}

- (void)showStatus:(NSString *)text {
    [self showStatusWithText:text type:0];
}

- (void)showError:(NSString *)text {
    [self showStatusWithText:text type:-1];
}

- (void)showWarning:(NSString *)text {
    [self showStatusWithText:text type:1];
}

- (void)showStatusWithText:(NSString *)text type:(NSInteger)type {
   dispatch_async(dispatch_get_main_queue(), ^{
       // 0：正常；>0：警告；<0：错误
       self.statusLabel.hidden = NO;
       self.statusLabel.textColor = type == 0?[NSColor blackColor]:(type > 0?[NSColor orangeColor]:[NSColor redColor]);
       self.statusLabel.stringValue = text?:@"";
   });
}

- (void)configWithTask:(DHTaskModel *)task orPath:(NSString *)path {
    
    if (path) {
        [self configWithPath:path];
    } else {
        [self setupNormalFrameWithAnimated:YES];
        [self configWithTask:task];
    }
}

- (void)setupProcessingFrameWithAnimated:(BOOL)animate {
    [self setupFrameHeight:125.f animate:NO];
}

- (void)setupOnlyPathFrameWithAnimated:(BOOL)animate {
    [self setupFrameHeight:125.f+[DHTaskCreatorPathItem cellHeight] animate:NO];
}

- (void)setupNormalFrameWithAnimated:(BOOL)animate {
    [self setupFrameHeight:622.f animate:YES];
}

- (void)setupFrameHeight:(CGFloat)height animate:(BOOL)animate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+(self.frame.size.height-height), self.frame.size.width, height)
               display:YES
               animate:animate];
    });
}

#pragma mark - 数据配置
- (void)configWithPath:(NSString *)path {
    [self startProcess];
    [self setupOnlyPathFrameWithAnimated:YES];
    [self configDataSourceWithPath:path];
    
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 先整path出来展示
        // 开始解析
        NSError *error;
        DHTaskModel *task = [DHTaskFactory getTaskWithPath:path error:&error];
        if (error) {
            [weakself stopProcessWithNextable:NO];
            [weakself showError:error.userInfo[NSLocalizedFailureReasonErrorKey]];
            return ;
        }
        [weakself stopProcessWithNextable:NO];
        [weakself setupNormalFrameWithAnimated:NO];
        [weakself configWithTask:task];
    });
    
}

- (void)configDataSourceWithPath:(NSString *)path {
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:@(DHTaskCreatorItemTypePath)];
    [self reloadData];
    
}

- (void)configDataSourceWithTask:(DHTaskModel *)task {
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:@(DHTaskCreatorItemTypePath)];
    
    DHTaskType type = task.taskType;
    
    if (type & DHTaskTypeGit) {
        // git
        [self.dataSource addObject:@(DHTaskCreatorItemTypeGit)];
    }
    if (type & DHTaskTypePod) {
        // pod
        [self.dataSource addObject:@(DHTaskCreatorItemTypePod)];
    }
    
    if (type & DHTaskTypeXcworkspace || type & DHTaskTypeXcodeproj) {
        // workspace or project
        [self.dataSource addObjectsFromArray:@[
            @(DHTaskCreatorItemTypeProject),
            @(DHTaskCreatorItemTypeProfile)
        ]];
    } else if (type & DHTaskTypeXcarchive) {
        // archive or ipa
        [self.dataSource addObjectsFromArray:@[
            @(DHTaskCreatorItemTypeArchive),
            @(DHTaskCreatorItemTypeApp),
            @(DHTaskCreatorItemTypeProfile)
        ]];
    } else if (type & DHTaskTypeIPA) {
        // ipa
        [self.dataSource addObjectsFromArray:@[
            @(DHTaskCreatorItemTypeApp),
            @(DHTaskCreatorItemTypeProfile)
        ]];
    }
    
    // distribute
    [self.dataSource addObject:@(DHTaskCreatorItemTypeDistribute)];
    
    [self reloadData];
}

- (void)reloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)reloadDataWithItemType:(DHTaskCreatorItemType)itemType {
    NSUInteger index = [self.dataSource indexOfObject:@(itemType)];
    if (index == NSNotFound) { return ; }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadItemsAtIndexPaths:[NSSet setWithObject:indexPath]];
    });
}

- (void)configWithTask:(DHTaskModel *)task {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.task = [task copy];
        [self configDataSourceWithTask:task];
    });
}


#pragma mark - NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(NSCollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView
     itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    __kindof NSCollectionViewItem *cell;
    DHTaskCreatorItemType type = [self.dataSource[indexPath.item] integerValue];
    switch (type) {
        case DHTaskCreatorItemTypePath:
            cell = [DHTaskCreatorPathItem cellWithCollectionView:collectionView
                                                       indexPath:indexPath
                                                          target:self];
            break;
        case DHTaskCreatorItemTypeProject:
            cell = [DHTaskCreatorProjectItem cellWithCollectionView:collectionView
                                                          indexPath:indexPath
                                                             target:self];
            break;
        case DHTaskCreatorItemTypeProfile:
            cell = [DHTaskCreatorProfileItem cellWithCollectionView:collectionView
                                                          indexPath:indexPath
                                                             target:self];
            break;
        case DHTaskCreatorItemTypeArchive:
            cell = [DHTaskCreatorArchiveItem cellWithCollectionView:collectionView
                                                          indexPath:indexPath
                                                             target:self];
            break;
        case DHTaskCreatorItemTypeApp:
            cell = [DHTaskCreatorAppItem cellWithCollectionView:collectionView
                                                      indexPath:indexPath
                                                         target:self];
            break;
        case DHTaskCreatorItemTypeGit:
            cell = [DHTaskCreatorGitItem cellWithCollectionView:collectionView
                                                      indexPath:indexPath
                                                         target:self];
            break;
        case DHTaskCreatorItemTypePod:
            cell = [DHTaskCreatorPodItem cellWithCollectionView:collectionView
                                                      indexPath:indexPath
                                                         target:self];
            break;
        case DHTaskCreatorItemTypeDistribute:
            cell = [DHTaskCreatorDistributeItem cellWithCollectionView:collectionView
                                                             indexPath:indexPath
                                                                target:self];
            break;
        default:
            break;
    }
    cell.representedObject = self.task;
    
    return cell;
}


- (NSSize)collectionView:(NSCollectionView *)collectionView
                  layout:(NSCollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSSize size = CGSizeZero;
    DHTaskCreatorItemType type = [self.dataSource[indexPath.item] integerValue];
    CGFloat width = collectionView.frame.size.width;
    switch (type) {
        case DHTaskCreatorItemTypePath:
            size = [DHTaskCreatorPathItem cellSizeWithWidth:width];
            break;
        case DHTaskCreatorItemTypeProject:
            size = [DHTaskCreatorProjectItem cellSizeWithWidth:width];
            break;
        case DHTaskCreatorItemTypeProfile:
            size = [DHTaskCreatorProfileItem cellSizeWithWidth:width];
            break;
        case DHTaskCreatorItemTypeApp:
            size = [DHTaskCreatorAppItem cellSizeWithWidth:width];
            break;
        case DHTaskCreatorItemTypeArchive:
            size = [DHTaskCreatorArchiveItem cellSizeWithWidth:width];
            break;
        case DHTaskCreatorItemTypeGit:
            size = [DHTaskCreatorGitItem cellSizeWithWidth:width];
            break;
        case DHTaskCreatorItemTypePod:
            size = [DHTaskCreatorPodItem cellSizeWithWidth:width];
            break;
        case DHTaskCreatorItemTypeDistribute:
            size = [DHTaskCreatorDistributeItem cellSizeWithWidth:width];
            break;
       
        default:
            break;
    }
    
    return size;
}

#pragma mark - cell delegate
- (void)pathCell:(DHTaskCreatorPathItem *)pathCell didChangedPath:(NSString *)path {}
- (void)pathCell:(DHTaskCreatorPathItem *)pathCell didChangedTaskName:(NSString *)taskName {
    self.task.taskName = taskName;
}

#pragma mark *** project cell ***
- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell
didChangedDisplayName:(NSString *)displayName {
    self.task.currentDisplayName = displayName;
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell
didChangedXcodeprojFile:(NSString *)xcodeprojFile {
    BOOL changed = [DHTaskSetter checkForUpdateTask:self.task withXcodeprojFile:xcodeprojFile];
    if (!changed) { return ; }
    [self reloadData];
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell
   didChangedScheme:(NSString *)scheme {
    BOOL changed = [DHTaskSetter checkForUpdateTask:self.task withTargetName:scheme];
    if (!changed) { return ; }
    [self reloadData];
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell
     didChangedTeam:(NSString *)team {
    BOOL changed = [DHTaskSetter checkForUpdateTask:self.task withTeamName:team];
    if (!changed) { return ; }
    [self reloadDataWithItemType:DHTaskCreatorItemTypeProject];
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell
 didChangedBundleId:(NSString *)bundleId {
    BOOL changed = [DHTaskSetter checkForUpdateTask:self.task withBundleId:bundleId];
    if (!changed) { return ; }
    [self reloadData];
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedVersion:(NSString *)version {
    self.task.currentVersion = version;
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell
    didChangedBuild:(NSString *)build {
    self.task.currentBuildVersion = build;
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell
didChangedEnableBitcode:(NSString *)enableBitcode {
    self.task.currentEnableBitcode = enableBitcode;
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell
  didChangedChannel:(NSString *)channel {
    BOOL changed = [DHTaskSetter checkForUpdateTask:self.task withChannel:channel];
    if (!changed) { return ; }
    [self reloadData];
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedConfiguration:(NSString *)configuration {
    self.task.configurationName = configuration;
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell
didChangedArchiveDir:(NSString *)archiveDir {
    self.task.exportArchiveDirectory = archiveDir;
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell
   didChangedIPADir:(NSString *)ipaDir {
    self.task.exportIPADirectory = ipaDir;
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell
didChangedKeepXcarchive:(BOOL)keepXcarchive {
    self.task.keepXcarchive = keepXcarchive;
}


- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedDisplayNameForceSet:(BOOL)forceSet {
    self.task.forceSetDisplayName = forceSet;
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedBundlIdForceSet:(BOOL)forceSet {
    self.task.forceSetBundleId = forceSet;
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedTeamIdForceSet:(BOOL)forceSet {
    self.task.forceSetTeamId = forceSet;
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedVersionForceSet:(BOOL)forceSet {
    self.task.forceSetVersion = forceSet;
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedBuildVersionForceSet:(BOOL)forceSet {
    self.task.forceSetBuildVersion = forceSet;
}

- (void)projectCell:(DHTaskCreatorProjectItem *)projectCell didChangedEnableBitcodeForceSet:(BOOL)forceSet {
    self.task.forceSetEnableBitcode = forceSet;
}


#pragma mark *** git ***
- (void)gitCell:(DHTaskCreatorGitItem *)gitCell
didChangedBranch:(NSString *)branch {
    self.task.currentBranch = branch;
}

- (void)gitCell:(DHTaskCreatorGitItem *)gitCell
didChangedGitPull:(BOOL)gitPull {
    self.task.needGitPull = gitPull;
}


#pragma mark *** pod ***
- (void)podCell:(DHTaskCreatorPodItem *)podCell
didChangedPodInstall:(BOOL)podInstall {
    self.task.needPodInstall = podInstall;
}


#pragma mark *** distribute ***
- (void)distributeCell:(DHTaskCreatorDistributeItem *)distributeCell
    didChangedPlatform:(NSString *)platform {
    BOOL changed = [DHTaskSetter checkForUpdateTask:self.task withDistributionPlatform:platform];
    if (!changed) { return ; }
    [self reloadDataWithItemType:DHTaskCreatorItemTypeDistribute];
}

- (void)distributeCell:(DHTaskCreatorDistributeItem *)distributeCell
    didChangedNickname:(NSString *)nickname {
    BOOL changed = [DHTaskSetter checkForUpdateTask:self.task withDistributionNickname:nickname];
    if (!changed) { return ; }
    [self reloadDataWithItemType:DHTaskCreatorItemTypeDistribute];
}

- (void)distributeCell:(DHTaskCreatorDistributeItem *)distributeCell
      didChangedAPIKey:(NSString *)apiKey {
    BOOL changed = [DHTaskSetter checkForUpdateTask:self.task withDistributionAPIKey:apiKey];
    if (!changed) { return ; }
    [self reloadDataWithItemType:DHTaskCreatorItemTypeDistribute];
}
- (void)distributeCell:(DHTaskCreatorDistributeItem *)distributeCell
didChangedInstallPassword:(NSString *)installPassword {
    BOOL changed = [DHTaskSetter checkForUpdateTask:self.task withDistributionInstallPassword:installPassword];
    if (!changed) { return ; }
    [self reloadDataWithItemType:DHTaskCreatorItemTypeDistribute];
}
- (void)distributeCell:(DHTaskCreatorDistributeItem *)distributeCell
   didChangedChangeLog:(NSString *)changeLog {
    BOOL changed = [DHTaskSetter checkForUpdateTask:self.task withDistributionChangeLog:changeLog];
    if (!changed) { return ; }
    [self reloadDataWithItemType:DHTaskCreatorItemTypeDistribute];
}


#pragma mark *** archive ***
- (void)archiveCell:(DHTaskCreatorArchiveItem *)archiveCell didChangedIPADir:(NSString *)ipaDir {
    self.task.exportIPADirectory = ipaDir;
}

#pragma mark *** profile ***
- (void)profileCell:(DHTaskCreatorProfileItem *)profileCell didChangedPath:(NSString *)path {
    BOOL changed = [DHTaskSetter checkForUpdateTask:self.task withProfile:path];
    if (!changed) { return ; }
    [self reloadData];
}

- (void)profileCell:(DHTaskCreatorProfileItem *)profileCell didChangedName:(NSString *)name {
    BOOL changed = [DHTaskSetter checkForUpdateTask:self.task withProfileName:name];
    if (!changed) { return ; }
    [self reloadData];
}


#pragma mark - event response
- (IBAction)previousAction:(id)sender {
    if (self.backward) { self.backward(); }
    [self.parentWindow endSheet:self];
}

- (IBAction)cancelAction:(id)sender {
    [self.parentWindow endSheet:self];
}

- (IBAction)doneAction:(id)sender {
    [self endEditingFor:nil];
    if (self.callback) { self.callback(self.task); }
    [self.parentWindow endSheet:self];
}

#pragma mark - getter & setter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
