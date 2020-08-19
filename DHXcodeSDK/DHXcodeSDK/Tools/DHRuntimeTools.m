//
//  DHRuntimeTools.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHRuntimeTools.h"
#import <objc/runtime.h>

@implementation DHRuntimeTools

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
                // id
                [aCoder encodeObject:[obj valueForKey:pName] forKey:pName];
            } else if ([pTypes containsObject:@"Tc"]) {
                // BOOL
                [aCoder encodeBool:[(NSNumber *)[obj valueForKey:pName] boolValue] forKey:pName];
            } else if ([pTypes containsObject:@"Tl"]) {
                // long NSInteger
                [aCoder encodeInteger:[(NSNumber *)[obj valueForKey:pName] integerValue] forKey:pName];
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
            } else if ([pTypes containsObject:@"Tl"]) {
                // long NSInteger
                [obj setValue:@([aDecoder decodeIntegerForKey:pName]) forKey:pName];
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
