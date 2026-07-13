//
//  DiscoveryManager.h
//  Revo Mirror
//
//  Created by Diego Waxemberg on 1/1/15.
//  Copyright (c) 2015 RevoMirror. All rights reserved.
//

#import "MDNSManager.h"
#import "RMI_TemporaryHost.h"

@protocol DiscoveryCallback <NSObject>

- (void) updateAllHosts:(NSArray*)hosts;

@end

@interface DiscoveryManager : NSObject <MDNSCallback>

- (id) initWithHosts:(NSArray*)hosts andCallback:(id<DiscoveryCallback>) callback;
- (void) startDiscovery;
- (void) stopDiscovery;
- (void) stopDiscoveryBlocking;
- (void) resetDiscoveryState;
- (BOOL) addHostToDiscovery:(RMI_TemporaryHost*)host;
- (void) removeHostFromDiscovery:(RMI_TemporaryHost*)host;
- (void) pauseDiscoveryForHost:(RMI_TemporaryHost *)host;
- (void) resumeDiscoveryForHost:(RMI_TemporaryHost *)host;
- (void) discoverHost:(NSString*)hostAddress withCallback:(void (^)(RMI_TemporaryHost*, NSString*))callback;

@end
