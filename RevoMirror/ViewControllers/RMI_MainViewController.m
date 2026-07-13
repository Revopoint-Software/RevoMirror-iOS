//  RMI_MainViewController.m
//  Revo Mirror
//
//  Created by Diego Waxemberg on 1/17/14.
//  Copyright (c) 2014 RevoMirror. All rights reserved.
//

@import ImageIO;

#import "RMI_MainViewController.h"
#import "RMI_CryptoManager.h"
#import "HttpManager.h"
#import "Connection.h"
#import "RMI_StreamManager.h"
#import "RMI_Tools.h"
#import "UIComputerView.h"
#import "RMI_DataManager.h"
#import "RMI_TemporarySettings.h"
#import "WakeOnLanManager.h"
#import "AppListResponse.h"
#import "ServerInfoResponse.h"
#import "RMI_StreamViewController.h"
#import "RMI_LoadingViewController.h"
#import "ComputerScrollView.h"
#import "RMI_TemporaryApp.h"
#import "RMI_IdManager.h"
#import "ConnectionHelper.h"
#import "AFNetworkReachabilityManager.h"
#import "RMI_NoWifiView.h"
#import "RMI_SetViewController.h"
#import "RMI_ActionSheetView.h"
#import "RMI_AlertView.h"

#import <VideoToolbox/VideoToolbox.h>

#include <Limelight.h>

@interface RMI_MainViewController ()

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *settingBtn;
@property(nonatomic,strong)RMI_NoWifiView *nowifiView;

@end

@implementation RMI_MainViewController {
    NSOperationQueue* _opQueue;
    RMI_TemporaryHost* _selectedHost;
    BOOL _showHiddenApps;
    NSString* _uniqueId;
    NSData* _clientCert;
    DiscoveryManager* _discMan;
    AppAssetManager* _appManager;
    RMI_StreamConfiguration* _streamConfig;
    RMI_AlertView* _pairAlert;
    RMI_LoadingViewController* _loadingFrame;
    UIScrollView* hostScrollView;
    NSArray* _sortedAppList;
    NSCache* _boxArtCache;
    bool _background;
    BOOL _needToStramVC;
}
static NSMutableSet* hostList;

- (void)startPairing:(NSString *)PIN {
    // Needs to be synchronous to ensure the alert is shown before any potential
    // failure callback could be invoked.
    dispatch_async(dispatch_get_main_queue(), ^{
        [RMI_AlertView showAlertWithTitle:RMI_MirrorStr_PairDevice() Message:[NSString stringWithFormat:@"%@%@",RMI_MirrorStr_PairDeviceTip(),PIN] cancelTitle:@"" otherTitle:RMI_MirrorStr_Confirm() clickBlock:^(NSInteger tag) {
            self->_pairAlert = nil;
            [self->_discMan startDiscovery];
            [self hideLoadingFrame: ^{
                [self showHostSelectionView];
            }];
        }];
        self->_pairAlert = [RMI_AlertView sharedAlertView];
    });
}

- (void)displayPairingFailureDialog:(NSString *)message {
    [_discMan startDiscovery];
    
    [self hideLoadingFrame: ^{
        [self showHostSelectionView];
        [RMI_AlertView showAlertWithTitle:RMI_MirrorStr_PairingFailed() Message:message cancelTitle:@"" otherTitle:RMI_MirrorStr_Confirm() clickBlock:^(NSInteger tag) {
            
        }];
    }];
}

- (void)pairFailed:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_pairAlert != nil) {
            [RMI_AlertView dismissAlert];
            [self displayPairingFailureDialog:message];
            self->_pairAlert = nil;
        }
    });
}

- (void)pairSuccessful:(NSData*)serverCert {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Store the cert from pairing with the host
        self->_selectedHost.serverCert = serverCert;
        
        self->_pairAlert = nil;
        [RMI_AlertView dismissAlert];
        
        [self->_discMan startDiscovery];
        [self alreadyPaired];
        
        self->_needToStramVC = YES;
    });
}

- (void)alreadyPaired {
    BOOL usingCachedAppList = false;
    
    // Capture the host here because it can change once we
    // leave the main thread
    RMI_TemporaryHost* host = _selectedHost;
    if (host == nil) {
        [self hideLoadingFrame: nil];
        return;
    }
    
    if ([host.appList count] > 0) {
        usingCachedAppList = true;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (host != self->_selectedHost) {
                [self hideLoadingFrame: nil];
                return;
            }
            
            [self updateAppsForHost:host];
            [self hideLoadingFrame: nil];
            
            if (self->_sortedAppList.count>0) {
                [self prepareToStreamApp:self->_sortedAppList[0]];
                [self performSegueWithIdentifier:@"createStreamFrame" sender:nil];
            }
        });
    }
    Log(LOG_I, @"Using cached app list: %d", usingCachedAppList);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Exempt this host from discovery while handling the applist query
        [self->_discMan pauseDiscoveryForHost:host];
        
        AppListResponse* appListResp = [ConnectionHelper getAppListForHost:host];
        
        [self->_discMan resumeDiscoveryForHost:host];

        if (![appListResp isStatusOk] || [appListResp getAppList] == nil) {
            Log(LOG_W, @"Failed to get applist: %@", appListResp.statusMessage);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (host != self->_selectedHost) {
                    [self hideLoadingFrame: nil];
                    return;
                }
                [self hideLoadingFrame: ^{
                    [self showHostSelectionView];
                    [RMI_AlertView showAlertWithTitle:RMI_MirrorStr_ConnectionInterrupted() Message:appListResp.statusMessage cancelTitle:@"" otherTitle:RMI_MirrorStr_Confirm() clickBlock:^(NSInteger tag) {
                        
                    }];
                }];
                host.state = StateOffline;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateApplist:[appListResp getAppList] forHost:host];

                if (host != self->_selectedHost) {
                    [self hideLoadingFrame: nil];
                    return;
                }
                
                [self updateAppsForHost:host];
                [self->_appManager stopRetrieving];
                [self->_appManager retrieveAssetsFromHost:host];
                [self hideLoadingFrame: nil];
                
                if (self->_needToStramVC) {
                    if (self->_sortedAppList.count>0) {
                        [self prepareToStreamApp:self->_sortedAppList[0]];
                        [self performSegueWithIdentifier:@"createStreamFrame" sender:nil];
                        self->_needToStramVC = NO;
                    }
                }
            });
        }
    });
}

- (void) updateAppEntry:(RMI_TemporaryApp*)app forHost:(RMI_TemporaryHost*)host {
    RMI_DataManager* database = [[RMI_DataManager alloc] init];
    NSMutableSet* newHostAppList = [NSMutableSet setWithSet:host.appList];

    for (RMI_TemporaryApp* savedApp in newHostAppList) {
        if ([app.id isEqualToString:savedApp.id]) {
            savedApp.name = app.name;
            savedApp.hdrSupported = app.hdrSupported;
            savedApp.hidden = app.hidden;
            
            host.appList = newHostAppList;

            [database updateAppsForExistingHost:host];
            return;
        }
    }
}
    
- (void) updateApplist:(NSSet*) newList forHost:(RMI_TemporaryHost*)host {
    RMI_DataManager* database = [[RMI_DataManager alloc] init];
    NSMutableSet* newHostAppList = [NSMutableSet setWithSet:host.appList];
    
    for (RMI_TemporaryApp* app in newList) {
        BOOL appAlreadyInList = NO;
        for (RMI_TemporaryApp* savedApp in newHostAppList) {
            if ([app.id isEqualToString:savedApp.id]) {
                savedApp.name = app.name;
                savedApp.hdrSupported = app.hdrSupported;
                // Don't propagate hidden, because we want the local data to prevail
                appAlreadyInList = YES;
                break;
            }
        }
        if (!appAlreadyInList) {
            app.host = host;
            [newHostAppList addObject:app];
        }
    }
    
    BOOL appWasRemoved;
    do {
        appWasRemoved = NO;
        
        for (RMI_TemporaryApp* app in newHostAppList) {
            appWasRemoved = YES;
            for (RMI_TemporaryApp* mergedApp in newList) {
                if ([mergedApp.id isEqualToString:app.id]) {
                    appWasRemoved = NO;
                    break;
                }
            }
            if (appWasRemoved) {
                // Removing the app mutates the list we're iterating (which isn't legal).
                // We need to jump out of this loop and restart enumeration.
                
                [newHostAppList removeObject:app];
                
                // It's important to remove the app record from the database
                // since we'll have a constraint violation now that appList
                // doesn't have this app in it.
                [database removeApp:app];
                
                break;
            }
        }
        
        // Keep looping until the list is no longer being mutated
    } while (appWasRemoved);
    
    host.appList = newHostAppList;

    [database updateAppsForExistingHost:host];
    
    // This host may be eligible for a shortcut now that the app list
    // has been populated
    [self updateHostShortcuts];
}

- (void)showHostSelectionView {
    [_appManager stopRetrieving];
    _showHiddenApps = NO;
    _selectedHost = nil;
    _sortedAppList = nil;
    
//    [self.view addSubview:hostScrollView];
}

- (void) receivedAssetForApp:(RMI_TemporaryApp*)app {
    // Update the box art cache now so we don't have to do it
    // on the main thread
    [self updateBoxArtCacheForApp:app];
}

- (void)displayDnsFailedDialog {
    [RMI_AlertView showAlertWithTitle:RMI_MirrorStr_NetworkError() Message:RMI_MirrorStr_FailedResolveHost() cancelTitle:@"" otherTitle:RMI_MirrorStr_Confirm() clickBlock:^(NSInteger tag) {
        
    }];
}

- (void) hostClicked:(RMI_TemporaryHost *)host view:(UIView *)view {
    // Treat clicks on offline hosts to be long clicks
    // This shows the context menu with wake, delete, etc. rather
    // than just hanging for a while and failing as we would in this
    // code path.
    if (host.state != StateOnline && view != nil) {
        [self hostLongClicked:host view:view];
        return;
    }
    
    Log(LOG_D, @"Clicked host: %@", host.name);
    _selectedHost = host;
    [self disableNavigation];
    
#if TARGET_OS_TV
    // Intercept the menu key to go back to the host page
    [self.navigationController.view addGestureRecognizer:_menuRecognizer];
#endif
    
    // If we are online, paired, and have a cached app list, skip straight
    // to the app grid without a loading frame. This is the fast path that users
    // should hit most. Check for a valid view because we don't want to hit the fast
    // path after coming back from streaming, since we need to fetch serverinfo too
    // so that our active game data is correct.
    if (host.state == StateOnline && host.pairState == PairStatePaired && host.appList.count > 0 && view != nil) {
        [self alreadyPaired];
        return;
    }
    
    [self showLoadingFrame: ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Wait for the PC's status to be known
            while (host.state == StateUnknown) {
                sleep(1);
            }
            
            // Don't bother polling if the server is already offline
            if (host.state == StateOffline) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideLoadingFrame:^{
                        [self showHostSelectionView];
                    }];
                });
                return;
            }
            
            HttpManager* hMan = [[HttpManager alloc] initWithHost:host];
            ServerInfoResponse* serverInfoResp = [[ServerInfoResponse alloc] init];
            
            // Exempt this host from discovery while handling the serverinfo request
            [self->_discMan pauseDiscoveryForHost:host];
            [hMan executeRequestSynchronously:[HttpRequest requestForResponse:serverInfoResp withUrlRequest:[hMan newServerInfoRequest:false]
                                                                fallbackError:401 fallbackRequest:[hMan newHttpServerInfoRequest]]];
            [self->_discMan resumeDiscoveryForHost:host];
            
            if (![serverInfoResp isStatusOk]) {
                Log(LOG_W, @"Failed to get server info: %@", serverInfoResp.statusMessage);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (host != self->_selectedHost) {
                        [self hideLoadingFrame:nil];
                        return;
                    }
                    
                    // Only display an alert if this was the result of a real
                    // user action, not just passively entering the foreground again
                    [self hideLoadingFrame: ^{
                        [self showHostSelectionView];
                        if (view != nil) {
                            [RMI_AlertView showAlertWithTitle:RMI_MirrorStr_ConnectionFailed() Message:serverInfoResp.statusMessage cancelTitle:@"" otherTitle:RMI_MirrorStr_Confirm() clickBlock:^(NSInteger tag) {
                                
                            }];
                        }
                    }];
                    
                    host.state = StateOffline;
                });
            } else {
                // Update the host object with this data
                [serverInfoResp populateHost:host];
                if (host.pairState == PairStatePaired) {
                    Log(LOG_I, @"Already Paired");
                    [self alreadyPaired];
                }
                // Only pair when this was the result of explicit user action
                else if (view != nil) {
                    Log(LOG_I, @"Trying to pair");
                    // Polling the server while pairing causes the server to screw up
                    [self->_discMan stopDiscoveryBlocking];
                    PairManager* pMan = [[PairManager alloc] initWithManager:hMan clientCert:self->_clientCert callback:self];
                    [self->_opQueue addOperation:pMan];
                }
                else {
                    // Not user action, so just return to host screen
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideLoadingFrame:^{
                            [self showHostSelectionView];
                        }];
                    });
                }
            }
        });
    }];
}

- (UIViewController*) activeViewController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}

- (void)hostLongClicked:(RMI_TemporaryHost *)host view:(UIView *)view {
    Log(LOG_D, @"Long clicked host: %@", host.name);
    [RMI_ActionSheetView showActionSheetWithAlertList:@[RMI_MirrorStr_RemoveHost()] cancelTitle:RMI_MirrorStr_Cancel() block:^(int index) {
        if (index == 1) {
            [self->_discMan removeHostFromDiscovery:host];
            RMI_DataManager* dataMan = [[RMI_DataManager alloc] init];
            [dataMan removeHost:host];
            @synchronized(hostList) {
                [hostList removeObject:host];
                [self updateAllHosts:[hostList allObjects]];
            }
        }
    }];
}

- (void) addHostClicked {
    Log(LOG_D, @"Clicked add host");
    [RMI_AlertView showInputAlertWithTitle:RMI_MirrorStr_AddDevice() Message:RMI_MirrorStr_AddDeviceTip() cancelTitle:RMI_MirrorStr_Cancel() otherTitle:RMI_MirrorStr_Confirm() clickBlock:^(NSInteger tag) {
        if (tag == 1) {
            [self showLoadingFrame:^{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    [self->_discMan discoverHost:__renameString withCallback:^(RMI_TemporaryHost* host, NSString* error){
                        if (host != nil) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self hideLoadingFrame:^{
                                    @synchronized(hostList) {
                                        [hostList addObject:host];
                                    }
                                    [self updateHosts];
                                }];
                            });
                        } else {
                            unsigned int portTestResults = LiTestClientConnectivity(CONN_TEST_SERVER, 443,
                                                                                    ML_PORT_FLAG_TCP_47984 | ML_PORT_FLAG_TCP_47989);
                            if (portTestResults != ML_TEST_RESULT_INCONCLUSIVE && portTestResults != 0) {
                                error = [error stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",RMI_MirrorStr_DeviceNetworkBlocking()]];
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self hideLoadingFrame:^{
                                    [RMI_AlertView showAlertWithTitle:RMI_MirrorStr_AddHostManually() Message:error cancelTitle:@"" otherTitle:RMI_MirrorStr_Confirm() clickBlock:^(NSInteger tag) {
                                        
                                    }];
                                }];
                            });
                        }
                    }];
                });
            }];

        }
    }];
}

- (void) prepareToStreamApp:(RMI_TemporaryApp *)app {
    _streamConfig = [[RMI_StreamConfiguration alloc] init];
    _streamConfig.host = app.host.activeAddress;
    _streamConfig.hostName = app.host.name;
    _streamConfig.httpsPort = app.host.httpsPort;
    _streamConfig.appID = app.id;
    _streamConfig.appName = app.name;
    _streamConfig.serverCert = app.host.serverCert;
    
    RMI_DataManager* dataMan = [[RMI_DataManager alloc] init];
    RMI_TemporarySettings* streamSettings = [dataMan getSettings];
    
    _streamConfig.frameRate = [streamSettings.framerate intValue];
    if (@available(iOS 10.3, *)) {
        // Don't stream more FPS than the display can show
        if (_streamConfig.frameRate > [UIScreen mainScreen].maximumFramesPerSecond) {
            _streamConfig.frameRate = (int)[UIScreen mainScreen].maximumFramesPerSecond;
            Log(LOG_W, @"Clamping FPS to maximum refresh rate: %d", _streamConfig.frameRate);
        }
    }
    
    _streamConfig.height = [streamSettings.height intValue];
    _streamConfig.width = [streamSettings.width intValue];
#if TARGET_OS_TV
    // Don't allow streaming 4K on the Apple TV HD
    struct utsname systemInfo;
    uname(&systemInfo);
    if (strcmp(systemInfo.machine, "AppleTV5,3") == 0 && _streamConfig.height >= 2160) {
        Log(LOG_W, @"4K streaming not supported on Apple TV HD");
        _streamConfig.width = 1920;
        _streamConfig.height = 1080;
    }
#endif
    
    _streamConfig.bitRate = [streamSettings.bitrate intValue];
    _streamConfig.optimizeGameSettings = streamSettings.optimizeGames;
    _streamConfig.playAudioOnPC = streamSettings.playAudioOnPC;
    _streamConfig.useFramePacing = streamSettings.useFramePacing;
    _streamConfig.swapABXYButtons = streamSettings.swapABXYButtons;
    
    // multiController must be set before calling getConnectedGamepadMask
    _streamConfig.multiController = streamSettings.multiController;
    _streamConfig.gamepadMask = [ControllerSupport getConnectedGamepadMask:_streamConfig];
    
    // Probe for supported channel configurations
    int physicalOutputChannels = (int)[AVAudioSession sharedInstance].maximumOutputNumberOfChannels;
    Log(LOG_I, @"Audio device supports %d channels", physicalOutputChannels);
    
    int numberOfChannels = MIN([streamSettings.audioConfig intValue], physicalOutputChannels);
    Log(LOG_I, @"Selected number of audio channels %d", numberOfChannels);
    if (numberOfChannels >= 8) {
        _streamConfig.audioConfiguration = AUDIO_CONFIGURATION_71_SURROUND;
    }
    else if (numberOfChannels >= 6) {
        _streamConfig.audioConfiguration = AUDIO_CONFIGURATION_51_SURROUND;
    }
    else {
        _streamConfig.audioConfiguration = AUDIO_CONFIGURATION_STEREO;
    }
    
    _streamConfig.serverCodecModeSupport = app.host.serverCodecModeSupport;
    
    switch (streamSettings.preferredCodec) {
        case CODEC_PREF_AV1:
#if defined(__IPHONE_16_0) || defined(__TVOS_16_0)
            if (VTIsHardwareDecodeSupported(kCMVideoCodecType_AV1)) {
                _streamConfig.supportedVideoFormats |= VIDEO_FORMAT_AV1_MAIN8;
            }
#endif
            // Fall-through
            
        case CODEC_PREF_AUTO:
        case CODEC_PREF_HEVC:
            if (VTIsHardwareDecodeSupported(kCMVideoCodecType_HEVC)) {
                _streamConfig.supportedVideoFormats |= VIDEO_FORMAT_H265;
            }
            // Fall-through
            
        case CODEC_PREF_H264:
            _streamConfig.supportedVideoFormats |= VIDEO_FORMAT_H264;
            break;
    }
    
    // HEVC is supported if the user wants it (or it's required by the chosen resolution) and the SoC supports it
    if ((_streamConfig.width > 4096 || _streamConfig.height > 4096 || streamSettings.enableHdr) && VTIsHardwareDecodeSupported(kCMVideoCodecType_HEVC)) {
        _streamConfig.supportedVideoFormats |= VIDEO_FORMAT_H265;
        
        // HEVC Main10 is supported if the user wants it and the display supports it
        if (streamSettings.enableHdr && (AVPlayer.availableHDRModes & AVPlayerHDRModeHDR10) != 0) {
            _streamConfig.supportedVideoFormats |= VIDEO_FORMAT_H265_MAIN10;
        }
    }
    
#if defined(__IPHONE_16_0) || defined(__TVOS_16_0)
    // Add the AV1 Main10 format if AV1 and HDR are both enabled and supported
    if ((_streamConfig.supportedVideoFormats & VIDEO_FORMAT_MASK_AV1) && streamSettings.enableHdr &&
        VTIsHardwareDecodeSupported(kCMVideoCodecType_AV1) && (AVPlayer.availableHDRModes & AVPlayerHDRModeHDR10) != 0) {
        _streamConfig.supportedVideoFormats |= VIDEO_FORMAT_AV1_MAIN10;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_streamConfig.host forKey:@"lastHost"];
    __lastHost = _streamConfig.host;
    [self updateHosts];
#endif
}

- (void)appLongClicked:(RMI_TemporaryApp *)app view:(UIView *)view {
    Log(LOG_D, @"Long clicked app: %@", app.name);
    
    [_appManager stopRetrieving];

    RMI_TemporaryApp* currentApp = [self findRunningApp:app.host];
    
    NSString* message;
    
    if (currentApp == nil || [app.id isEqualToString:currentApp.id]) {
        if (app.hidden) {
            message = @"Hidden";
        }
        else {
            message = @"";
        }
    }
    else {
        message = [NSString stringWithFormat:@"%@ is currently running", currentApp.name];
    }
    
    UIAlertController* alertController = [UIAlertController
                                          alertControllerWithTitle: app.name
                                          message:message
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction
                                actionWithTitle:currentApp == nil ? @"Launch App" : ([app.id isEqualToString:currentApp.id] ? @"Resume App" : @"Resume Running App") style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        if (currentApp != nil) {
            Log(LOG_I, @"Resuming application: %@", currentApp.name);
            [self prepareToStreamApp:currentApp];
        }
        else {
            Log(LOG_I, @"Launching application: %@", app.name);
            [self prepareToStreamApp:app];
        }

        [self performSegueWithIdentifier:@"createStreamFrame" sender:nil];
    }]];
    
    if (currentApp != nil) {
        [alertController addAction:[UIAlertAction actionWithTitle:
                                    [app.id isEqualToString:currentApp.id] ? @"Quit App" : @"Quit Running App and Start" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action){
                                        Log(LOG_I, @"Quitting application: %@", currentApp.name);
                                        [self showLoadingFrame: ^{
                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                HttpManager* hMan = [[HttpManager alloc] initWithHost:app.host];
                                                HttpResponse* quitResponse = [[HttpResponse alloc] init];
                                                HttpRequest* quitRequest = [HttpRequest requestForResponse: quitResponse withUrlRequest:[hMan newQuitAppRequest]];
                                                
                                                // Exempt this host from discovery while handling the quit operation
                                                [self->_discMan pauseDiscoveryForHost:app.host];
                                                [hMan executeRequestSynchronously:quitRequest];
                                                if (quitResponse.statusCode == 200) {
                                                    ServerInfoResponse* serverInfoResp = [[ServerInfoResponse alloc] init];
                                                    [hMan executeRequestSynchronously:[HttpRequest requestForResponse:serverInfoResp withUrlRequest:[hMan newServerInfoRequest:false]
                                                                                                        fallbackError:401 fallbackRequest:[hMan newHttpServerInfoRequest]]];
                                                    if (![serverInfoResp isStatusOk] || [[serverInfoResp getStringTag:@"state"] hasSuffix:@"_SERVER_BUSY"]) {
                                                        // On newer GFE versions, the quit request succeeds even though the app doesn't
                                                        // really quit if another client tries to kill your app. We'll patch the response
                                                        // to look like the old error in that case, so the UI behaves.
                                                        quitResponse.statusCode = 599;
                                                    }
                                                    else if ([serverInfoResp isStatusOk]) {
                                                        // Update the host object with this info
                                                        [serverInfoResp populateHost:app.host];
                                                    }
                                                }
                                                [self->_discMan resumeDiscoveryForHost:app.host];

                                                // If it fails, display an error and stop the current operation
                                                if (quitResponse.statusCode != 200) {
                                                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Quitting App Failed"
                                                                                                message:@"Failed to quit app. If this app was started by "
                                                             "another device, you'll need to quit from that device."
                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [self updateAppsForHost:app.host];
                                                        [self hideLoadingFrame: ^{
                                                            [[self activeViewController] presentViewController:alert animated:YES completion:nil];
                                                        }];
                                                    });
                                                }
                                                else {
                                                    app.host.currentGame = @"0";
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        // If it succeeds and we're to start streaming, segue to the stream
                                                        if (![app.id isEqualToString:currentApp.id]) {
                                                            [self prepareToStreamApp:app];
                                                            [self hideLoadingFrame: ^{
                                                                [self performSegueWithIdentifier:@"createStreamFrame" sender:nil];
                                                            }];
                                                        }
                                                        else {
                                                            // Otherwise, just hide the loading icon
                                                            [self hideLoadingFrame:nil];
                                                        }
                                                    });
                                                }
                                            });
                                        }];
                                        
                                    }]];
    }

    if (currentApp == nil || ![app.id isEqualToString:currentApp.id] || app.hidden) {
        [alertController addAction:[UIAlertAction actionWithTitle:app.hidden ? @"Show App" : @"Hide App"
                                                            style:app.hidden ? UIAlertActionStyleDefault : UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction* action) {
            app.hidden = !app.hidden;
            [self updateAppEntry:app forHost:app.host];
            
            // Don't call updateAppsForHost because that will nuke this
            // app immediately if we're not showing hidden apps.
        }]];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    // these two lines are required for iPad support of UIAlertSheet
    alertController.popoverPresentationController.sourceView = view;
    
    alertController.popoverPresentationController.sourceRect = CGRectMake(view.bounds.size.width / 2.0, view.bounds.size.height / 2.0, 1.0, 1.0); // center of the view
    [[self activeViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void) appClicked:(RMI_TemporaryApp *)app view:(UIView *)view {
    Log(LOG_D, @"Clicked app: %@", app.name);
    
    [_appManager stopRetrieving];
    
    if ([self findRunningApp:app.host]) {
        // If there's a running app, display a menu
        [self appLongClicked:app view:view];
    } else {
        [self prepareToStreamApp:app];
        [self performSegueWithIdentifier:@"createStreamFrame" sender:nil];
    }
}

- (RMI_TemporaryApp*) findRunningApp:(RMI_TemporaryHost*)host {
    for (RMI_TemporaryApp* app in host.appList) {
        if ([app.id isEqualToString:host.currentGame]) {
            return app;
        }
    }
    return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[RMI_StreamViewController class]]) {
        RMI_StreamViewController* streamFrame = segue.destinationViewController;
        streamFrame.streamConfig = _streamConfig;
    }
}

- (void) showLoadingFrame:(void (^)(void))completion {
    [_loadingFrame showLoadingFrame:completion];
}

- (void) hideLoadingFrame:(void (^)(void))completion {
    [self enableNavigation];
    [_loadingFrame dismissLoadingFrame:completion];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0x2B2B2B);
    [self reachabilityStatusChange];
    
    _loadingFrame = [self.storyboard instantiateViewControllerWithIdentifier:@"loadingFrame"];
    
    // Set up crypto
    [RMI_CryptoManager generateKeyPairUsingSSL];
    _uniqueId = [RMI_IdManager getUniqueId];
    _clientCert = [RMI_CryptoManager readCertFromFile];

    _appManager = [[AppAssetManager alloc] initWithCallback:self];
    _opQueue = [[NSOperationQueue alloc] init];
    
    // Only initialize the host picker list once
    if (hostList == nil) {
        hostList = [[NSMutableSet alloc] init];
    }
    
    _boxArtCache = [[NSCache alloc] init];
        
    hostScrollView = [[ComputerScrollView alloc] init];
    hostScrollView.frame = CGRectMake(RMI_StatusBarHeight, 56+32, self.view.frame.size.width-RMI_StatusBarHeight, self.view.frame.size.height-56-32);
    [hostScrollView setShowsHorizontalScrollIndicator:NO];
    hostScrollView.delaysContentTouches = NO;
    
    [self retrieveSavedHosts];
    _discMan = [[DiscoveryManager alloc] initWithHosts:[hostList allObjects] andCallback:self];
        
    [self.view addSubview:hostScrollView];
    
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    CGFloat screenScale = window.screen.scale;
    CGFloat fullScreenWidth = window.frame.size.width * screenScale;
    CGFloat fullScreenHeight = window.frame.size.height * screenScale;
    RMI_DataManager* dataMan = [[RMI_DataManager alloc] init];
    RMI_TemporarySettings* currentSettings = [dataMan getSettings];
    [dataMan saveSettingsWithBitrate:currentSettings.bitrate.integerValue framerate:60 height:fullScreenHeight width:fullScreenWidth audioConfig:currentSettings.audioConfig.integerValue onscreenControls:currentSettings.onscreenControls.integerValue optimizeGames:currentSettings.optimizeGames multiController:currentSettings.multiController swapABXYButtons:currentSettings.swapABXYButtons audioOnPC:YES preferredCodec:currentSettings.preferredCodec useFramePacing:currentSettings.useFramePacing enableHdr:currentSettings.enableHdr btMouseSupport:currentSettings.btMouseSupport absoluteTouchMode:YES statsOverlay:currentSettings.statsOverlay];
    
    [self navgationView];
    [self nowifiView];
    [self updateDeviceOrientation];
}

-(void)navgationView
{
    UIView *navView = [UIView new];
    navView.backgroundColor = UIColorFromRGB(0x2B2B2B);
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.equalTo(@56);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = RMI_MirrorStr_Mirror();
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:18.0 weight:(UIFontWeightMedium)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(navView);
    }];
    
    UIFont *font = [UIFont systemFontOfSize:14.0];
    _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingBtn.backgroundColor = UIColorFromRGB(0x5A595A);
    _settingBtn.layer.cornerRadius = 16.0;
    _settingBtn.titleLabel.numberOfLines = 0;
    _settingBtn.layer.borderWidth = 1.0;
    _settingBtn.layer.borderColor = UIColorFromRGB(0xA3A2A3).CGColor;
    [_settingBtn setTitle:RMI_MirrorStr_Setting() forState:(UIControlStateNormal)];
    _settingBtn.titleLabel.font = font;
    [_settingBtn addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    _settingBtn.clipsToBounds = YES;
    [self.view addSubview:_settingBtn];
    CGSize size = [RMI_MirrorStr_Setting() sizeWithAttributes:@{NSFontAttributeName:font}];
    float width = size.width+32;
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.view).offset(14);
        make.width.equalTo(@(width));
        make.height.equalTo(@32);
    }];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,55,RMI_IPHONE_WIDTH,1);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1.0, 0);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:0.0].CGColor,(__bridge id)[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:0.0].CGColor];
    gl.locations = @[@(0.0f),@(0.5f),@(1.0f)];
    [navView.layer addSublayer:gl];
    
    UILabel *deviceLabel = [UILabel new];
    deviceLabel.text = RMI_MirrorStr_MirrorDevice();
    deviceLabel.textColor = [UIColor whiteColor];
    deviceLabel.font = [UIFont systemFontOfSize:14.0 weight:(UIFontWeightMedium)];
    [self.view addSubview:deviceLabel];
    [deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navView.mas_bottom).offset(12);
        make.left.mas_equalTo(hostScrollView).offset(12);
    }];
    
    RMI_WeakSelf(weakSelf);
    [self ts_RMI_ChangeLanguage:^{
        weakSelf.titleLabel.text = RMI_MirrorStr_Mirror();
        [weakSelf.settingBtn setTitle:RMI_MirrorStr_Setting() forState:(UIControlStateNormal)];
        CGSize size = [RMI_MirrorStr_Setting() sizeWithAttributes:@{NSFontAttributeName:font}];
        float width = size.width+32;
        [weakSelf.settingBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width));
        }];
        deviceLabel.text = RMI_MirrorStr_MirrorDevice();
    }];
}

-(void)reachabilityStatusChange
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"ffffffff-unknown");
                self.nowifiView.hidden = NO;
                self->hostScrollView.hidden = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"ffffffff-not reachable");
                self.nowifiView.hidden = NO;
                self->hostScrollView.hidden = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"ffffffff-wan");
                self.nowifiView.hidden = NO;
                self->hostScrollView.hidden = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"ffffffff-wifi");
                self.nowifiView.hidden = YES;
                self->hostScrollView.hidden = NO;
                break;
            default:
                break;
        }
    }];
}

-(void)settingAction
{
    RMI_SetViewController *setVC = [[RMI_SetViewController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
}

-(void)beginForegroundRefresh
{
    if (!_background) {
        // This will kick off box art caching
        [self updateHosts];
        
        // Reset state first so we can rediscover hosts that were deleted before
        [_discMan resetDiscoveryState];
        [_discMan startDiscovery];
        
        // This will refresh the applist when a paired host is selected
//        if (_selectedHost != nil && _selectedHost.pairState == PairStatePaired) {
//            [self hostClicked:_selectedHost view:nil];
//        }
    }
}

-(void)handlePendingShortcutAction
{
    // Check if we have a pending shortcut action
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (delegate.pcUuidToLoad != nil) {
        // Find the host it corresponds to
        RMI_TemporaryHost* matchingHost = nil;
        for (RMI_TemporaryHost* host in hostList) {
            if ([host.uuid isEqualToString:delegate.pcUuidToLoad]) {
                matchingHost = host;
                break;
            }
        }
        
        // Clear the pending shortcut action
        delegate.pcUuidToLoad = nil;
        
        // Complete the request
        if (delegate.shortcutCompletionHandler != nil) {
            delegate.shortcutCompletionHandler(matchingHost != nil);
            delegate.shortcutCompletionHandler = nil;
        }
        
        if (matchingHost != nil && _selectedHost != matchingHost) {
            // Navigate to the host page
            [self hostClicked:matchingHost view:nil];
        }
    }
}

-(void)handleReturnToForeground
{
    _background = NO;
    
    [self beginForegroundRefresh];
    
    // Check for a pending shortcut action when returning to foreground
    [self handlePendingShortcutAction];
}

-(void)handleEnterBackground
{
    _background = YES;
    
    [_discMan stopDiscovery];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self updateDeviceOrientation];
}

-(void)updateDeviceOrientation
{
    if([RMI_Tools getWindowInterfaceOrientation]==UIInterfaceOrientationLandscapeLeft){
        //充电口朝向左边
        hostScrollView.frame = CGRectMake(0, 56+32, self.view.frame.size.width-RMI_StatusBarHeight, self.view.frame.size.height-56-32);
    }else{
        hostScrollView.frame = CGRectMake(RMI_StatusBarHeight, 56+32, self.view.frame.size.width-RMI_StatusBarHeight, self.view.frame.size.height-56-32);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
    // Hide 1px border line
    UIImage* fakeImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setShadowImage:fakeImage];
    [self.navigationController.navigationBar setBackgroundImage:fakeImage forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    // Check for a pending shortcut action when appearing
    [self handlePendingShortcutAction];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleReturnToForeground)
                                                 name: UIApplicationDidBecomeActiveNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnterBackground)
                                                 name: UIApplicationWillResignActiveNotification
                                               object: nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // We can get here on home press while streaming
    // since the stream view segues to us just before
    // entering the background. We can't check the app
    // state here (since it's in transition), so we have
    // to use this function that will use our internal
    // state here to determine whether we're foreground.
    //
    // Note that this is neccessary here as we may enter
    // this view via an error dialog from the stream
    // view, so we won't get a return to active notification
    // for that which would normally fire beginForegroundRefresh.
    [self beginForegroundRefresh];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // when discovery stops, we must create a new instance because
    // you cannot restart an NSOperation when it is finished
    [_discMan stopDiscovery];
    
    // Purge the box art cache
    [_boxArtCache removeAllObjects];
    
    // Remove our lifetime observers to avoid triggering them
    // while streaming
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) retrieveSavedHosts {
    RMI_DataManager* dataMan = [[RMI_DataManager alloc] init];
    NSArray* hosts = [dataMan getHosts];
    @synchronized(hostList) {
        [hostList addObjectsFromArray:hosts];
        
        // Initialize the non-persistent host state
        for (RMI_TemporaryHost* host in hostList) {
            if (host.activeAddress == nil) {
                host.activeAddress = host.localAddress;
            }
            if (host.activeAddress == nil) {
                host.activeAddress = host.externalAddress;
            }
            if (host.activeAddress == nil) {
                host.activeAddress = host.address;
            }
            if (host.activeAddress == nil) {
                host.activeAddress = host.ipv6Address;
            }
        }
    }
}

- (void) updateAllHosts:(NSArray *)hosts {
    // We must copy the array here because it could be modified
    // before our main thread dispatch happens.
    NSArray* hostsCopy = [NSArray arrayWithArray:hosts];
    dispatch_async(dispatch_get_main_queue(), ^{
        Log(LOG_D, @"New host list:");
        for (RMI_TemporaryHost* host in hostsCopy) {
            Log(LOG_D, @"Host: \n{\n\t name:%@ \n\t address:%@ \n\t localAddress:%@ \n\t externalAddress:%@ \n\t ipv6Address:%@ \n\t uuid:%@ \n\t mac:%@ \n\t pairState:%d \n\t online:%d \n\t activeAddress:%@ \n}", host.name, host.address, host.localAddress, host.externalAddress, host.ipv6Address, host.uuid, host.mac, host.pairState, host.state, host.activeAddress);
        }
        @synchronized(hostList) {
            [hostList removeAllObjects];
            [hostList addObjectsFromArray:hostsCopy];
        }
        [self updateHosts];
    });
}

- (void)updateHostShortcuts {
#if !TARGET_OS_TV
    NSMutableArray* quickActions = [[NSMutableArray alloc] init];
    
    @synchronized (hostList) {
        for (RMI_TemporaryHost* host in hostList) {
            // Pair state may be unknown if we haven't polled it yet, but the app list
            // count will persist from paired PCs
            if ([host.appList count] > 0) {
                UIApplicationShortcutItem* shortcut = [[UIApplicationShortcutItem alloc]
                                                       initWithType:@"PC"
                                                       localizedTitle:host.name
                                                       localizedSubtitle:nil
                                                       icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypePlay]
                                                       userInfo:[NSDictionary dictionaryWithObject:host.uuid forKey:@"UUID"]];
                [quickActions addObject: shortcut];
            }
        }
    }
    
    [UIApplication sharedApplication].shortcutItems = quickActions;
#endif
}

- (void)updateHosts {
    Log(LOG_I, @"Updating hosts...");
    [[hostScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIComputerView* addComp = [[UIComputerView alloc] initForAddWithCallback:self];
    UIComputerView* compView;
    float ogrinX = -1;
    float ogrinY = 0;
    int numIndex = 0;
    @synchronized (hostList) {
        // Sort the host list in alphabetical order
        NSArray* sortedHostList = [[hostList allObjects] sortedArrayUsingSelector:@selector(compareName:)];
//        NSMutableArray *addr = [NSMutableArray arrayWithArray:sortedHostList];
//        [addr addObjectsFromArray:sortedHostList];
        for (RMI_TemporaryHost* comp in sortedHostList) {
            compView = [[UIComputerView alloc] initWithComputer:comp andCallback:self];
            ogrinY = (numIndex/5)*compView.frame.size.height;
            numIndex++;
            compView.frame = CGRectMake([self getCompViewX:compView addComp:addComp prevEdge:ogrinX], ogrinY, compView.frame.size.width, compView.frame.size.height);
            if ((numIndex)%5==0) {
                ogrinX = -1;
            }else{
                ogrinX = compView.frame.origin.x + compView.frame.size.width;
            }
            [hostScrollView addSubview:compView];
            
            // Start jobs to decode the box art in advance
            for (RMI_TemporaryApp* app in comp.appList) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    [self updateBoxArtCacheForApp:app];
                });
            }
        }
    }
    
    // Create or delete host shortcuts as needed
    [self updateHostShortcuts];
    
    // Update the title in case we now have a PC
    
    ogrinY = ((numIndex)/5)*compView.frame.size.height;
    addComp.frame = CGRectMake([self getCompViewX:addComp addComp:addComp prevEdge:ogrinX], ogrinY, addComp.frame.size.width, addComp.frame.size.height);
    
    [hostScrollView addSubview:addComp];
    [hostScrollView setContentSize:CGSizeMake(RMI_IPHONE_WIDTH-RMI_StatusBarHeight-24-20, ogrinY+compView.frame.size.height)];
}

- (float) getCompViewX:(UIComputerView*)comp addComp:(UIComputerView*)addComp prevEdge:(float)prevEdge {
    float padding;
    
#if TARGET_OS_TV
    padding = 100;
#else
    padding = 12;
#endif
    
    if (prevEdge == -1) {
        return 12;
    } else {
        return prevEdge + padding;
    }
}

// This function forces immediate decoding of the UIImage, rather
// than the default lazy decoding that results in janky scrolling.
+ (UIImage*) loadBoxArtForCaching:(RMI_TemporaryApp*)app {
    UIImage* boxArt;
    
    NSData* imageData = [NSData dataWithContentsOfFile:[AppAssetManager boxArtPathForApp:app]];
    if (imageData == nil) {
        // No box art on disk
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil);
    
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef imageContext =  CGBitmapContextCreate(NULL, width, height, 8, width * 4, colorSpace,
                                                       kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpace);

    CGContextDrawImage(imageContext, CGRectMake(0, 0, width, height), cgImage);
    
    CGImageRef outputImage = CGBitmapContextCreateImage(imageContext);

    boxArt = [UIImage imageWithCGImage:outputImage];
    
    CGImageRelease(outputImage);
    CGContextRelease(imageContext);
    
    CGImageRelease(cgImage);
    CFRelease(source);
    
    return boxArt;
}

- (void) updateBoxArtCacheForApp:(RMI_TemporaryApp*)app {
    if ([_boxArtCache objectForKey:app] == nil) {
        UIImage* image = [RMI_MainViewController loadBoxArtForCaching:app];
        if (image != nil) {
            // Add the image to our cache if it was present
            [_boxArtCache setObject:image forKey:app];
        }
    }
}

- (void) updateAppsForHost:(RMI_TemporaryHost*)host {
    if (host != _selectedHost) {
        Log(LOG_W, @"Mismatched host during app update");
        return;
    }
    
    _sortedAppList = [host.appList allObjects];
    _sortedAppList = [_sortedAppList sortedArrayUsingSelector:@selector(compareName:)];
    
//    if (!_showHiddenApps) {
//        NSMutableArray* visibleAppList = [NSMutableArray array];
//        for (RMI_TemporaryApp* app in _sortedAppList) {
//            if (!app.hidden) {
//                [visibleAppList addObject:app];
//            }
//        }
//    }
    
//    if (!_showHiddenApps) {
//        NSMutableArray* visibleAppList = [NSMutableArray array];
//        for (RMI_TemporaryApp* app in _sortedAppList) {
//            if (!app.hidden) {
//                [visibleAppList addObject:app];
//            }
//        }
//        _sortedAppList = visibleAppList;
//    }
//    
//    [hostScrollView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Purge the box art cache on low memory
    [_boxArtCache removeAllObjects];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#if !TARGET_OS_TV
- (BOOL)shouldAutorotate {
    return YES;
}
#endif

- (void) disableNavigation {
    self.navigationController.navigationBar.topItem.rightBarButtonItem.enabled = NO;
    self.navigationController.navigationBar.topItem.leftBarButtonItem.enabled = NO;
}

- (void) enableNavigation {
    self.navigationController.navigationBar.topItem.rightBarButtonItem.enabled = YES;
    self.navigationController.navigationBar.topItem.leftBarButtonItem.enabled = YES;
}

#if TARGET_OS_TV
- (BOOL)canBecomeFocused {
    return YES;
}
#endif

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    
#if !TARGET_OS_TV
    if (context.nextFocusedView != nil) {
        [context.nextFocusedView setAlpha:0.8];
    }
    [context.previouslyFocusedView setAlpha:1.0];
#endif
}

-(RMI_NoWifiView *)nowifiView
{
    if (!_nowifiView) {
        _nowifiView = [[RMI_NoWifiView alloc] init];
        _nowifiView.backgroundColor = UIColorFromRGB(0x313031);
        [_nowifiView setUserInteractionEnabled:YES];
        RMI_WeakSelf(weakSelf);
        _nowifiView.toSettingVC = ^{
            [weakSelf settingAction];
        };
        [self.view addSubview:_nowifiView];
        [_nowifiView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.view);
        }];
    }
    return _nowifiView;
}

@end
