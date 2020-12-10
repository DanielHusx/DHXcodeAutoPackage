//
//  XAPRuntimeTools.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import "XAPRuntimeTools.h"
#import <objc/runtime.h>

@implementation XAPRuntimeTools

// 加密对象
+ (void)encodeObject:(NSObject *)obj coder:(NSCoder *)aCoder {
    unsigned int pCount;
    
    objc_property_t *properties = class_copyPropertyList([(NSObject *)obj class], &pCount);
    if (properties) {
        for (int i = 0; i < pCount; i++) {
            NSString *pName = @(property_getName(properties[i]));
            NSString *pType = @(property_getAttributes(properties[i]));
            NSArray *pTypes = [pType componentsSeparatedByString:@","];
            // 过滤只读属性
            if ([pTypes containsObject:@"R"]) { continue; }
            
            if ([pType containsString:@"T@"]) {
                // id, 对象
                [aCoder encodeObject:[obj valueForKey:pName] forKey:pName];
            } else if ([pTypes containsObject:@"Tc"]) {
                // BOOL
                [aCoder encodeBool:[(NSNumber *)[obj valueForKey:pName] boolValue] forKey:pName];
            } else if ([pTypes containsObject:@"Tl"] || [pTypes containsObject:@"Tq"] || [pTypes containsObject:@"TQ"]) {
                // long, NSInteger, long long, NSUInteger
                [aCoder encodeInteger:[(NSNumber *)[obj valueForKey:pName] integerValue] forKey:pName];
            } else if ([pTypes containsObject:@"Td"]) {
                // double, CGFloat
                [aCoder encodeDouble:[(NSNumber *)[obj valueForKey:pName] doubleValue] forKey:pName];
            } else if ([pTypes containsObject:@"Tf"]) {
                // float
                [aCoder encodeFloat:[(NSNumber *)[obj valueForKey:pName] floatValue] forKey:pName];
            } else if ([pTypes containsObject:@"T{CGSize=dd}"]) {
                // CGSize
                [aCoder encodeSize:[(NSNumber *)[obj valueForKey:pName] sizeValue] forKey:pName];
            } else if ([pTypes containsObject:@"T{CGPoint=dd"]) {
                // CGPoint
                [aCoder encodePoint:[(NSNumber *)[obj valueForKey:pName] pointValue] forKey:pName];
            } else if ([pTypes containsObject:@"T{CGRect={CGPoint=dd}{CGSize=dd}}"]) {
                // CGRect
                [aCoder encodeRect:[(NSNumber *)[obj valueForKey:pName] rectValue] forKey:pName];
            }
            
        }
        free(properties);
    }

}

// 解密对象
+ (void)decodeObject:(NSObject *)obj coder:(NSCoder *)aDecoder {
    unsigned int pCount;
    objc_property_t *properties = class_copyPropertyList([obj class], &pCount);
    if (properties) {
        for (int i = 0; i < pCount; i++) {
            NSString *pName = @(property_getName(properties[i]));
            NSString *pType = @(property_getAttributes(properties[i]));
            NSArray *pTypes = [pType componentsSeparatedByString:@","];
            // 过滤只读属性
            if ([pTypes containsObject:@"R"]) { continue; }
            
            
            if ([pType containsString:@"T@"]) {
                // id
                [obj setValue:[aDecoder decodeObjectForKey:pName] forKey:pName];
            } else if ([pTypes containsObject:@"Tc"]) {
                // BOOL
                [obj setValue:@([aDecoder decodeBoolForKey:pName]) forKey:pName];
            } else if ([pTypes containsObject:@"Tl"] || [pTypes containsObject:@"Tq"]) {
                // long NSInteger
                [obj setValue:@([aDecoder decodeIntegerForKey:pName]) forKey:pName];
            } else if ([pTypes containsObject:@"Td"]) {
                // double, CGFloat
                [obj setValue:@([aDecoder decodeDoubleForKey:pName]) forKey:pName];
            } else if ([pTypes containsObject:@"Tf"]) {
                // float
                [obj setValue:@([aDecoder decodeFloatForKey:pName]) forKey:pName];
            } else if ([pTypes containsObject:@"T{CGSize=dd}"]) {
                // CGSize
                [obj setValue:@([aDecoder decodeSizeForKey:pName]) forKey:pName];
            } else if ([pTypes containsObject:@"T{CGPoint=dd"]) {
                // CGPoint
                [obj setValue:@([aDecoder decodePointForKey:pName]) forKey:pName];
            } else if ([pTypes containsObject:@"T{CGRect={CGPoint=dd}{CGSize=dd}}"]) {
                // CGRect
                [obj setValue:@([aDecoder decodeRectForKey:pName]) forKey:pName];
            }
        }
        free(properties);
    }
}

// 拷贝对象
+ (void)copyObject:(NSObject *)copyObj fromObject:(NSObject *)obj {
    unsigned int pCount;
    objc_property_t *properties = class_copyPropertyList([obj class], &pCount);
    if (properties) {
        NSMutableArray *pArray = [NSMutableArray arrayWithCapacity:pCount];
        NSMutableArray *pTypes = [NSMutableArray arrayWithCapacity:pCount];
        for (int i = 0; i < pCount ; i++) {
            [pArray addObject:@(property_getName(properties[i]))];
            [pTypes addObject:@(property_getAttributes(properties[i]))];
        }
        free(properties);
        
        for (int j = 0; j < pCount ; j++) {
            NSString *pName = [pArray objectAtIndex:j];
            NSString *pType = [pTypes objectAtIndex:j];
            
            // 过滤只读属性
            if ([[pType componentsSeparatedByString:@","] containsObject:@"R"]) { continue; }
            
            id value = [obj valueForKey:pName];
            if ([value respondsToSelector:@selector(mutableCopyWithZone:)]) {
                [copyObj setValue:[value mutableCopy] forKey:pName];
            } else if([value respondsToSelector:@selector(copyWithZone:)]) {
                [copyObj setValue:[value copy] forKey:pName];
            } else {
                [copyObj setValue:value forKey:pName];
            }
        }
        [pArray removeAllObjects];
    }
}

// 深拷贝对象
+ (void)mutableCopyObject:(NSObject *)mutableCopyObj fromObject:(NSObject *)obj {
    unsigned int pCount;
    objc_property_t* properties = class_copyPropertyList([obj class], &pCount);
    if (properties) {
        NSMutableArray *pArray = [NSMutableArray arrayWithCapacity:pCount];
        NSMutableArray *pTypes = [NSMutableArray arrayWithCapacity:pCount];
        for (int i = 0; i < pCount; i++) {
            [pArray addObject:@(property_getName(properties[i]))];
            [pTypes addObject:@(property_getAttributes(properties[i]))];
        }
        free(properties);
        
        for (int j = 0; j < pCount; j++) {
            NSString *pName = [pArray objectAtIndex:j];
            NSString *pType = [pTypes objectAtIndex:j];
            
            // 过滤只读属性
            if ([[pType componentsSeparatedByString:@","] containsObject:@"R"]) { continue; }
            
            id value = [self valueForKey:pName];
            if ([value respondsToSelector:@selector(mutableCopyWithZone:)]) {
                [mutableCopyObj setValue:[value mutableCopy] forKey:pName];
            } else {
                [mutableCopyObj setValue:value forKey:pName];
            }
        }
        [pArray removeAllObjects];
    }
}

@end
