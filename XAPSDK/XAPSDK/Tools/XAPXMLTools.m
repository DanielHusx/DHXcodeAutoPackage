//
//  XAPXMLTools.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/8.
//

#import "XAPXMLTools.h"

#define kXAPXMLTextNodeKey @"XAP_TEXT"

@interface XAPXMLTools () <NSXMLParserDelegate>

/// 解析的数组
@property (nonatomic, strong) NSMutableArray *parsedArray;
/// 解析内容
@property (nonatomic, strong) NSMutableString *parsedText;

@end

@implementation XAPXMLTools

+ (NSDictionary *)dictionaryWithXMLFile:(NSString *)xmlFile {
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlFile];
    
    NSDictionary *result = [self dictionaryWithXMLData:xmlData];
    return result;
}

+ (NSDictionary *)dictionaryWithXMLData:(NSData *)xmlData {
    XAPXMLTools *parser = [[XAPXMLTools alloc] init];
    NSDictionary *result = [parser startParseXMLWithData:xmlData];
    return result;
}

#pragma mark - 解析
- (NSDictionary *)startParseXMLWithData:(NSData *)data {
    [self.parsedArray addObject:[NSMutableDictionary dictionary]];
    // 解析
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    xmlParser.delegate = self;
    if (![xmlParser parse]) { return nil; }
    
    [self handleXMLParsedData:self.parsedArray.firstObject];
    return self.parsedArray.firstObject;
}

- (void)handleXMLParsedData:(id)object {
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *result = object;
        NSInteger count = result.count;
        NSArray *keys = [result allKeys];
        
        for (NSInteger i = 0; i < count; i++) {
            NSString *key = keys[i];
            id value = result[key];
            if ([value isKindOfClass:[NSDictionary class]]) {
                [self handleXMLParsedDictionary:result forKey:key subDictionary:value];
                [self handleXMLParsedData:value];
                
            } else if ([value isKindOfClass:[NSArray class]]) {
                [self handleXMLParsedData:value];
            }
        }
    } else if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *result = object;
        for (NSInteger i = 0; i < result.count; i++) {
            id value = result[i];
            [self handleXMLParsedData:value];
        }
    }
}

- (void)handleXMLParsedDictionary:(NSMutableDictionary *)parsedDictionary
                           forKey:(NSString *)key
                    subDictionary:(NSDictionary*)subDictionary  {
    NSArray *subKeyArr = [subDictionary allKeys];
    
    if (subKeyArr.count == 1
        && [subKeyArr.firstObject isEqualToString:kXAPXMLTextNodeKey]) {
        [parsedDictionary setObject:subDictionary[kXAPXMLTextNodeKey] forKey:key];
        
    } else if(subKeyArr.count == 0) {
        [parsedDictionary setObject:@"" forKey:key];
    }
}


#pragma mark - NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    // <Node attributeName = value>
    NSMutableDictionary *parent = [self.parsedArray lastObject];
    NSMutableDictionary *child = [NSMutableDictionary dictionary];
    [child addEntriesFromDictionary:attributeDict];
    
    id elementValue = [parent objectForKey:elementName];
    if (elementValue) {
        // 属性值存在时，插入子节点
        NSMutableArray *value = nil;
        if ([elementValue isKindOfClass:[NSMutableArray class]]) {
            // 使用存在的数组
            value = elementValue;
        } else {
            // 不存在则创建数组，将属性值替换为可变数组重新插入
            value = [NSMutableArray array];
            [value addObject:elementValue];
            [parent setObject:value forKey:elementName];
        }
        // 添加一个新的子字典
        [value addObject:child];
    } else {
        // 不曾插入改节点，则直接插入
        [parent setObject:child forKey:elementName];
    }

    // 添加子节点属性
    [self.parsedArray addObject:child];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    // </Node>
    NSMutableDictionary *result = [self.parsedArray lastObject];
    
    if (_parsedText.length > 0) {
        // 存储值
        NSString *text = [self.parsedText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (text.length > 0) {
            [result setObject:[text mutableCopy] forKey:kXAPXMLTextNodeKey];
            _parsedText = nil;
        }
    }
    // 移除当前
    [self.parsedArray removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(nonnull NSString *)string {
    // <Node>string</Node>
    [self.parsedText appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(nonnull NSError *)parseError {
    NSLog(@"%s [parseError: %@]", __PRETTY_FUNCTION__, parseError);
}


#pragma mark - getters
- (NSMutableString *)parsedText {
    if (!_parsedText) {
        _parsedText = [NSMutableString string];
    }
    return _parsedText;
}

- (NSMutableArray *)parsedArray {
    if (!_parsedArray) {
        _parsedArray = [NSMutableArray array];
    }
    return _parsedArray;
}

@end
