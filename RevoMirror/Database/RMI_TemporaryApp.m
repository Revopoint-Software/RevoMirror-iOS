//
//  RMI_TemporaryApp.m
//  Revo Mirror
//
//  Created by Cameron Gutman on 9/30/15.
//  Copyright © 2015 RevoMirror. All rights reserved.
//

#import "RMI_TemporaryApp.h"

@implementation RMI_TemporaryApp

- (id) initFromApp:(App*)app withTempHost:(RMI_TemporaryHost*)tempHost {
    self = [self init];
    
    self.id = app.id;
    self.name = app.name;
    self.hdrSupported = app.hdrSupported;
    self.hidden = app.hidden;
    self.host = tempHost;
    
    return self;
}

- (void) propagateChangesToParent:(App*)parent withHost:(Host*)host {
    parent.id = self.id;
    parent.name = self.name;
    parent.hdrSupported = self.hdrSupported;
    parent.hidden = self.hidden;
    parent.host = host;
}

- (NSComparisonResult)compareName:(RMI_TemporaryApp *)other {
    return [self.name caseInsensitiveCompare:other.name];
}

- (NSUInteger)hash {
    return [self.host.uuid hash] * 31 + [self.id intValue];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self.host.uuid isEqualToString:((App*)object).host.uuid] &&
    [self.id isEqualToString:((App*)object).id];
}

@end
