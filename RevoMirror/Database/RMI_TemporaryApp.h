//
//  RMI_TemporaryApp.h
//  Revo Mirror
//
//  Created by Cameron Gutman on 9/30/15.
//  Copyright © 2015 RevoMirror. All rights reserved.
//

#import "RMI_TemporaryHost.h"
#import "App+CoreDataClass.h"

@interface RMI_TemporaryApp : NSObject

@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *installPath;
@property (nonatomic)                   BOOL hdrSupported;
@property (nonatomic)                   BOOL hidden;
@property (nullable, nonatomic, retain) RMI_TemporaryHost *host;

NS_ASSUME_NONNULL_BEGIN

- (id) initFromApp:(App*)app withTempHost:(RMI_TemporaryHost*)tempHost;

- (NSComparisonResult)compareName:(RMI_TemporaryApp *)other;

- (void) propagateChangesToParent:(App*)parent withHost:(Host*)host;

NS_ASSUME_NONNULL_END

@end
