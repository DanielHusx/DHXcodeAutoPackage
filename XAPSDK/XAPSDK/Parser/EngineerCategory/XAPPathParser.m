//
//  XAPPathParser.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPPathParser.h"

@implementation XAPPathParser

- (id)handlePath:(NSString *)path externalInfo:(NSDictionary *)externalInfo error:(NSError *__autoreleasing  _Nullable *)error {
    if (![XAPTools isPathExist:path]) {
        return nil;
    }
    
    return [self.nextHandler handlePath:path externalInfo:externalInfo error:error];
}


@end
