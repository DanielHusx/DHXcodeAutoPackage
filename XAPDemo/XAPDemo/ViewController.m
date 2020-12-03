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


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
