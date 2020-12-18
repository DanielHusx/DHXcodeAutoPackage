//
//  XAPDirectoryParser.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPDirectoryParser.h"

@implementation XAPDirectoryParser

- (XAPEngineerModel *)handlePath:(NSString *)path error:(NSError * __autoreleasing _Nullable * _Nullable)error {
    if (![XAPTools isDirectoryPath:path]) {
        return nil;
    }
    return nil;
}

@end
