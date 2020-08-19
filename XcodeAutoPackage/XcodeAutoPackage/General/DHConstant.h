//
//  DHConstant.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/14.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

FOUNDATION_EXTERN NSErrorDomain const kDHErrorDomain;


typedef NSString * DHTaskTypeName NS_STRING_ENUM;

FOUNDATION_EXTERN DHTaskTypeName const kDHTaskTypeNameArchive;
FOUNDATION_EXTERN DHTaskTypeName const kDHTaskTypeNameExport;
FOUNDATION_EXTERN DHTaskTypeName const kDHTaskTypeNameDistribute;

/// 行点击修改
FOUNDATION_EXTERN NSNotificationName const kDHRowModifyNotificationName;
/// 行点击删除
FOUNDATION_EXTERN NSNotificationName const kDHRowDeleteNotificationName;
/// 行点击CheckButton
FOUNDATION_EXTERN NSNotificationName const kDHRowSelectNotificationName;

/// Toolbar点击中间是Status
FOUNDATION_EXTERN NSNotificationName const kDHToolbarStatusNotificationName;
/// Toolbar点击运行
FOUNDATION_EXTERN NSNotificationName const kDHToolbarRunNotificationName;
/// Toolbar点击停止
FOUNDATION_EXTERN NSNotificationName const kDHToolbarStopNotificationName;
/// Toolbar点击添加任务
FOUNDATION_EXTERN NSNotificationName const kDHToolbarAddNotificationName;
/// Toolbar点击删除任务
FOUNDATION_EXTERN NSNotificationName const kDHToolbarDeleteNotificationName;
/// Toolbar点击设置
FOUNDATION_EXTERN NSNotificationName const kDHToolbarSettingNotificationName;

/// 筛选条件改变通知 object: @(DHFilterCondition)
FOUNDATION_EXTERN NSNotificationName const kDHFilterConditionDidChangedNotificationName;



typedef NSString * DHChannelName NS_STRING_ENUM;

FOUNDATION_EXTERN DHChannelName const kDHChannelNameUnknown;
FOUNDATION_EXTERN DHChannelName const kDHChannelNameDevelopment;
FOUNDATION_EXTERN DHChannelName const kDHChannelNameAdHoc;
FOUNDATION_EXTERN DHChannelName const kDHChannelNameEnterprise;
FOUNDATION_EXTERN DHChannelName const kDHChannelNameAppStore;

typedef NSString * DHDistributionPlatformName NS_STRING_ENUM;

FOUNDATION_EXTERN DHDistributionPlatformName const kDHDistributionPlatformNameNone;
FOUNDATION_EXTERN DHDistributionPlatformName const kDHDistributionPlatformNamePgyer;
FOUNDATION_EXTERN DHDistributionPlatformName const kDHDistributionPlatformNameFir;


static inline BOOL converStateToBoolean(NSControlStateValue value) {
    return value == NSControlStateValueOn;
}

static inline NSControlStateValue converBooleanToState(BOOL value) {
    return value?NSControlStateValueOn:NSControlStateValueOff;
}
