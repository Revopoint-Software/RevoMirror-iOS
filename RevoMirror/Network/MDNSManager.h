//
//  MDNSManager.h
//  Revo Mirror
//
//  Created by Diego Waxemberg on 10/14/14.
//  Copyright (c) 2014 RevoMirror. All rights reserved.
//

#import "RMI_TemporaryHost.h"

@protocol MDNSCallback <NSObject>

- (void) updateHost:(RMI_TemporaryHost*)host;

@end

@interface MDNSManager : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate>

@property id<MDNSCallback> callback;

- (id) initWithCallback:(id<MDNSCallback>) callback;
- (void) searchForHosts;
- (void) stopSearching;
- (void) forgetHosts;

@end



