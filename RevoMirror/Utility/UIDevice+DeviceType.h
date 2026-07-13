//
//  UIDevice+DeviceType.h
//  RevoScan_iOS
//
//  Created by 邓亮 on 2022/11/3.
//


#import <UIKit/UIKit.h>
@interface UIDevice (DeviceType)

// 判断语言
+ (NSString *)LanguageInter;
// 默认或者设置语言
+ (NSString *)appDeviceDefaultLanguage;
// 手机系统版本
+ (NSString *)systemVersion;
// 手机型号
+ (NSString *)phoneModel;
// 当前应用软件版本 比如：1.0.1
+ (NSString *)appCurVersion;
//带刘海的手机的刘海高度，默认返回44先
+ (float)statusHeight;
@end
