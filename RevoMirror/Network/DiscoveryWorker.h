//
//  DiscoveryWorker.h
//  Revo Mirror
//
//  Created by Diego Waxemberg on 1/2/15.
//  Copyright (c) 2015 RevoMirror. All rights reserved.
//

#import "RMI_TemporaryHost.h"

@interface DiscoveryWorker : NSOperation

- (id) initWithHost:(RMI_TemporaryHost*)host uniqueId:(NSString*)uniqueId;
- (void) discoverHost;
- (RMI_TemporaryHost*) getHost;

@end
