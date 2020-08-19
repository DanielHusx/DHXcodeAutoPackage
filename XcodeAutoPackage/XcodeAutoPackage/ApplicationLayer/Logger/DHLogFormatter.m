//
//  DHLogFormatter.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/27.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHLogFormatter.h"
#import "NSDate+DHDateFormat.h"

@implementation DHLogFormatter

+ (NSString *)formatStringForType:(DHLogType)type withString:(NSString *)string {
    return [self generateCompleteStringWithString:string type:type];
}

+ (NSAttributedString *)formatAttributeStringForType:(DHLogType)type withString:(NSString *)string {
    
    NSString *completedString = [self generateCompleteStringWithString:string type:type];
    NSMutableAttributedString *mAttri = [[NSMutableAttributedString alloc] initWithString:completedString
                                                                               attributes:[self defaultAttributes]];
    [mAttri addAttributes:[self attributesWithType:type] range:[completedString rangeOfString:[self prefixStringWithType:type]]];
    return [mAttri copy];
}

+ (NSString *)generateCompleteStringWithString:(NSString *)string type:(DHLogType)type {
    return [NSString stringWithFormat:@"%@ %@ %@\n", [self currentTimeString], [self prefixStringWithType:type], string];
}

+ (NSString *)currentTimeString {
    static NSDateFormatter *format;
    if (!format) {
        format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return [format stringFromDate:[NSDate date]];
}

+ (NSAttributedString *)prefixAttributeStringWithType:(DHLogType)type {
    return [[NSAttributedString alloc] initWithString:[self prefixStringWithType:type]
                                           attributes:[self attributesWithType:type]];
}

+ (NSDictionary *)attributesWithType:(DHLogType)type {
    switch (type) {
        case DHLogTypeScriptErrorStream:
        case DHLogTypeDataBaseError:
        case DHLogTypeBusinessError:
            // 错误都是红色
            return @{NSForegroundColorAttributeName:[NSColor redColor]};
            break;
        case DHLogTypeBusinessWarning:
            return @{NSForegroundColorAttributeName:[NSColor yellowColor]};
        default:
            break;
    }
    return [self defaultAttributes];
}

+ (NSDictionary *)defaultAttributes {
    return @{NSForegroundColorAttributeName:[NSColor whiteColor]};
}

+ (NSString *)prefixStringWithType:(DHLogType)type {
#ifdef DEBUG
    switch (type) {
        case DHLogTypeScriptDebug:
            return @"[SCRIPT]";
        case DHLogTypeScriptOutputStream:
            return @"[SCRIPT_OUT]";
        case DHLogTypeScriptErrorStream:
            return @"[SCRIPT_ERROR]";
        
        case DHLogTypeDataBaseInfo:
            return @"[DB_INFO]";
        case DHLogTypeDataBaseDebug:
            return @"[DB_DEBUG]";
        case DHLogTypeDataBaseError:
            return @"[DB_ERROR]";
            
        case DHLogTypeBusinessInfo:
            return @"[BS_INFO]";
        case DHLogTypeBusinessDebug:
            return @"[BS_DEBUG]";
        case DHLogTypeBusinessError:
            return @"[BS_ERROR]";
        case DHLogTypeBusinessWarning:
            return @"[BS_WARNING]";
        default:
            break;
    }
#else
    switch (type) {
        case DHLogTypeScriptDebug:
        case DHLogTypeDataBaseDebug:
        case DHLogTypeBusinessDebug:
            return @"[DEBUG]";
        case DHLogTypeScriptOutputStream:
            return @"[OUT]";
        case DHLogTypeScriptErrorStream:
        case DHLogTypeDataBaseError:
        case DHLogTypeBusinessError:
            return @"[ERROR]";
        case DHLogTypeBusinessWarning:
            return @"[WARNING]";
        case DHLogTypeDataBaseInfo:
        case DHLogTypeBusinessInfo:
            return @"[INFO]";
        default:
            break;
    }
#endif
    return @"[UNKNOW]";
}


@end
