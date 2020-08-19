//
//  DHCertificateModel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/27.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHCertificateModel.h"
#import <Security/Security.h>

@implementation DHCertificateModel
//- (void)ab {
//    SecKeychainRef keychain = ...
//    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
//                           kSecClassCertificate, kSecClass,
//                           [NSArray arrayWithObject:(id)keychain], kSecMatchSearchList,
//                           kCFBooleanTrue, kSecReturnRef,
//                           kSecMatchLimitAll, kSecMatchLimit,
//                           nil];
//    NSArray *items = nil;
//    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&items);
//    if (status) {
//        if (status != errSecItemNotFound)
//            LKKCReportError(status, @"Can't search keychain");
//        return nil;
//    }
//    return [items autorelease]; // items contains all SecCertificateRefs in keychain
//}


+ (void)logMessageForStatus:(OSStatus)status
               functionName:(NSString *)functionName
{
    CFStringRef errorMessage;
    errorMessage = SecCopyErrorMessageString(status, NULL);
    NSLog(@"error after %@: %@", functionName, (__bridge NSString *)errorMessage);
    CFRelease(errorMessage);
}

+ (void)listCertificates
{
    OSStatus status;
    SecKeychainSearchRef search = NULL;

    // The first argument being NULL indicates the user's current keychain list
    status = SecKeychainSearchCreateFromAttributes(NULL,
        kSecCertificateItemClass, NULL, &search);

    if (status != errSecSuccess) {
        [self logMessageForStatus:status
                     functionName:@"SecKeychainSearchCreateFromAttributes()"];
        return;
    }

    SecKeychainItemRef searchItem = NULL;

    while (SecKeychainSearchCopyNext(search, &searchItem) != errSecItemNotFound) {
        SecKeychainAttributeList attrList;
        CSSM_DATA certData;

        attrList.count = 0;
        attrList.attr = NULL;

        status = SecKeychainItemCopyContent(searchItem, NULL, &attrList,
            (UInt32 *)(&certData.Length),
            (void **)(&certData.Data));

        if (status != errSecSuccess) {
            [self logMessageForStatus:status
                         functionName:@"SecKeychainItemCopyContent()"];
            CFRelease(searchItem);
            continue;
        }

        // At this point you should have a valid CSSM_DATA structure
        // representing the certificate

        SecCertificateRef certificate;
        status = SecCertificateCreateFromData(&certData, CSSM_CERT_X_509v3,
            CSSM_CERT_ENCODING_BER, &certificate);

        if (status != errSecSuccess) {
            [self logMessageForStatus:status
                         functionName:@"SecCertificateCreateFromData()"];
            SecKeychainItemFreeContent(&attrList, certData.Data);
            CFRelease(searchItem);
            continue;
        }

        // Do whatever you want to do with the certificate
        // For instance, print its common name (if there's one)

        CFStringRef commonName = NULL;
        SecCertificateCopyCommonName(certificate, &commonName);
        NSLog(@"common name = %@", (__bridge NSString *)commonName);
        if (commonName) CFRelease(commonName);

        SecKeychainItemFreeContent(&attrList, certData.Data);
        CFRelease(searchItem);
    }

    CFRelease(search);
}
@end
