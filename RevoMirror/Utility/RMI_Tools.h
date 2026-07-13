//
//  RMI_Tools.h
//  Revo Mirror
//
//  Created by Diego Waxemberg on 10/20/14.
//  Copyright (c) 2014 RevoMirror. All rights reserved.
//

extern NSString *__currentLanguageStringValue;
extern NSString *__renameString;
extern NSString *__lastHost;

@interface RMI_Tools : NSObject

typedef NS_ENUM(int, PairState) {
    PairStateUnknown,
    PairStateUnpaired,
    PairStatePaired
};

typedef NS_ENUM(int, State) {
    StateUnknown,
    StateOffline,
    StateOnline
};

FOUNDATION_EXPORT NSString *const deviceName;

+ (NSData*) randomBytes:(NSInteger)length;
+ (NSString*) bytesToHex:(NSData*)data;
+ (NSData*) hexToBytes:(NSString*) hex;
+ (BOOL) isActiveNetworkVPN;
+ (BOOL) parseAddressPortString:(NSString*)addressPort address:(NSRange*)address port:(NSRange*)port;
+ (NSString*) addressPortStringToAddress:(NSString*)addressPort;
+ (unsigned short) addressPortStringToPort:(NSString*)addressPort;
+ (NSString*) addressAndPortToAddressPortString:(NSString*)address port:(unsigned short)port;

+(UIWindow *)keyWindow;
+ (UINavigationController *)currentNavigation;
//获取当前屏幕方向
+(UIInterfaceOrientation)getWindowInterfaceOrientation;

+ (void) launchUrl:(NSString*)urlString;

@end

@interface NSString (NSStringWithTrim)

- (NSString*) trim;

@end
