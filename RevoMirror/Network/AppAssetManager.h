//
//  AppManager.h
//  Revo Mirror
//
//  Created by Diego Waxemberg on 10/25/14.
//  Copyright (c) 2014 RevoMirror. All rights reserved.
//

#import "RMI_TemporaryApp.h"
#import "HttpManager.h"
#import "RMI_TemporaryHost.h"

@protocol AppAssetCallback <NSObject>

- (void) receivedAssetForApp:(RMI_TemporaryApp*)app;

@end

@interface AppAssetManager : NSObject

- (id) initWithCallback:(id<AppAssetCallback>)callback;
- (void) retrieveAssetsFromHost:(RMI_TemporaryHost*)host;
- (void) stopRetrieving;
+ (NSString*) boxArtPathForApp:(RMI_TemporaryApp*)app;

@end
