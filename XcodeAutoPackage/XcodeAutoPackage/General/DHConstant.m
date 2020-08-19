//
//  DHConstant.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/14.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHConstant.h"


NSErrorDomain const kDHErrorDomain = @"com.daniel.applescript";

DHTaskTypeName const kDHTaskTypeNameArchive = @"归档";
DHTaskTypeName const kDHTaskTypeNameExport = @"导出";
DHTaskTypeName const kDHTaskTypeNameDistribute = @"发布";

NSNotificationName const kDHRowModifyNotificationName = @"DHRowModifyNotificationName";
NSNotificationName const kDHRowDeleteNotificationName = @"DHRowDeleteNotificationName";
NSNotificationName const kDHRowSelectNotificationName = @"DHRowSelectNotificationName";

NSNotificationName const kDHToolbarStatusNotificationName = @"DHToolbarStatusNotificationName";
NSNotificationName const kDHToolbarRunNotificationName = @"DHToolbarRunNotificationName";
NSNotificationName const kDHToolbarStopNotificationName = @"DHToolbarStopNotificationName";
NSNotificationName const kDHToolbarAddNotificationName = @"DHToolbarAddNotificationName";
NSNotificationName const kDHToolbarDeleteNotificationName = @"DHToolbarDeleteNotificationName";
NSNotificationName const kDHToolbarSettingNotificationName = @"DHToolbarSettingNotificationName";

NSNotificationName const kDHFilterConditionDidChangedNotificationName = @"kDHFilterConditionDidChangedNotificationName";



DHChannelName const kDHChannelNameUnknown = @"未知渠道类型";
DHChannelName const kDHChannelNameDevelopment = @"内部测试(Development)";
DHChannelName const kDHChannelNameAdHoc = @"内部测试(AdHoc)";
DHChannelName const kDHChannelNameEnterprise = @"企业分发";
DHChannelName const kDHChannelNameAppStore = @"商店分发";

DHDistributionPlatformName const kDHDistributionPlatformNameNone = @"无";
DHDistributionPlatformName const kDHDistributionPlatformNamePgyer = @"蒲公英";
DHDistributionPlatformName const kDHDistributionPlatformNameFir = @"蜂蜜";
