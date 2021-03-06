//
//  DHXcodeSDKError.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/7/30.
//  Copyright © 2020 Daniel. All rights reserved.
//

#ifndef DHXcodeSDKError_h
#define DHXcodeSDKError_h
#import <Foundation/Foundation.h>
/**
 这里定义DataBase的错误规则
 SOURCE  FUNCTION      TYPE    CODE
    1                01             01           001
 souce:
 -- 1 db
 2 bussniess
 3 view
 
 function:
 0 script
 1 Archive
 2 zip
 3 xml
 4 setter
 5 distribute
 6 parse
 10 common
 
 type:
 01 参数错误
 02 函数错误
 03 系统函数错误
 04 文件错误
 05 缓存错误
 52 其他错误
 
 code: 具体错误
 */

typedef NSInteger DHERROR_CODE;
#define DHERROR_NO_ERROR                    0
/// 存在脚本执行
/// 执行苹果脚本参数异常
#define DHERROR_SCRIPT_NSAPPLESCRIPT_PARAMS_INVALID 10001001
/// 执行苹果脚本结果出错
#define DHERROR_SCRIPT_NSAPPLESCRIPT_EXECUTE_ERROR  10002001
/// 执行NSTask参数异常
#define DHERROR_SCRIPT_NSTASK_PARAMS_INVALID 10001002
#define DHERROR_SCRIPT_PROCESSING_WARNNING  10052001


#define DHERROR_ARCHIVE_PARAMETER_INVALID     10101001
#define DHERROR_UNARCHIVE_PARAMETER_INVALID   10101002
 
#define DHERROR_ARCHIVE_FAILED              10103001
#define DHERROR_UNARCHIVE_FAILED            10103002

#define DHERROR_ARCHIVE_FILE_WRITE_FAILED   10104001
#define DHERROR_UNARCHIVE_FILE_NOT_EXIST    10104002

#define DHERROR_UNZIP_FAILED                10203001
#define DHERROR_ZIP_FAILED                  10203002

#define DHERROR_XML_FILE_WRITE_FAILED       10304001

#define DHERROR_SETTER_XCODEPROJ_INVALID                10401001
#define DHERROR_SETTER_TARGET_INVALID                   10401002
#define DHERROR_SETTER_CONFIGURATION_INVALID            10401003
#define DHERROR_SETTER_SETTINGS_INVALID                 10401004
#define DHERROR_SETTER_SETTINGS_INFO_PARSE_FAILED       10401005
#define DHERROR_SETTER_INFO_PLIST_INVALID               10401006
#define DHERROR_SETTER_BUILD_CONFIGURATION_NOT_FOUND    10401007
#define DHERROR_SETTER_RESET_XCODEPROJ_INVALID          10401008

#define DHERROR_SETTER_PBXPROJ_READ_FAILED      10404001
#define DHERROR_SETTER_RESET_CACHE_READ_EMPTY   10405001

#define DHERROR_SETTER_SETUP_FAILED             10402001
#define DHERROR_SETTER_SETUP_FILE_WRITE_FAILED  10404002
#define DHERROR_SETTER_PBXPROJ_PARSE_FAILED     10402002

#define DHERROR_DISTRIBUTE_UNSUPPORT_PLATFORM           10552001
#define DHERROR_DISTRIBUTE_IPA_FILE_INVALID             10501001
#define DHERROR_DISTRIBUTE_MISSING_REQUIRED_PARAMETERS  10501002

#define DHERROR_PARSER_XCWORKSPACE_INVALID      10601001
#define DHERROR_PARSER_XCODEPROJ_INVALID        10601002
#define DHERROR_PARSER_MOBILEPROVISION_INVALID  10601003
#define DHERROR_PARSER_GIT_INVALID              10601004
#define DHERROR_PARSER_PODFILE_INVALID          10601005
#define DHERROR_PARSER_XCARCHIVE_INVALID        10601006
#define DHERROR_PARSER_IPA_INVALID              10601007
#define DHERROR_PARSER_APP_INVALID              10601008
#define DHERROR_PARSER_INFOPLIST_INVALID        10601009

#define DHERROR_PARSER_XCWORKSPACE_NO_RELATE_PROJECT    10604001
#define DHERROR_PARSER_XCODEPROJ_NO_RELATE_TARGET       10604002
#define DHERROR_PARSER_IPA_NOT_FOUND_APP                10604003

#define DHERROR_PARSER_XCWORKSPACE_PARSE_PROJECT_FAILED 10602000
#define DHERROR_PARSER_XCODEPROJ_PARSE_FAILED           10602001
#define DHERROR_PARSER_XCODEPROJ_PARSE_TARGET_FAILED    10602002
#define DHERROR_PARSER_XCODEPROJ_PARSE_TARGETIDS_FAILED 10602003
#define DHERROR_PARSER_TARGET_PARSE_NAME_FAILED                         10602011
#define DHERROR_PARSER_TARGET_PARSE_BUILDCONFIGURATIONIDS_FAILED        10602012
#define DHERROR_PARSER_TARGET_PARSE_BUILDCONFIGURATIONS_FAILED          10602013
#define DHERROR_PARSER_BUILDCONFIGURATION_PARSE_NAME_FAILED             10602021
#define DHERROR_PARSER_BUILDCONFIGURATION_PARSE_PRODUCT_NAME_FAILED     10602022
#define DHERROR_PARSER_BUILDCONFIGURATION_PARSE_DISPLAY_NAME_FAILED     10602023
#define DHERROR_PARSER_BUILDCONFIGURATION_PARSE_BUNDLEID_FAILED         10602024
#define DHERROR_PARSER_BUILDCONFIGURATION_PARSE_TEAMID_FAILED           10602025
#define DHERROR_PARSER_BUILDCONFIGURATION_PARSE_VERSION_FAILED          10602026
#define DHERROR_PARSER_BUILDCONFIGURATION_PARSE_BUILDVERSION_FAILED     10602027
#define DHERROR_PARSER_BUILDCONFIGURATION_PARSE_ENABLEBITCODE_FAILED    10602028

#define DHERROR_PARSER_PROFILE_PARSE_NAME_FAILED        10602015
#define DHERROR_PARSER_PROFILE_PARSE_BUNDLEID_FAILED    10602016
#define DHERROR_PARSER_PROFILE_PARSE_APPID_FAILED       10602017
#define DHERROR_PARSER_PROFILE_PARSE_TEAMID_FAILED      10602018
#define DHERROR_PARSER_PROFILE_PARSE_TEAMNAME_FAILED    10602019
#define DHERROR_PARSER_PROFILE_PARSE_UUID_FAILED        10602020
#define DHERROR_PARSER_PROFILE_PARSE_CHANNEL_FAILED     10602021
#define DHERROR_PARSER_PROFILE_PARSE_CREATED_TIMESTAMP_FAILED   10602022
#define DHERROR_PARSER_PROFILE_PARSE_EXPIRE_TIMESTAMP_FAILED    10602023

#define DHERROR_PARSER_GIT_PARSE_CURRENT_BRANCH_FAILD   10602024
#define DHERROR_PARSER_GIT_PARSE_BRANCHS_FAILD          10602025
#define DHERROR_PARSER_GIT_PARSE_TAGS_FAILD             10602026

#define DHERROR_PARSER_ARCHIVE_PARSE_APP_FAILED         10602027

#define DHERROR_PARSER_IPA_PARSE_APP_FAILED             10602028

#define DHERROR_PARSER_APP_PARSE_DISPLAY_NAME_FAILED        10602029
#define DHERROR_PARSER_APP_PARSE_PRODUCT_NAME_FAILED        10602030
#define DHERROR_PARSER_APP_PARSE_BUNDLEID_FAILED            10602031
#define DHERROR_PARSER_APP_PARSE_VERSION_FAILED             10602032
#define DHERROR_PARSER_APP_PARSE_BUILDVERSION_FAILED        10602033
#define DHERROR_PARSER_APP_PARSE_ENABLEBITCODE_FAILED       10602034
#define DHERROR_PARSER_APP_PARSE_EMBEDDED_PROFILE_FAILED    10602035
#define DHERROR_PARSER_APP_PARSE_EXECUTABLE_FILE_FAILED     10602036



#endif /* DHXcodeSDKError_h */
