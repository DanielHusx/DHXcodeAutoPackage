//
//  DHZIPUtils.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHZIPUtils.h"
#import "DHZIPTools.h"

@implementation DHZIPUtils

+ (NSString *)unzipIPAFile:(NSString *)ipaFile {
    NSString *ipaDirectory = [ipaFile stringByDeletingPathExtension];
    NSString *unzippedPath = [self unzipIPAFile:ipaFile toDestination:ipaDirectory];
    return unzippedPath;
}

+ (nullable NSString *)unzipIPAFile:(NSString *)ipaFile toDestination:(NSString *)destination {
    // 解压
    NSString *unzipPath;
    NSError *error;
    DHERROR_CODE ret = [DHZIPTools unzipFileAtPath:ipaFile
                                     toDestination:destination
                                      unzippedPath:&unzipPath
                                             error:&error];
    DHXcodeLog(@"Unzip ipa file result: %zd\n\
[error: %@]\n\
[ipaFile: %@]\n\
[unzippedPath: %@]",
                 ret, error, ipaFile, unzipPath);
    if (!dh_isNoError(ret)) { return nil; }

    
    return unzipPath;
}

@end
