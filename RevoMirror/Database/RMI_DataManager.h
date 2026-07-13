//
//  DataManager.h
//  Revo Mirror
//
//  Created by Diego Waxemberg on 10/28/14.
//  Copyright (c) 2014 RevoMirror. All rights reserved.
//

#import "AppDelegate.h"
#import "RMI_TemporaryHost.h"
#import "RMI_TemporaryApp.h"
#import "RMI_TemporarySettings.h"

@interface RMI_DataManager : NSObject

- (void) saveSettingsWithBitrate:(NSInteger)bitrate
                       framerate:(NSInteger)framerate
                          height:(NSInteger)height
                           width:(NSInteger)width
                audioConfig:(NSInteger)audioConfig
                onscreenControls:(NSInteger)onscreenControls
                   optimizeGames:(BOOL)optimizeGames
                 multiController:(BOOL)multiController
                 swapABXYButtons:(BOOL)swapABXYButtons
                       audioOnPC:(BOOL)audioOnPC
                  preferredCodec:(uint32_t)preferredCodec
                  useFramePacing:(BOOL)useFramePacing
                       enableHdr:(BOOL)enableHdr
                  btMouseSupport:(BOOL)btMouseSupport
               absoluteTouchMode:(BOOL)absoluteTouchMode
                    statsOverlay:(BOOL)statsOverlay;

- (NSArray*) getHosts;
- (void) updateHost:(RMI_TemporaryHost*)host;
- (void) updateAppsForExistingHost:(RMI_TemporaryHost *)host;
- (void) removeHost:(RMI_TemporaryHost*)host;
- (void) removeApp:(RMI_TemporaryApp*)app;

- (RMI_TemporarySettings*) getSettings;

- (void) updateUniqueId:(NSString*)uniqueId;
- (NSString*) getUniqueId;

@end
