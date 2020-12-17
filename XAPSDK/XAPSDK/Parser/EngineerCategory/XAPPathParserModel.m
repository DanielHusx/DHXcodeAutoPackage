//
//  XAPPathParserModel.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPPathParser.h"

@implementation XAPPathParser

- (XAPEngineerModel *)handlePath:(NSString *)path {
    if (![XAPTools isPathExist:path]) {
        return nil;
    }
    
    return [self.nextHandler handlePath:path];
}


@end
