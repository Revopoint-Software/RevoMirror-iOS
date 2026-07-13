//
//  AppManager.m
//  Revo Mirror
//
//  Created by Diego Waxemberg on 10/25/14.
//  Copyright (c) 2014 RevoMirror. All rights reserved.
//

#import "AppAssetManager.h"
#import "RMI_CryptoManager.h"
#import "RMI_Tools.h"
#import "HttpResponse.h"
#import "AppAssetRetriever.h"

@implementation AppAssetManager {
    NSOperationQueue* _opQueue;
    id<AppAssetCallback> _callback;
}

static const int MAX_REQUEST_COUNT = 4;

+ (NSString*) boxArtPathForApp:(RMI_TemporaryApp*)app {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [paths objectAtIndex:0];
    
    // Keep app assets separate by host UUID
    filePath = [filePath stringByAppendingPathComponent:app.host.uuid];
    
    // Use the app ID as the file name
    filePath = [filePath stringByAppendingPathComponent:app.id];
    
    // Add a png extension
    filePath = [filePath stringByAppendingPathExtension:@"png"];
    
    return filePath;
}

- (id) initWithCallback:(id<AppAssetCallback>)callback {
    self = [super init];
    _callback = callback;
    _opQueue = [[NSOperationQueue alloc] init];
    [_opQueue setMaxConcurrentOperationCount:MAX_REQUEST_COUNT];
    
    return self;
}

- (void) retrieveAssetsFromHost:(RMI_TemporaryHost*)host {
    for (RMI_TemporaryApp* app in host.appList) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:[AppAssetManager boxArtPathForApp:app]]) {
            AppAssetRetriever* retriever = [[AppAssetRetriever alloc] init];
            retriever.app = app;
            retriever.host = host;
            retriever.callback = _callback;
            
            [_opQueue addOperation:retriever];
        }
    }
}

- (void) stopRetrieving {
    [_opQueue cancelAllOperations];
}

- (void) sendCallBackForApp:(RMI_TemporaryApp*)app {
    [_callback receivedAssetForApp:app];
}

@end
