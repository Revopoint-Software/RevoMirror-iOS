//
//  WakeOnLanManager.h
//  Revo Mirror
//
//  Created by Diego Waxemberg on 1/2/15.
//  Copyright (c) 2015 RevoMirror. All rights reserved.
//

#import "RMI_TemporaryHost.h"

@interface WakeOnLanManager : NSObject

+ (void) wakeHost:(RMI_TemporaryHost*)host;

@end
