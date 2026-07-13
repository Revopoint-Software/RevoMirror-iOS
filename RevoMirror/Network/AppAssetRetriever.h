//
//  AppAssetRetriever.h
//  Revo Mirror
//
//  Created by Diego Waxemberg on 1/31/15.
//  Copyright (c) 2015 RevoMirror. All rights reserved.
//

#import "RMI_TemporaryHost.h"
#import "RMI_TemporaryApp.h"
#import "AppAssetManager.h"

@interface AppAssetRetriever : NSOperation

@property (nonatomic) RMI_TemporaryHost* host;
@property (nonatomic) RMI_TemporaryApp* app;
@property (nonatomic) id<AppAssetCallback> callback;

@end
