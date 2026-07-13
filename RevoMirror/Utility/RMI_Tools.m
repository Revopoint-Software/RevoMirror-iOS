//
//  RMI_Tools.m
//  Revo Mirror
//
//  Created by Diego Waxemberg on 10/20/14.
//  Copyright (c) 2014 RevoMirror. All rights reserved.
//

NSString *__currentLanguageStringValue = @"en_US";
NSString *__renameString = @"";
NSString *__lastHost = @"";

#import "RMI_Tools.h"
#import "AppDelegate.h"
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netdb.h>

@implementation RMI_Tools
NSString *const deviceName = @"roth";

+ (NSData*) randomBytes:(NSInteger)length {
    char* bytes = malloc(length);
    arc4random_buf(bytes, length);
    NSData* randomData = [NSData dataWithBytes:bytes length:length];
    free(bytes);
    return randomData;
}

+ (NSData*) hexToBytes:(NSString*) hex {
    unsigned long len = [hex length];
    NSMutableData* data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    const char *chars = [hex UTF8String];
    int i = 0;
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}

+ (NSString*) bytesToHex:(NSData*)data {
    const unsigned char* bytes = [data bytes];
    NSMutableString *hex = [[NSMutableString alloc] init];
    for (int i = 0; i < [data length]; i++) {
        [hex appendFormat:@"%02X" , bytes[i]];
    }
    return hex;
}

+ (BOOL)isActiveNetworkVPN {
    NSDictionary *dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
    NSArray *keys = [dict[@"__SCOPED__"] allKeys];
    for (NSString *key in keys) {
        if ([key containsString:@"tap"] ||
            [key containsString:@"tun"] ||
            [key containsString:@"ppp"] ||
            [key containsString:@"ipsec"]) {
            return YES;
        }
    }
    return NO;
}

+ (void) launchUrl:(NSString*)urlString {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
}

+ (BOOL) parseAddressPortString:(NSString*)addressPort address:(NSRange*)address port:(NSRange*)port {
    if (![addressPort containsString:@":"]) {
        // If there's no port or IPv6 separator, the whole thing is an address
        *address = NSMakeRange(0, [addressPort length]);
        *port = NSMakeRange(NSNotFound, 0);
        return TRUE;
    }
    
    NSInteger locationOfOpeningBracket = [addressPort rangeOfString:@"["].location;
    NSInteger locationOfClosingBracket = [addressPort rangeOfString:@"]"].location;
    if (locationOfOpeningBracket != NSNotFound || locationOfClosingBracket != NSNotFound) {
        // If we have brackets, it's an IPv6 address
        if (locationOfOpeningBracket == NSNotFound || locationOfClosingBracket == NSNotFound ||
            locationOfClosingBracket < locationOfOpeningBracket) {
            // Invalid address format
            return FALSE;
        }
        
        // Cut at the brackets
        *address = NSMakeRange(locationOfOpeningBracket + 1, locationOfClosingBracket - locationOfOpeningBracket - 1);
    }
    else {
        // It's an IPv4 address, so just cut at the port separator
        *address = NSMakeRange(0, [addressPort rangeOfString:@":"].location);
    }
    
    NSUInteger remainingStringLocation = address->location + address->length;
    NSRange remainingStringRange = NSMakeRange(remainingStringLocation, [addressPort length] - remainingStringLocation);
    NSInteger locationOfPortSeparator = [addressPort rangeOfString:@":" options:0 range:remainingStringRange].location;
    if (locationOfPortSeparator != NSNotFound) {
        *port = NSMakeRange(locationOfPortSeparator + 1, [addressPort length] - locationOfPortSeparator - 1);
    }
    else {
        *port = NSMakeRange(NSNotFound, 0);
    }
    
    return TRUE;
}

+ (NSString*) addressPortStringToAddress:(NSString*)addressPort {
    NSRange addressRange, portRange;
    if (![self parseAddressPortString:addressPort address:&addressRange port:&portRange]) {
        return nil;
    }
    
    return [addressPort substringWithRange:addressRange];
}

+ (unsigned short) addressPortStringToPort:(NSString*)addressPort {
    NSRange addressRange, portRange;
    if (![self parseAddressPortString:addressPort address:&addressRange port:&portRange] || portRange.location == NSNotFound) {
        return 47989;
    }
    
    return [[addressPort substringWithRange:portRange] integerValue];
}

+ (NSString*) addressAndPortToAddressPortString:(NSString*)address port:(unsigned short)port {
    if ([address containsString:@":"]) {
        // IPv6 addresses require escaping
        return [NSString stringWithFormat:@"[%@]:%u", address, port];
    }
    else {
        return [NSString stringWithFormat:@"%@:%u", address, port];
    }
}

+(UIWindow *)keyWindow
{
    static __weak UIWindow *cachedKeyWindow = nil;
    /*  (Bug ID: #23, #25, #73)   */
    UIWindow *originalKeyWindow = nil;

    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        originalKeyWindow = window;
                        break;
                    }
                }
            }
        }
    } else
    #endif
    {
    #if __IPHONE_OS_VERSION_MIN_REQUIRED < 130000
        originalKeyWindow = [UIApplication sharedApplication].keyWindow;
    #endif
    }

    //If original key window is not nil and the cached keywindow is also not original keywindow then changing keywindow.
    if (originalKeyWindow)
    {
        cachedKeyWindow = originalKeyWindow;
    }
    
    return cachedKeyWindow;
}

+ (UINavigationController *)currentNavigation
{
    return [self currentViewController].navigationController;
}

+ (UIViewController*)currentViewController
{
    UIViewController *result = nil;
    UIWindow * window = [RMI_Tools keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到它
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                if (tmpWin.rootViewController != nil || tmpWin.keyWindow == YES || tmpWin.subviews.count > 0) {
                    window = tmpWin;
                    break;
                }
            }
        }
    }
    
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    //1、通过present弹出VC，appRootVC.presentedViewController不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        //2、通过navigationcontroller弹出VC
        if ([window subviews].count>0) {
            UIView *frontView = [[window subviews] firstObject];
            nextResponder = [frontView nextResponder];
        }
    }
    
    if ([nextResponder isKindOfClass:[UIWindow class]]) {
        nextResponder = window.rootViewController;
    }

    result = [self getCurrentVCWithVC:nextResponder];
    return result;
}

+(UIViewController*)getCurrentVCWithVC:(UIViewController*)vc
{
    UIViewController *result = nil;
    //1、tabBarController
    if ([vc isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)vc;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //或者 UINavigationController * nav = tabbar.selectedViewController;
        if ([nav isKindOfClass:[UINavigationController class]]) {
            result = nav.childViewControllers.lastObject;
          }
        else
        {
            result = nav;
        }
    }else if ([vc isKindOfClass:[UINavigationController class]]){
        //2、navigationController
        UIViewController * nav = (UIViewController *)vc;
        result = nav.childViewControllers.lastObject;
    }else{//3、viewControler
        result = vc;
    }
    return result;
}

//获取当前屏幕方向
+(UIInterfaceOrientation)getWindowInterfaceOrientation
{
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return delegate.window.windowScene.interfaceOrientation;
}

@end

@implementation NSString (NSStringWithTrim)

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
