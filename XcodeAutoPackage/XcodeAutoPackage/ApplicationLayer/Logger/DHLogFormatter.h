//
//  DHLogFormatter.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/27.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, DHLogType) {
    DHLogTypeDataBaseDebug,
    DHLogTypeDataBaseInfo,
    DHLogTypeDataBaseError,
    
    DHLogTypeBusinessDebug,
    DHLogTypeBusinessInfo,
    DHLogTypeBusinessWarning,
    DHLogTypeBusinessError,
    
    DHLogTypeScriptDebug,
    DHLogTypeScriptOutputStream,
    DHLogTypeScriptErrorStream,
};
NS_ASSUME_NONNULL_BEGIN

@interface DHLogFormatter : NSObject

+ (NSString *)formatStringForType:(DHLogType)type
                       withString:(NSString *)string;
+ (NSAttributedString *)formatAttributeStringForType:(DHLogType)type
                                          withString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
