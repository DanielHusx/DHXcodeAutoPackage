//
//  ViewController.m
//  XAPDemo
//
//  Created by Daniel on 2020/12/3.
//

#import "ViewController.h"
#import <XAPSDK/XAPSDK.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configProfiles];
    // Do any additional setup after loading the view.
}

- (void)configProfiles {
    [[XAPProvisioningProfileManager manager] prepareConfig];
}

- (void)mouseDown:(NSEvent *)event {
//    [self teamName];
//    [self createOption];
    [self parsePlist];
}

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
