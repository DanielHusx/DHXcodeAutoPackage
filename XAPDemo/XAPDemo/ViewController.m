//
//  ViewController.m
//  XAPDemo
//
//  Created by Daniel on 2020/12/3.
//

#import "ViewController.h"
#import <XAPSDK/XAPSDK.h>
#define kXAPXMLTextNodeKey @"XAP_TEXT"

#import <objc/runtime.h>

@interface MyTemp : NSObject
@property (nonatomic, assign) NSInteger intergerProperty;
@property (nonatomic, assign) long longProperty;
@property (nonatomic, assign) double doubleProperty;
@property (nonatomic, assign) float floatProperty;
@property (nonatomic, assign) long long longlongProperty;
@property (nonatomic, assign) NSUInteger uintegerProperty;
@property (nonatomic, assign) CGFloat cgfloatProperty;
@property (nonatomic, assign) CGSize cgsizeProperty;
@property (nonatomic, assign) NSRect cgrectProperty;
@property (nonatomic, assign) CGPoint cgpointProperty;
@property (nonatomic, assign) NSEdgeInsets edgeInsetsProperty;

@property (nonatomic, strong) NSArray *arrayProperty;
@property (nonatomic, strong) id idProperty;
@property (nonatomic, strong) NSObject *objectProperty;
@property (nonatomic, strong) MyTemp *myTempProperty;


@end
@implementation MyTemp

@end

@interface ViewController () <NSXMLParserDelegate>

/// 解析的数组
@property (nonatomic, strong) NSMutableArray *parsedArray;
/// 解析内容
@property (nonatomic, strong) NSMutableString *parsedText;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self configProfiles];
    // Do any additional setup after loading the view.
}

- (void)configProfiles {
    [[XAPProvisioningProfileManager manager] prepareConfig];
}

- (void)mouseDown:(NSEvent *)event {
//    [self teamName];
//    [self createOption];
//    [self parsePlist];
//    [self parseXML];
//    [self testP];
    [self testType];
}

- (void)testType {
    MyTemp *obj = [[MyTemp alloc] init];
    [self encodeObject:obj];
}
// 加密对象
- (void)encodeObject:(NSObject *)obj {
    unsigned int pCount;
    
    objc_property_t *properties = class_copyPropertyList([(NSObject *)obj class], &pCount);
    if (properties) {
        for (int i = 0; i < pCount; i++) {
            NSString *pName = @(property_getName(properties[i]));
            NSString *pType = @(property_getAttributes(properties[i]));
            NSArray *pTypes = [pType componentsSeparatedByString:@","];
            NSLog(@"%@ [type: %@]", pName, pType);
            // 过滤只读属性
//            if ([pTypes containsObject:@"R"]) { continue; }
//
//            if ([pType containsString:@"T@"]) {
//                // id
//                [aCoder encodeObject:[obj valueForKey:pName] forKey:pName];
//            } else if ([pTypes containsObject:@"Tc"]) {
//                // BOOL
//                [aCoder encodeBool:[(NSNumber *)[obj valueForKey:pName] boolValue] forKey:pName];
//            } else if ([pTypes containsObject:@"Tl"]) {
//                // long NSInteger
//                [aCoder encodeInteger:[(NSNumber *)[obj valueForKey:pName] integerValue] forKey:pName];
//            }
        }
        free(properties);
    }

}

- (void)testP {
    NSMutableArray *temp = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [temp addObject:dict];
    
    NSMutableDictionary *copy = [temp lastObject];
    [copy addEntriesFromDictionary:@{@"1":@"2"}];
    
    NSLog(@"%@", temp);
}

- (void)parseXML {
    NSString *path = @"/Users/daniel/Desktop/contents.xcworkspacedata";
    NSDictionary *result = [self startParseXMLWithData:[NSData dataWithContentsOfFile:path]];
    NSLog(@"结果 %@", result);
}


- (NSDictionary *)startParseXMLWithData:(NSData *)data {
    [self.parsedArray addObject:[NSMutableDictionary dictionary]];
    // 解析
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    xmlParser.delegate = self;
    if (![xmlParser parse]) { return nil; }
    
    [self xmlDataHandleEngine:self.parsedArray.firstObject];
    return self.parsedArray.firstObject;
}

- (void)xmlDataHandleEngine:(id)object {
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *result = object;
        NSInteger count = result.count;
        NSArray *keys = [result allKeys];
        
        for (NSInteger i = 0; i < count; i++) {
            NSString *key = keys[i];
            id value = result[key];
            if ([value isKindOfClass:[NSDictionary class]]) {
                [self handleTopData:result forKey:key subDict:value];
                [self xmlDataHandleEngine:value];
                
            } else if ([value isKindOfClass:[NSArray class]]) {
                [self xmlDataHandleEngine:value];
            }
        }
    } else if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *result = object;
        for (NSInteger i = 0; i < result.count; i++) {
            id value = result[i];
            [self xmlDataHandleEngine:value];
        }
    }
}

- (void)handleTopData:(NSMutableDictionary *)dict
               forKey:(NSString *)key
              subDict:(NSDictionary*)subDict  {
    NSArray *subKeyArr = [subDict allKeys];
    
    if (subKeyArr.count == 1
        && [subKeyArr.firstObject isEqualToString:kXAPXMLTextNodeKey]) {
        [dict setObject:subDict[kXAPXMLTextNodeKey] forKey:key];
        
    } else if(subKeyArr.count == 0) {
        [dict setObject:@"" forKey:key];
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
    NSLog(@"start: %@", self.parsedArray);
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
    NSLog(@"移除前 %@", self.parsedArray);
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

//- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
//    NSLog(@"%s [elementName: %@] [namespaceURI: %@] [qName: %@] [attributeDict: %@]", __PRETTY_FUNCTION__, elementName, namespaceURI, qName, attributeDict);
//}
//
//- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
//    NSLog(@"%s [elementName: %@] [namespaceURI: %@] [qName: %@]", __PRETTY_FUNCTION__, elementName, namespaceURI, qName);
//}
//
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    NSLog(@"%s [string: %@]", __PRETTY_FUNCTION__, string);
//}
//
//- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}

- (void)teamName {
    NSArray *result = [[XAPProvisioningProfileManager manager] fetchSystemConfiguratedCertificatesInfo];
    
    NSLog(@"---------------证书信息-----------------------");
    NSLog(@"%@", result);
}

- (void)filter {
    XAPProvisioningProfileModel *filter = [[XAPProvisioningProfileModel alloc] init];
    filter.bundleIdentifier = @"com.cloudy.jun";
//    filter.channel = kXAPChannelDevelopment;
    NSLog(@"---------------筛选-----------------------");
    NSArray *result = [[XAPProvisioningProfileManager manager] filterProvisioningProfileByFilterModel:filter];
    NSLog(@"%@", result);
    
}

- (void)parsePlist {
    NSString *name;
//    NSDictionary *ret = [XAPInfoPlistManager parseInfoPlistFileForProjectOrApp:@"/Users/feifan_ios/Desktop/App.plist" displayName:&name productName:&name bundleIdentifier:&name shortVersion:&name version:&name executableFile:&name];
//    NSLog(@"ret : %@", ret);
}

- (void)createOption {
    NSDictionary *dict = [self exportOptionsDictionaryWithBundleIdentifier:@"com.daniel.douniwan" teamIdentifier:@"ABCDE" channel:@"daniel_ad-hoc" profileName:@"猜猜看" enableBitcodeBool:NO];
    [dict writeToFile:@"/Users/feifan_ios/Desktop/my.plist" atomically:YES];
}
- (NSDictionary *)exportOptionsDictionaryWithBundleIdentifier:(NSString *)bundleIdentifier
                                               teamIdentifier:(NSString *)teamIdentifier
                                                      channel:(NSString *)channel
                                                  profileName:(NSString *)profileName
                                            enableBitcodeBool:(BOOL)enableBitcodeBool {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    [result setValue:teamIdentifier forKey:@"teamID"];
    [result setValue:channel forKey:@"method"];
    [result setValue:@(true) forKey:@"stripSwiftSymbols"];
    NSMutableDictionary *provisioningProfilesDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [provisioningProfilesDict setValue:profileName forKey:bundleIdentifier];
    
    [result setValue:provisioningProfilesDict forKey:@"provisioningProfiles"];
    [result setValue:@(enableBitcodeBool) forKey:@"compileBitcode"];
    
    return [result copy];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
