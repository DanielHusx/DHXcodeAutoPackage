//
//  AppConfig.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

#import <Foundation/Foundation.h>

/*
 2020/7/22 01:00:00
 TODO: 接下来要做的事情
 √1. 跑通全流程
 √2. 完善日志打印系统/错误系统（采用通知的方式打印，简直是智障）
 √3. 筛选task显示
 √4. 证书筛选问题——archive，其实是暂时没有设置channel的，那么应该可以筛选出多个，视图需要combo
 √5. 结构图画一画，思路清晰点
 √6. 输出到顶部的信息，需要特别筛选出来
 */
/*
 2020/7/23 10:10:10
 已解决技术问题：
 问题描述：
    Cocoapod无法执行
    该问题理论上属于环境问题，但在终端执行which pod时打印类似/Users/daniel/.rvm/rubies/ruby-2.6.0/bin/pod，
    那么在这里执行pod相关指令基本就是失败。目前测得当输出/usr/local/bin/pod时，就没问题。
    另该问题同样影响ruby的使用，理论上用ruby的xcodeproj指令会省很多事~ 无奈环境
 解决方案：
    rvm use system
    sudo gem pristine executable-hooks --version 1.6.0 # 根据执行 pod --version提示更改
    sudo gem uninstall cocoapods
    sudo gem install -n /usr/local/bin cocoapods
 
 问题描述：
    archive的包无法在其他电脑上运行
 解决方案：
    导出dmg包
    1. 设置scheme为release
    2. compile
    3. 将.app放置一个文件夹
    4. 中断切到该文件夹下执行程序安装路径关联
        ln -s /Applications/   Applications
    5. 磁盘工具(Disk Utility.app)=>文件(File)=>新建映像(New Image)=>来自文件夹的映像(Image From Folder)
        或快捷键 Command+Shift+N
    6. 生成.dmg文件即可
 
 问题描述：
    脚本的执行控制与中断
    NSTask: 可控制可中断。但同时只能执行一个脚本，组合指令|无法执行。另无法使用管理员身份执行（无关紧要）
    NSAppleScript: 可执行组合脚本，可管理员执行。但无法中断，一旦跑起来关闭程序都收不住。参考：https://developer.apple.com/library/archive/technotes/tn2065
 解决方案：
    组合使用
    NSAppleScript：
        优点：可组合命令，可直接调用内建命令(echo, which,...)，可使用管理员身份执行
        缺点：
            只能一次性输出所有结果。以下中断命令的方式因为一次性输出也变得很蛋疼
            中断命令可采用以下方式打印进程id。但是我认为没必要，不用apple script执行延迟操作(xcodebuild）即可
            do shell script "my_command &> /dev/null & echo $!"
            -- result: 621
            set pid to the result
            do shell script "renice +20 -p " & pid
            -- change my_command's scheduling priority.
            do shell script "kill " & pid
            -- my_command is terminated.
    NSTask:
        优点：可管理脚本执行进程，进行中断，可持续输出
        缺点：
            无法使用管理员身份执行——可加sudo，但是没地儿给你输密码
            无法组合命令——可能有方案，目前没找到
            基本脚本都必须提供路径。比如echo=>/bin/echo, which=>usr/bin/which
            另外会出现神奇的事情，执行/usr/bin/which pod（已解决cocoapod环境情况下），会反馈执行失败：Error Domain=com.daniel.applescript Code=-8960 "" UserInfo={NSLocalizedFailureReason=}]。而apple script正确输出
    总结：主要用apple script执行非延迟指令，task执行延迟指令，进行持续输出（xcodebuild)
 
 */


typedef NS_ENUM(NSInteger, DHFilterCondition) {
    /// 无条件
    DHFilterConditionAll,
    /// 只展示项目
    DHFilterConditionProjectOnly,
    /// 只展示打包任务
    DHFilterConditionArchiveOnly,
    /// 只展示IPA任务
    DHFilterConditionIPAOnly
};

/// 定义打开调试模拟运行状态
//#define DH_DEBUG_EXECUTE_ON

#endif /* AppConfig_h */
