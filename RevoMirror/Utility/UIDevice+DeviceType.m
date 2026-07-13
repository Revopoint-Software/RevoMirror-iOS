//
//  UIDevice+DeviceType.m
//  RevoScan_iOS
//
//  Created by 邓亮 on 2022/11/3.
//

#import "UIDevice+DeviceType.h"
#import "sys/utsname.h"

@implementation UIDevice (DeviceType)

+ (NSString *)LanguageInter
{
    return __currentLanguageStringValue;
}

+ (NSString *)appDeviceDefaultLanguage
{
    NSString *localAppLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguageStringValue"];
    if(localAppLanguage.length>0){
        return localAppLanguage;
    }
    
    //跟随系统
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];

    NSString *codeStr = @"en_US";
    if ([languageName hasPrefix:@"zh-Hans"])
    {
        //简体中文
        codeStr = @"zh_CN";
    }
    else if ([languageName hasPrefix:@"zh-Hant"])
    {
        //繁体中文
        codeStr = @"zh_HK";
    }
    else if ([languageName hasPrefix:@"fr"])
    {
        //法语
        codeStr = @"fr";
    }
    else if ([languageName hasPrefix:@"de"])
    {
        //德语
        codeStr = @"de";
    }else if ([languageName hasPrefix:@"it"])
    {
        //意大利
        codeStr = @"it";
    } else if ([languageName hasPrefix:@"es"])
    {
        //西班牙语
        codeStr = @"es";
    }
    else if ([languageName hasPrefix:@"pt"])
    {
        //葡萄牙语
        codeStr = @"pt";
    }
    else if ([languageName hasPrefix:@"ja"])
    {
        //日语
        codeStr = @"ja";
    }
    else if ([languageName hasPrefix:@"ko"])
    {
        //韩语
        codeStr = @"ko";
    }
    else if ([languageName hasPrefix:@"ru"])
    {
        //俄语
        codeStr = @"ru";
    }
    else if ([languageName hasPrefix:@"tr"])
    {
        //土耳其语
        codeStr = @"tr";
    }
    
    return codeStr;
    
}

// 手机型号
+ (NSString *)phoneModel {
    NSString * phoneModel =  [self platformString];
    return phoneModel;
}

// 当前应用软件版本 比如：1.0.1
+ (NSString *)appCurVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appCurVersion;
}

// 手机系统版本
+ (NSString *)systemVersion {
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    return phoneVersion?:@"";
}

+ (NSString *)platformString {
    NSString *platform = [self getDeviceVersion];
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    if ([platform isEqualToString:@"iPhone12,8"])   return @"iPhone SE(2nd generation)";
    if ([platform isEqualToString:@"iPhone13,1"])   return @"iPhone 12 mini";
    if ([platform isEqualToString:@"iPhone13,2"])   return @"iPhone 12";
    if ([platform isEqualToString:@"iPhone13,3"])   return @"iPhone 12 Pro";
    if ([platform isEqualToString:@"iPhone13,4"])   return @"iPhone 12 Pro Max";
    if ([platform isEqualToString:@"iPhone14,4"])   return @"iPhone 13 mini";
    if ([platform isEqualToString:@"iPhone14,5"])   return @"iPhone 13";
    if ([platform isEqualToString:@"iPhone14,2"])   return @"iPhone 13 Pro";
    if ([platform isEqualToString:@"iPhone14,3"])   return @"iPhone 13 Pro Max";
    if ([platform isEqualToString:@"iPhone14,6"])   return @"iPhone SE (3rd generation)";
    if ([platform isEqualToString:@"iPhone14,7"])   return @"iPhone 14";
    if ([platform isEqualToString:@"iPhone14,8"])   return @"iPhone 14 Plus";
    if ([platform isEqualToString:@"iPhone15,2"])   return @"iPhone 14 Pro";
    if ([platform isEqualToString:@"iPhone15,3"])   return @"iPhone 14 Pro Max";
    if ([platform isEqualToString:@"iPod1,1"])     return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])     return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])     return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])     return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])     return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])     return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"])     return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])     return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])     return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])     return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])     return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])     return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])     return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad3,1"])     return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])     return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])     return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])     return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])     return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])     return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])     return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])     return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])     return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])     return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])     return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])     return @"iPad Mini 2G";
    if ([platform isEqualToString:@"i386"])     return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])     return @"iPhone Simulator";
    
    return platform;
}

+ (float)statusHeight
{
    NSString *platform = [self getDeviceVersion];
    //iPhone
    
    if ([platform isEqualToString:@"iPhone10,3"])   return 44;
    if ([platform isEqualToString:@"iPhone10,6"])   return 44;
    if ([platform isEqualToString:@"iPhone11,8"])   return 44;
    if ([platform isEqualToString:@"iPhone11,2"])   return 44;
    if ([platform isEqualToString:@"iPhone11,4"])   return 44;
    if ([platform isEqualToString:@"iPhone11,6"])   return 44;
    if ([platform isEqualToString:@"iPhone12,1"])   return 44;
    if ([platform isEqualToString:@"iPhone12,3"])   return 44;
    if ([platform isEqualToString:@"iPhone12,5"])   return 44;
    if ([platform isEqualToString:@"iPhone13,1"])   return 50;
    if ([platform isEqualToString:@"iPhone13,2"])   return 47;
    if ([platform isEqualToString:@"iPhone13,3"])   return 47;
    if ([platform isEqualToString:@"iPhone13,4"])   return 47;
    
    if ([platform isEqualToString:@"iPhone14,2"])   return 47;
    if ([platform isEqualToString:@"iPhone14,3"])   return 47;
    if ([platform isEqualToString:@"iPhone14,4"])   return 50;
    if ([platform isEqualToString:@"iPhone14,5"])   return 47;
    if ([platform isEqualToString:@"iPhone14,7"])   return 47;
    if ([platform isEqualToString:@"iPhone14,8"])   return 47;
    if ([platform isEqualToString:@"iPhone15,2"])   return 59;
    if ([platform isEqualToString:@"iPhone15,3"])   return 59;
    
    return 44;
}

+ (NSString *)getDeviceVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform;
}


@end
