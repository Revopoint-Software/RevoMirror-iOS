//
//  RMI_IdManager.m
//  Revo Mirror
//
//  Created by Diego Waxemberg on 10/31/15.
//  Copyright © 2015 RevoMirror. All rights reserved.
//

#import "RMI_IdManager.h"
#import "RMI_DataManager.h"

@implementation RMI_IdManager

+ (NSString*) getUniqueId {
    RMI_DataManager* dataMan = [[RMI_DataManager alloc] init];

    NSString* uniqueId = [dataMan getUniqueId];
    if (uniqueId == nil) {
        uniqueId = [RMI_IdManager generateUniqueId];
        [dataMan updateUniqueId:uniqueId];
        Log(LOG_I, @"No UUID found. Generated new UUID: %@", uniqueId);
    }
    
    return uniqueId;
}

+ (NSString*) generateUniqueId {
    UInt64 uuidLong = ((UInt64) arc4random() << 32) | arc4random();
    return [NSString stringWithFormat:@"%016llx", uuidLong];
}

@end
