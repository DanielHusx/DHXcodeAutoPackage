//
//  DHXMLTools.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHXMLTools.h"
#import "WHC_XMLParser.h"

@implementation DHXMLTools

#pragma mark - 解析
+ (NSDictionary *)dictionaryForXMLString:(NSString *)xmlString {
    return [WHC_XMLParser dictionaryForXMLString:xmlString];
}


#pragma mark - 创建NSXMLDocument
+ (NSXMLDocument *)createPlistWithNode:(NSXMLNode *)node {
    return [self createXMLWithRootName:@"plist" node:node];
}

+ (NSXMLDocument *)createXMLWithRootName:(NSString *)rootName node:(NSXMLNode *)node {
    NSXMLElement *root = [NSXMLElement elementWithName:rootName];
    [root addAttribute:[NSXMLNode attributeWithName:@"version" stringValue:@"1.0"]];
    [root addChild:node];
    
    return [self createXMLWithRoot:root];
}

+ (NSXMLDocument *)createXMLWithRoot:(NSXMLElement *)root {
    NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithRootElement:root];
    [xmlDoc setVersion:@"1.0"];
    [xmlDoc setCharacterEncoding:@"UTF-8"];
    [xmlDoc setRootElement:root];
    
    return xmlDoc;
}

#pragma mark - 保存
+ (DHERROR_CODE)writeXMLDocument:(NSXMLDocument *)docment toFile:(NSString *)file {
    NSData *data = [docment XMLDataWithOptions:NSXMLNodePrettyPrint];
    BOOL ret = [data writeToFile:file atomically:YES];
    
    return ret?DHERROR_NO_ERROR:DHERROR_XML_FILE_WRITE_FAILED;
}

@end
