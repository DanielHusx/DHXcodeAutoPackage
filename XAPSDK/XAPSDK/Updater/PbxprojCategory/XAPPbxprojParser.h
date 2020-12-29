//
//  XAPPbxprojParser.h
//  github: https://github.com/DanielHusx/XAPXcodeAutoPackage
//
//  Created by Daniel on 2020/12/29.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * XAPUniqueMark;
/// 表达式的唯一标记符
FOUNDATION_EXTERN XAPUniqueMark const kXAPUniqueMarkAssignment;
/// 字典起始的唯一标记符
FOUNDATION_EXTERN XAPUniqueMark const kXAPUniqueMarkDictionaryStart;
/// 字典结束的唯一标记符
FOUNDATION_EXTERN XAPUniqueMark const kXAPUniqueMarkDictionaryEnd;
/// 数组起始的唯一标记符
FOUNDATION_EXTERN XAPUniqueMark const kXAPUniqueMarkArrayStart;
/// 数组结束的唯一标记符
FOUNDATION_EXTERN XAPUniqueMark const kXAPUniqueMarkArrayEnd;
/**
 解析.pbxproj文件——通过查找去定位需要替换指定的表达式值
 */
@interface NSString (XAPPbxprojParser)
#pragma mark - 全区间查找

/// 查找key并且限定必须存在uniqueMark的表达式，然后获取对应的值
///
/// @param key 查找key
/// @param uniqueMark 限定标识
/// @param value out 值
/// @param valueRange out 值区间（相对self）
- (BOOL)findKeyValueWithKey:(NSString *)key
                 uniqueMark:(NSString *)uniqueMark
                      value:(id _Nullable * _Nullable)value
                 valueRange:(NSRange *)valueRange;
/// 全区间 查找key并且限定必须存在uniqueMark的赋值表达式
///
/// @param key 查找key
/// @param value out 值
/// @param valueRange out 值区间（相对self）
- (BOOL)findAssignmentWithKey:(NSString *)key
                        value:(id _Nullable * _Nullable)value
                   valueRange:(NSRange *)valueRange;
/// 全区间 查找key并且限定必须存在uniqueMark的字典赋值表达式
///
/// @param key 查找key
/// @param value out 值
/// @param valueRange out 值区间（相对self）
- (BOOL)findDictionaryWithKey:(NSString *)key
                        value:(id _Nullable * _Nullable)value
                   valueRange:(NSRange *)valueRange;
/// 全区间 查找key并且限定必须存在uniqueMark的数组赋值表达式
///
/// @param key 查找key
/// @param value out 值
/// @param valueRange out 值区间（相对self）
- (BOOL)findArrayWithKey:(NSString *)key
                   value:(id _Nullable * _Nullable)value
              valueRange:(NSRange *)valueRange;

#pragma mark - 限定区间查找
/// range区间内 查找key并且限定必须存在uniqueMark的赋值表达式
///
/// @param key 查找key
/// @param range 查找区间
/// @param value out 值
/// @param valueRange out 值区间（相对self）
- (BOOL)findAssignmentWithKey:(NSString *)key
                        range:(NSRange)range
                        value:(id _Nullable * _Nullable)value
                   valueRange:(NSRange *)valueRange;
/// range区间内 查找key并且限定必须存在uniqueMark的字典赋值表达式
///
/// @param key 查找key
/// @param range 查找区间
/// @param value out 值
/// @param valueRange out 值区间（相对self）
- (BOOL)findDictionaryWithKey:(NSString *)key
                        range:(NSRange)range
                        value:(id _Nullable * _Nullable)value
                   valueRange:(NSRange *)valueRange;
/// range区间内 查找key并且限定必须存在uniqueMark的数组赋值表达式
///
/// @param key 查找key
/// @param range 查找区间
/// @param value out 值
/// @param valueRange out 值区间（相对self）
- (BOOL)findArrayWithKey:(NSString *)key
                   range:(NSRange)range
                   value:(id _Nullable * _Nullable)value
              valueRange:(NSRange *)valueRange;
/// range区间内 查找key并且限定必须存在uniqueMark的表达式
///
/// @param key 查找key
/// @param uniqueMark 限定标识
/// @param range 查找区间
/// @param value out 值
/// @param valueRange out 值区间（相对self）
- (BOOL)findKeyValueWithKey:(NSString *)key
                 uniqueMark:(NSString *)uniqueMark
                      range:(NSRange)range
                      value:(id _Nullable * _Nullable)value
                 valueRange:(NSRange *)valueRange;

#pragma mark - 替换

/// 查找赋值表达式后设置值
///
/// @param value 设置的值
/// @param key 查找key
/// @param range 查找区间（buildSettings字典区间）
/// @param replacedString 设置替换后的新的字符串
- (BOOL)updateAssigmentForValue:(NSString *)value
                        withKey:(NSString *)key
                          range:(NSRange)range
                 replacedString:(NSString * _Nullable * _Nonnull)replacedString;

/// 添加赋值表达式
///
/// @param key 表达式键
/// @param value 表达式值
/// @param range 查找区间（buildSettings字典区间）
/// @param appendString 添加后的完整字符串
- (BOOL)appendAssigmentWithKey:(NSString *)key
                         value:(NSString *)value
                         range:(NSRange)range
                  appendString:(NSString * _Nullable * _Nonnull)appendString;
/// 删除赋值表达式
///
/// @param key 表达式键
/// @param range 查找区间（buildSettings字典区间）
/// @param deleteString 删除后的完整字符串
- (BOOL)deleteAssigmentForKey:(NSString *)key
                        range:(NSRange)range
                 deleteString:(NSString * _Nullable * _Nonnull)deleteString;
@end

#pragma mark -
@interface NSMutableString (XAPPbxprojParser)
/// 查找赋值表达式后设置值
///
/// @param value 设置的值
/// @param key 查找key
/// @param range 查找区间（buildSettings字典区间）
- (BOOL)updateAssigmentForValue:(NSString *)value
                        withKey:(NSString *)key
                          range:(NSRange)range;

/// 添加赋值表达式
///
/// @param key 表达式键
/// @param value 表达式值
/// @param range 查找区间（buildSettings字典区间）
- (BOOL)appendAssigmentWithKey:(NSString *)key
                         value:(NSString *)value
                         range:(NSRange)range;

/// 删除赋值表达式
///
/// @param key 表达式键
/// @param range 查找区间（buildSettings字典区间）
- (BOOL)deleteAssigmentForKey:(NSString *)key
                        range:(NSRange)range;

@end


#pragma mark - buildSettings扩展
@interface NSMutableString (XAPPbxprojBuildSettings)

/// 更新buildSettings的表达式值
///
/// @param buildSettingsKey 表达式键
/// @param buildSettingsValue  表达式值
/// @param buildConfiguratioinId 编译配置id
- (BOOL)updateBuildSettingsWithKey:(NSString *)buildSettingsKey
                             value:(NSString *)buildSettingsValue
             buildConfiguratioinId:(NSString *)buildConfiguratioinId;

/// 添加buildSettings的表达式值
///
/// @param buildSettingsKey 表达式键
/// @param buildSettingsValue  表达式值
/// @param buildConfiguratioinId 编译配置id
- (BOOL)appendBuildSettingsWithKey:(NSString *)buildSettingsKey
                             value:(NSString *)buildSettingsValue
             buildConfiguratioinId:(NSString *)buildConfiguratioinId;

/// 删除buildSettings的表达式值
///
/// @param buildSettingsKey 表达式键
/// @param buildConfiguratioinId 编译配置id
- (BOOL)removeBuildSettingsWithKey:(NSString *)buildSettingsKey
             buildConfiguratioinId:(NSString *)buildConfiguratioinId;

@end
NS_ASSUME_NONNULL_END
