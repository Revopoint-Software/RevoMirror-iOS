//
//  RMI_StreamManager.h
//  Revo Mirror
//
//  Created by Diego Waxemberg on 10/20/14.
//  Copyright (c) 2014 RevoMirror. All rights reserved.
//

#import "RMI_StreamConfiguration.h"
#import "Connection.h"

@interface RMI_StreamManager : NSOperation

- (id) initWithConfig:(RMI_StreamConfiguration*)config renderView:(UIView*)view connectionCallbacks:(id<ConnectionCallbacks>)callback;

- (void) stopStream;

- (NSString*) getStatsOverlayText;

@end
