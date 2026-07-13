//
//  AppAssetResponse.m
//  Revo Mirror
//
//  Created by Diego Waxemberg on 2/1/15.
//  Copyright (c) 2015 RevoMirror. All rights reserved.
//

#import "AppAssetResponse.h"

@implementation AppAssetResponse
@synthesize data, statusCode, statusMessage;

- (void)populateWithData:(NSData *)imageData {
    self.data = imageData;
    self.statusMessage = @"App asset has no status message";
    self.statusCode = -1;
}
- (UIImage*) getImage {
    return [[UIImage alloc] initWithData:self.data];
}

@end
