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
    [self teamName];
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

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
