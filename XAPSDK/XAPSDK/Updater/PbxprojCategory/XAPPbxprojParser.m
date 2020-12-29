//
//  XAPPbxprojParser.m
//  github: https://github.com/DanielHusx/XAPXcodeAutoPackage
//
//  Created by Daniel on 2020/12/29.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "XAPPbxprojParser.h"

XAPUniqueMark const kXAPUniqueMarkAssignment = @";";
XAPUniqueMark const kXAPUniqueMarkDictionaryStart = @"{";
XAPUniqueMark const kXAPUniqueMarkDictionaryEnd = @"}";
XAPUniqueMark const kXAPUniqueMarkArrayStart = @"(";
XAPUniqueMark const kXAPUniqueMarkArrayEnd = @")";

/// 获取两区间内中间的区间
NS_INLINE NSRange XAPMakeContentRange(NSRange start, NSRange end) {
    NSRange r;
    r.location = start.location + start.length;
    r.length = end.location - (start.location + start.length);
    return r;
}

/// 判断区间是否是NotFound
NS_INLINE BOOL XAPRangeNotFound(NSRange r) {
    return (r.location == NSNotFound) || (r.location == 0 && r.length == 0);
}


@implementation NSString (XAPPbxprojParser)
#pragma mark - *** 表达式操作(Public) ***
- (BOOL)updateAssigmentForValue:(NSString *)value
                        withKey:(NSString *)key
                          range:(NSRange)range
                 replacedString:(NSString **)replacedString {
    NSString *currentValue;
    NSRange currentValueRange;
    // 查找到现在值的区间
    BOOL ret = [self findAssignmentWithKey:key
                                     range:range
                                     value:&currentValue
                                valueRange:&currentValueRange];
    if (!ret) { return NO; }
    // 规范值
    value = [value regulatePBXProjSetterValue];
    // 更换
    *replacedString = [self stringByReplacingCharactersInRange:currentValueRange withString:value];
    
    return YES;
}

- (BOOL)appendAssigmentWithKey:(NSString *)key
                         value:(NSString *)value
                         range:(NSRange)range
                  appendString:(NSString **)appendString {
    NSString *line;
    NSRange lineRange;
    // 获取range内最后一条赋值表达式的行区间内容
    BOOL ret = [self findLineStringWithKey:kXAPUniqueMarkAssignment
                                   options:NSBackwardsSearch range:range
                                outputLine:&line
                           outputLineRange:&lineRange];
    if (!ret) { return NO; }
    // 获取该行的前缀空白区间内容
    NSString *content = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSRange contentRange = [line rangeOfString:content];
    NSString *prefixEmpty = [line substringToIndex:contentRange.location];
    
    // 组装表达式
    NSString *assigment = [NSString stringWithFormat:@"%@%@ = %@%@\n", prefixEmpty, key, [value regulatePBXProjSetterValue], kXAPUniqueMarkAssignment];
    
    // 插入
    NSRange insertRange = NSMakeRange(lineRange.location + lineRange.length, 0);
    *appendString = [self stringByReplacingCharactersInRange:insertRange withString:assigment];
    
    return YES;
}

- (BOOL)deleteAssigmentForKey:(NSString *)key
                        range:(NSRange)range
                 deleteString:(NSString **)deleteString {
    NSString *currentValue;
    NSRange currentValueRange;
    // 查找到现在值的区间
    BOOL ret = [self findAssignmentWithKey:key
                                     range:range
                                     value:&currentValue
                                valueRange:&currentValueRange];
    if (!ret) { return NO; }
    // 得到所在行的区间
    NSRange lineRange = [self lineRangeForRange:currentValueRange];
    // 删除区间字符串
    *deleteString = [self stringByReplacingCharactersInRange:lineRange withString:@""];
    return YES;
}


#pragma mark - *** 查找（全字符区间）(Public) ***
- (BOOL)findKeyValueWithKey:(NSString *)key
                 uniqueMark:(NSString *)uniqueMark
                      value:(id *)value
                 valueRange:(NSRange *)valueRange {
    return [self findKeyValueWithKey:key
                          uniqueMark:uniqueMark
                               range:NSMakeRange(0, self.length)
                               value:value
                          valueRange:valueRange];
}

- (BOOL)findAssignmentWithKey:(NSString *)key
                        value:(id *)value
                   valueRange:(NSRange *)valueRange {
    return [self findKeyValueWithKey:key
                          uniqueMark:kXAPUniqueMarkAssignment
                               range:NSMakeRange(0, self.length)
                               value:value
                          valueRange:valueRange];
}

- (BOOL)findDictionaryWithKey:(NSString *)key
                        value:(id *)value
                   valueRange:(NSRange *)valueRange {
    return [self findKeyValueWithKey:key
                          uniqueMark:kXAPUniqueMarkDictionaryStart
                               range:NSMakeRange(0, self.length)
                               value:value
                          valueRange:valueRange];
}

- (BOOL)findArrayWithKey:(NSString *)key
                   value:(id *)value
              valueRange:(NSRange *)valueRange {
    return [self findKeyValueWithKey:key
                          uniqueMark:kXAPUniqueMarkArrayStart
                               range:NSMakeRange(0, self.length)
                               value:value
                          valueRange:valueRange];
}


#pragma mark - *** 查找（限定区间）(Public) ***
- (BOOL)findAssignmentWithKey:(NSString *)key
                        range:(NSRange)range
                        value:(id *)value
                   valueRange:(NSRange *)valueRange {
    return [self findKeyValueWithKey:key
                          uniqueMark:kXAPUniqueMarkAssignment
                               range:range
                               value:value
                          valueRange:valueRange];
}

- (BOOL)findDictionaryWithKey:(NSString *)key
                        range:(NSRange)range
                        value:(id *)value
                   valueRange:(NSRange *)valueRange {
    return [self findKeyValueWithKey:key
                          uniqueMark:kXAPUniqueMarkDictionaryStart
                               range:range
                               value:value
                          valueRange:valueRange];
}

- (BOOL)findArrayWithKey:(NSString *)key
                   range:(NSRange)range
                   value:(id *)value
              valueRange:(NSRange *)valueRange {
    return [self findKeyValueWithKey:key
                          uniqueMark:kXAPUniqueMarkArrayStart
                               range:range
                               value:value
                          valueRange:valueRange];
}

/// 核心方法
- (BOOL)findKeyValueWithKey:(NSString *)key
                 uniqueMark:(NSString *)uniqueMark
                      range:(NSRange)range
                      value:(id *)value
                 valueRange:(NSRange *)valueRange {
    NSString *lineString;
    NSRange lineRange;
    if (XAPRangeNotFound(range)) { range = NSMakeRange(0, self.length); }
    // 查找到匹配位置的行
    BOOL ret = [self findLineStringWithKey:key
                                uniqueMark:uniqueMark
                                     range:range
                                outputLine:&lineString
                           outputLineRange:&lineRange];
    if (!ret) { return NO; }
    
    if ([uniqueMark isEqualToString:kXAPUniqueMarkAssignment]) {
        // 赋值
        return [self parseAssignmentWithLine:lineString
                                   lineRange:lineRange
                                       value:value
                                  valueRange:valueRange];
    } else if ([uniqueMark isEqualToString:kXAPUniqueMarkDictionaryStart]) {
        // 字典
        return [self parseDictionaryWithLine:lineString
                                   lineRange:lineRange
                                       value:value
                                  valueRange:valueRange];
    } else if ([uniqueMark isEqualToString:kXAPUniqueMarkArrayStart]) {
        // 数组
        return [self parseArrayWithLine:lineString
                              lineRange:lineRange
                                  value:value
                             valueRange:valueRange];
    }
    
    *value = lineString;
    *valueRange = lineRange;
    
    return YES;
}


#pragma mark - *** 查找（表达式开始行）（Private） ***
- (BOOL)findLineStringWithKey:(NSString *)key
                   uniqueMark:(NSString *)uniqueMark
                        range:(NSRange)range
                   outputLine:(NSString **)outputLine
              outputLineRange:(NSRange *)outputLineRange {
    NSRange r = range;
    NSRange lRange;
    NSString *lString;
    do {
        // 查找包含key的区间
        r = [self rangeOfString:key options:NSLiteralSearch range:r];
        if (XAPRangeNotFound(r)) { break; }
        
        // 获取包含key的行 区间
        lRange = [self lineRangeForRange:r];
        lString = [self substringWithRange:lRange];
        
        // 如果存在期望字符，则判断该行是否包含期望唯一字符串，没有期望字符，则直接通过
        if (!uniqueMark || (uniqueMark && [lString containsString:uniqueMark])) {
            *outputLine = lString;
            *outputLineRange = lRange;
            return YES;
        }
        
        // 找到的不符合标准，则从剩下的字符串继续查找
        r = NSMakeRange(lRange.location + lRange.length, range.length - (lRange.location + lRange.length));
        
    } while(1);
    
    return NO;
}

- (BOOL)findLineStringWithKey:(NSString *)key
                      options:(NSStringCompareOptions)options
                        range:(NSRange)range
                   outputLine:(NSString **)outputLine
              outputLineRange:(NSRange *)outputLineRange {
    NSRange r = range;
    NSRange lRange;
    NSString *lString;
    
    // 查找包含key的区间
    r = [self rangeOfString:key options:options range:r];
    if (XAPRangeNotFound(r)) { return NO; }
        
    // 获取包含key的行 区间
    lRange = [self lineRangeForRange:r];
    lString = [self substringWithRange:lRange];
        
    *outputLine = lString;
    *outputLineRange = lRange;
    return YES;
        
}

#pragma mark - 解析值及其所在区间
- (BOOL)parseAssignmentWithLine:(NSString *)line
                      lineRange:(NSRange)lineRange
                          value:(id *)value
                     valueRange:(NSRange *)valueRange {
    NSRange vStartRange = [line rangeOfString:@"="];
    if (XAPRangeNotFound(vStartRange)) { return NO; }
    
    NSRange vEndRange = [line rangeOfString:kXAPUniqueMarkAssignment];
    if (XAPRangeNotFound(vEndRange)) { return NO; }
    
    
    // 解析字符串
    if ([line containsString:@"/*"] && [line containsString:@"*/"]) {
        vEndRange = [line rangeOfString:@"/*"];
    }
    
    NSString *vString;
    // 此时拿到的是=与结束符（/*或者;)之间的内容，可能存在其他字符
    vString = [line substringWithRange:XAPMakeContentRange(vStartRange, vEndRange)];
    vString = [vString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([vString containsString:@"\""]) {
        // 剔除前后的双引号
        NSMutableArray *component = [[vString componentsSeparatedByString:@"\""] mutableCopy];
        if ([component count] >= 3) {
            if (![XAPTools isValidString:component.firstObject]
                && ![XAPTools isValidString:component.lastObject]) {
                vStartRange = [line rangeOfString:@"\""];
                vEndRange = [line rangeOfString:@"\"" options:NSBackwardsSearch];
                [component removeObjectAtIndex:0];
                [component removeLastObject];
                vString = [component componentsJoinedByString:@""];
            }
        }
    }
    
    *value = vString;
    
    // 计算内容区间
    if (vString.length == 0) {
        // 空内容时，此时vStartRange，vEndRange记录的是双引号的位置
        *valueRange = NSMakeRange(lineRange.location+vStartRange.location, vStartRange.length+vEndRange.length);
    } else {
        // 匹配内容区间
        NSRange contentRange = [line rangeOfString:vString options:NSLiteralSearch range:XAPMakeContentRange(vStartRange, vEndRange)];
        *valueRange = NSMakeRange(lineRange.location+contentRange.location, contentRange.length);
    }
    
    return YES;
}

- (BOOL)parseDictionaryWithLine:(NSString *)line
                     lineRange:(NSRange)lineRange
                         value:(id *)value
                    valueRange:(NSRange *)valueRange {
    NSUInteger length = self.length;
    NSRange uniqueStartRange = [self rangeOfString:kXAPUniqueMarkDictionaryStart options:NSLiteralSearch range:lineRange];
    if (XAPRangeNotFound(uniqueStartRange)) { return NO; }
    
    NSRange sRange = NSMakeRange(lineRange.location, length - lineRange.location);
    NSRange eRange;
    NSString *content;
    NSRange contentRange;
    
    NSUInteger startCount;
    NSUInteger endCount;
    
    // 获取从 {(包含{)开始到 }(包含})结束的部分
    do {
        eRange = [self rangeOfString:kXAPUniqueMarkDictionaryEnd options:NSLiteralSearch range:sRange];
        if (XAPRangeNotFound(eRange)) { break; }
        
        // 内容从{所在行开始（包含{) 到 };的位置（包含};)
        contentRange = NSMakeRange(lineRange.location, eRange.location + eRange.length - lineRange.location);
        content = [self substringWithRange:contentRange];
        // 判断{,}个数是否相等，即代表对称
        startCount = [[content componentsSeparatedByString:kXAPUniqueMarkDictionaryStart] count];
        endCount = [[content componentsSeparatedByString:kXAPUniqueMarkDictionaryEnd] count];
        if (startCount == endCount) {
            
            *valueRange = NSMakeRange(uniqueStartRange.location, eRange.location+eRange.length-uniqueStartRange.location);
            *value = [self substringWithRange:*valueRange];
            return YES;
        }
        
        // 下一次};位置后一位开始，到字符串结尾
        sRange = NSMakeRange(eRange.location + eRange.length, length - (eRange.location + eRange.length));
        
    } while(1);
    
    return NO;
}

- (BOOL)parseArrayWithLine:(NSString *)line
                 lineRange:(NSRange)lineRange
                     value:(id *)value
                valueRange:(NSRange *)valueRange {
    NSUInteger length = self.length;
    NSRange uniqueStartRange = [self rangeOfString:kXAPUniqueMarkArrayStart options:NSLiteralSearch range:lineRange];
    if (XAPRangeNotFound(uniqueStartRange)) { return NO; }
    
    NSRange sRange = NSMakeRange(lineRange.location, length - lineRange.location);
    NSRange eRange;
    NSString *content;
    NSRange contentRange;
    
    NSUInteger startCount;
    NSUInteger endCount;
    // 获取从 ((包含{)开始到 )(包含))结束的部分
    do {
        eRange = [self rangeOfString:kXAPUniqueMarkArrayEnd options:NSLiteralSearch range:sRange];
        if (XAPRangeNotFound(eRange)) { break; }
        
        // 内容从(所在行开始（包含() 到 )的位置（包含)
        contentRange = NSMakeRange(lineRange.location, eRange.location + eRange.length - lineRange.location);
        content = [self substringWithRange:contentRange];
        // 判断(,)个数是否相等，即代表对称
        startCount = [[content componentsSeparatedByString:kXAPUniqueMarkArrayStart] count];
        endCount = [[content componentsSeparatedByString:kXAPUniqueMarkArrayEnd] count];
        if (startCount == endCount) {
            *valueRange = NSMakeRange(uniqueStartRange.location, eRange.location+eRange.length-uniqueStartRange.location);
            *value = [self substringWithRange:*valueRange];
            return YES;
        }
        
        // 下一次)位置后一位开始，到字符串结尾
        sRange = NSMakeRange(eRange.location + eRange.length, length - (eRange.location + eRange.length));
        
    } while(1);
    
    return NO;
}

/// 规范设置的值
- (NSString *)regulatePBXProjSetterValue {
    if (self.length == 0) { return @"\"\""; }
    return self;
}

@end

#pragma mark -
@implementation NSMutableString (XAPPbxprojParser)

- (BOOL)updateAssigmentForValue:(NSString *)value
                        withKey:(NSString *)key
                          range:(NSRange)range {
    NSString *currentValue;
    NSRange currentValueRange;
    // 查找到现在值的区间
    BOOL ret = [self findAssignmentWithKey:key
                                     range:range
                                     value:&currentValue
                                valueRange:&currentValueRange];
    if (!ret) { return NO; }
    // 规范设置值
    value = [value regulatePBXProjSetterValue];
    // 更换
    [self replaceCharactersInRange:currentValueRange withString:value];
    
    return YES;
}

- (BOOL)appendAssigmentWithKey:(NSString *)key
                         value:(NSString *)value
                         range:(NSRange)range {
    NSString *line;
    NSRange lineRange;
    // 获取range内最后一条赋值表达式的行区间内容
    BOOL ret = [self findLineStringWithKey:kXAPUniqueMarkAssignment
                                   options:NSBackwardsSearch range:range
                                outputLine:&line
                           outputLineRange:&lineRange];
    if (!ret) { return NO; }
    // 获取该行的前缀空白区间内容
    NSString *content = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSRange contentRange = [line rangeOfString:content];
    NSString *prefixEmpty = [line substringToIndex:contentRange.location];
    
    // 组装表达式
    NSString *assigment = [NSString stringWithFormat:@"%@%@ = %@%@\n", prefixEmpty, key, [value regulatePBXProjSetterValue], kXAPUniqueMarkAssignment];
    
    // 插入
    [self insertString:assigment atIndex:lineRange.location + lineRange.length];
    
    return YES;
}

- (BOOL)deleteAssigmentForKey:(NSString *)key
                        range:(NSRange)range {
    NSString *currentValue;
    NSRange currentValueRange;
    // 查找到现在值的区间
    BOOL ret = [self findAssignmentWithKey:key
                                     range:range
                                     value:&currentValue
                                valueRange:&currentValueRange];
    if (!ret) { return NO; }
    // 得到所在行的区间
    NSRange lineRange = [self lineRangeForRange:currentValueRange];
    // 删除区间字符串
    [self deleteCharactersInRange:lineRange];
    return YES;
}

@end


#pragma mark - buildSettings扩展
@implementation NSMutableString (XAPPbxprojBuildSettings)

- (BOOL)updateBuildSettingsWithKey:(NSString *)buildSettingsKey
                             value:(NSString *)buildSettingsValue
             buildConfiguratioinId:(NSString *)buildConfiguratioinId {
    NSString *value;
    NSRange valueRange;
    BOOL ret = NO;
    // 查找配置的值与位置——每次都得重新计算是因为其他更改，可能导致Range变了
    ret = [self findDictionaryWithKey:buildConfiguratioinId
                                value:&value
                           valueRange:&valueRange];
    if (!ret) { return NO; }
    NSRange buildConfigurationRange = valueRange;

    // 查找buildSettings的值与位置——此处是相对于buildConfiguration的值计算的
    ret = [self findDictionaryWithKey:@"buildSettings"
                                range:buildConfigurationRange
                                value:&value
                           valueRange:&valueRange];
    if (!ret) { return NO; }

    // 此位置是对于整个pbxprojString来说的
    NSRange buildSettingsRange = valueRange;

    // 设置
    ret = [self updateAssigmentForValue:buildSettingsValue
                                withKey:buildSettingsKey
                                  range:buildSettingsRange];
    if (!ret) { return NO; }

    return YES;
}

- (BOOL)appendBuildSettingsWithKey:(NSString *)buildSettingsKey
                             value:(NSString *)buildSettingsValue
             buildConfiguratioinId:(NSString *)buildConfiguratioinId {
    NSString *value;
    NSRange valueRange;
    BOOL ret = NO;
    // 查找配置的值与位置——每次都得重新计算是因为其他更改，可能导致Range变了
    ret = [self findDictionaryWithKey:buildConfiguratioinId
                                value:&value
                           valueRange:&valueRange];
    if (!ret) { return NO; }
    NSRange buildConfigurationRange = valueRange;

    // 查找buildSettings的值与位置——此处是相对于buildConfiguration的值计算的
    ret = [self findDictionaryWithKey:@"buildSettings"
                                range:buildConfigurationRange
                                value:&value
                           valueRange:&valueRange];
    if (!ret) { return NO; }

    // 此位置是对于整个pbxprojString来说的
    NSRange buildSettingsRange = valueRange;

    // 新增
    ret = [self appendAssigmentWithKey:buildSettingsKey
                                 value:buildSettingsValue
                                 range:buildSettingsRange];
    if (!ret) { return NO; }

    return YES;
}

- (BOOL)removeBuildSettingsWithKey:(NSString *)buildSettingsKey
             buildConfiguratioinId:(NSString *)buildConfiguratioinId {
    NSString *value;
    NSRange valueRange;
    BOOL ret = NO;
    // 查找配置的值与位置——每次都得重新计算是因为其他更改，可能导致Range变了
    ret = [self findDictionaryWithKey:buildConfiguratioinId
                                value:&value
                           valueRange:&valueRange];
    if (!ret) { return NO; }
    NSRange buildConfigurationRange = valueRange;

    // 查找buildSettings的值与位置——此处是相对于buildConfiguration的值计算的
    ret = [self findDictionaryWithKey:@"buildSettings"
                                range:buildConfigurationRange
                                value:&value
                           valueRange:&valueRange];
    if (!ret) { return NO; }

    // 此位置是对于整个pbxprojString来说的
    NSRange buildSettingsRange = valueRange;

    // 新增
    ret = [self deleteAssigmentForKey:buildSettingsKey
                                range:buildSettingsRange];
    if (!ret) { return NO; }

    return YES;
}

@end
