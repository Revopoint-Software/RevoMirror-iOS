//
//  DiscoveryManager.m
//  Revo Mirror
//
//  Created by Diego Waxemberg on 1/1/15.
//  Copyright (c) 2015 RevoMirror. All rights reserved.
//

#import "DiscoveryManager.h"
#import "RMI_CryptoManager.h"
#import "HttpManager.h"
#import "RMI_Tools.h"
#import "RMI_DataManager.h"
#import "DiscoveryWorker.h"
#import "ServerInfoResponse.h"
#import "RMI_IdManager.h"

#include <Limelight.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netdb.h>

@implementation DiscoveryManager {
    NSMutableArray* _hostQueue;
    NSMutableSet* _pausedHosts;
    id<DiscoveryCallback> _callback;
    MDNSManager* _mdnsMan;
    NSOperationQueue* _opQueue;
    NSString* _uniqueId;
    NSData* _cert;
    BOOL shouldDiscover;
}

- (id)initWithHosts:(NSArray *)hosts andCallback:(id<DiscoveryCallback>)callback {
    self = [super init];
    
    // Using addHostToDiscovery ensures no duplicates
    // will make it into the list from the database
    _callback = callback;
    shouldDiscover = NO;
    _hostQueue = [NSMutableArray array];
    _pausedHosts = [NSMutableSet set];
    for (RMI_TemporaryHost* host in hosts)
    {
        [self addHostToDiscovery:host];
    }
    [_callback updateAllHosts:_hostQueue];
    
    _opQueue = [[NSOperationQueue alloc] init];
    _mdnsMan = [[MDNSManager alloc] initWithCallback:self];
    [RMI_CryptoManager generateKeyPairUsingSSL];
    _uniqueId = [RMI_IdManager getUniqueId];
    _cert = [RMI_CryptoManager readCertFromFile];
    return self;
}

+ (BOOL) isAddressLAN:(in_addr_t)addr {
    addr = htonl(addr);
    
    // 10.0.0.0/8
    if ((addr & 0xFF000000) == 0x0A000000) {
        return YES;
    }
    // 172.16.0.0/12
    else if ((addr & 0xFFF00000) == 0xAC100000) {
        return YES;
    }
    // 192.168.0.0/16
    else if ((addr & 0xFFFF0000) == 0xC0A80000) {
        return YES;
    }
    // 169.254.0.0/16
    else if ((addr & 0xFFFF0000) == 0xA9FE0000) {
        return YES;
    }
    // 100.64.0.0/10 - RFC6598 official CGN address (shouldn't see this in a LAN)
    else if ((addr & 0xFFC00000) == 0x64400000) {
        return YES;
    }
    
    return NO;
}

// This ensures that only RFC 1918 IPv4 addresses can be passed to
// the Add PC dialog. This is required to comply with Apple App Store
// Guideline 4.2.7a.
+ (BOOL) isProhibitedAddress:(NSString*)address {
#ifdef ENABLE_APP_STORE_RESTRICTIONS
    struct addrinfo hints;
    struct addrinfo* result;
    int err;
    
    // We're explicitly using AF_INET here because we don't want to
    // ever receive a synthesized IPv6 address here, even on NAT64.
    // IPv6 addresses are not restricted here because we cannot easily
    // tell whether they are local or not.
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_INET;
    err = getaddrinfo([address UTF8String], NULL, &hints, &result);
    if (err != 0 || result == NULL) {
        Log(LOG_W, @"getaddrinfo(%@) failed: %d", address, err);
        return NO;
    }
    
    if (result->ai_family != AF_INET) {
        // This should never happen due to our hints
        assert(result->ai_family == AF_INET);
        Log(LOG_W, @"Unexpected address family: %d", result->ai_family);
        freeaddrinfo(result);
        return NO;
    }
    
    BOOL ret = ![DiscoveryManager isAddressLAN:((struct sockaddr_in*)result->ai_addr)->sin_addr.s_addr];
    freeaddrinfo(result);

    return ret;
#else
    return NO;
#endif
}

- (ServerInfoResponse*) getServerInfoResponseForAddress:(NSString*)address {
    HttpManager* hMan = [[HttpManager alloc] initWithAddress:address httpsPort:0 serverCert:nil];
    ServerInfoResponse* serverInfoResponse = [[ServerInfoResponse alloc] init];
    [hMan executeRequestSynchronously:[HttpRequest requestForResponse:serverInfoResponse withUrlRequest:[hMan newServerInfoRequest:false] fallbackError:401 fallbackRequest:[hMan newHttpServerInfoRequest]]];
    return serverInfoResponse;
}

- (void) discoverHost:(NSString *)hostAddress withCallback:(void (^)(RMI_TemporaryHost *, NSString*))callback {
    BOOL prohibitedAddress = [DiscoveryManager isProhibitedAddress:hostAddress];
    NSString* prohibitedAddressMessage = RMI_MirrorStr_OnlySupports();
    ServerInfoResponse* serverInfoResponse = [self getServerInfoResponseForAddress:hostAddress];
    
    RMI_TemporaryHost* host = nil;
    if ([serverInfoResponse isStatusOk]) {
        host = [[RMI_TemporaryHost alloc] init];
        host.activeAddress = host.address = hostAddress;
        host.state = StateOnline;
        [serverInfoResponse populateHost:host];
        
        // Check if this is a new PC
        if (![self getHostInDiscovery:host.uuid]) {
            // Enforce LAN restriction for App Store Guideline 4.2.7a
            if ([DiscoveryManager isProhibitedAddress:hostAddress]) {
                // We have a prohibited address. This might be because the user specified their WAN address
                // instead of their LAN address. If that's the case, we'll try their LAN address and if we
                // can reach it through that address, we'll allow it.
                ServerInfoResponse* lanInfo = [self getServerInfoResponseForAddress:host.localAddress];
                if ([lanInfo isStatusOk]) {
                    RMI_TemporaryHost* lanHost = [[RMI_TemporaryHost alloc] init];
                    [lanInfo populateHost:lanHost];
                    
                    if (![lanHost.uuid isEqualToString:host.uuid]) {
                        // This is a different host, so it's prohibited
                        prohibitedAddress = YES;
                    }
                    else {
                        // This is the same host that is reachable on the LAN
                        prohibitedAddress = NO;
                    }
                }
                else {
                    // LAN request failed, so it's a prohibited address
                    prohibitedAddress = YES;
                }
            }
            else {
                // It's an RFC 1918 IPv4 address or IPv6 address which counts as LAN
                prohibitedAddress = NO;
            }
            
            if (prohibitedAddress) {
                callback(nil, prohibitedAddressMessage);
                return;
            }
            else if ([DiscoveryManager isAddressLAN:inet_addr([hostAddress UTF8String])]) {
                // Don't send a STUN request if we're connected to a VPN. We'll likely get the VPN
                // gateway's external address rather than the external address of the LAN.
                if (![RMI_Tools isActiveNetworkVPN]) {
                    // This host was discovered over a permissible LAN address, so we can update our
                    // external address for this host.
                    struct in_addr wanAddr;
                    int err = LiFindExternalAddressIP4("stun.moonlight-stream.org", 3478, &wanAddr.s_addr);
                    if (err == 0) {
                        char addrStr[INET_ADDRSTRLEN];
                        inet_ntop(AF_INET, &wanAddr, addrStr, sizeof(addrStr));
                        host.externalAddress = [NSString stringWithFormat: @"%s", addrStr];
                    }
                }
            }
        }
        
        if (![self addHostToDiscovery:host]) {
            callback(nil, RMI_MirrorStr_HostInformationUpdated());
        } else {
            callback(host, nil);
        }
    } else if (!prohibitedAddress) {
        callback(nil, RMI_MirrorStr_EnsureRunningProperly());
    } else {
        callback(nil, prohibitedAddressMessage);
    }
}

- (void) resetDiscoveryState {
    // Allow us to rediscover hosts that were already found before
    [_mdnsMan forgetHosts];
}

- (void) startDiscovery {
    if (shouldDiscover) {
        return;
    }
    
    Log(LOG_I, @"Starting discovery");
    shouldDiscover = YES;
    [_mdnsMan searchForHosts];
    
    @synchronized (_hostQueue) {
        for (RMI_TemporaryHost* host in _hostQueue) {
            if (![_pausedHosts containsObject:host]) {
                [_opQueue addOperation:[self createWorkerForHost:host]];
            }
        }
    }
}

- (void) stopDiscovery {
    if (!shouldDiscover) {
        return;
    }
    
    Log(LOG_I, @"Stopping discovery");
    shouldDiscover = NO;
    [_mdnsMan stopSearching];
    [_opQueue cancelAllOperations];
}

- (void) stopDiscoveryBlocking {
    Log(LOG_I, @"Stopping discovery and waiting for workers to stop");
    
    if (shouldDiscover) {
        shouldDiscover = NO;
        [_mdnsMan stopSearching];
        [_opQueue cancelAllOperations];
    }
    
    // Ensure we always wait, just in case discovery
    // was stopped already but in an async manner that
    // left operations in progress.
    [_opQueue waitUntilAllOperationsAreFinished];
    
    Log(LOG_I, @"All discovery workers stopped");
}

- (BOOL) addHostToDiscovery:(RMI_TemporaryHost *)host {
    if (host.uuid.length == 0) {
        return NO;
    }
    
    RMI_TemporaryHost *existingHost = [self getHostInDiscovery:host.uuid];
    if (existingHost != nil) {
        // NB: Our logic here depends on the fact that we never propagate
        // the entire RMI_TemporaryHost to existingHost. In particular, when mDNS
        // discovers a PC and we poll it, we will do so over HTTP which will
        // not have accurate pair state. The fields explicitly copied below
        // are accurate though.
        
        // Update address of existing host
        if (host.address != nil) {
            existingHost.address = host.address;
        }
        if (host.localAddress != nil) {
            existingHost.localAddress = host.localAddress;
        }
        if (host.ipv6Address != nil) {
            existingHost.ipv6Address = host.ipv6Address;
        }
        if (host.externalAddress != nil) {
            existingHost.externalAddress = host.externalAddress;
        }
        existingHost.activeAddress = host.activeAddress;
        existingHost.state = host.state;
        return NO;
    }
    else {
        @synchronized (_hostQueue) {
            [_hostQueue addObject:host];
            if (shouldDiscover) {
                [_opQueue addOperation:[self createWorkerForHost:host]];
            }
        }
        return YES;
    }
}

- (void) removeHostFromDiscovery:(RMI_TemporaryHost *)host {
    @synchronized (_hostQueue) {
        for (DiscoveryWorker* worker in [_opQueue operations]) {
            if ([worker getHost] == host) {
                [worker cancel];
            }
        }
        
        [_hostQueue removeObject:host];
        [_pausedHosts removeObject:host];
    }
}

- (void) pauseDiscoveryForHost:(RMI_TemporaryHost *)host {
    @synchronized (_hostQueue) {
        // Stop any worker for the host
        for (DiscoveryWorker* worker in [_opQueue operations]) {
            if ([worker getHost] == host) {
                [worker cancel];
            }
        }
        
        // Add it to the paused hosts list
        [_pausedHosts addObject:host];
    }
}

- (void) resumeDiscoveryForHost:(RMI_TemporaryHost *)host {
    @synchronized (_hostQueue) {
        // Remove it from the paused hosts list
        [_pausedHosts removeObject:host];
        
        // Start discovery again
        if (shouldDiscover) {
            [_opQueue addOperation:[self createWorkerForHost:host]];
        }
    }
}

// Override from MDNSCallback - called in a worker thread
- (void)updateHost:(RMI_TemporaryHost*)host {
    // Discover the hosts before adding to eliminate duplicates
    Log(LOG_D, @"Found host through MDNS: %@:", host.name);
    // Since this is on a background thread, we do not need to use the opQueue
    DiscoveryWorker* worker = (DiscoveryWorker*)[self createWorkerForHost:host];
    [worker discoverHost];
    if ([self addHostToDiscovery:host]) {
        Log(LOG_I, @"Found new host through MDNS: %@:", host.name);
        @synchronized (_hostQueue) {
            [_callback updateAllHosts:_hostQueue];
        }
    } else {
        Log(LOG_D, @"Found existing host through MDNS: %@", host.name);
    }
}

- (RMI_TemporaryHost*) getHostInDiscovery:(NSString*)uuidString {
    @synchronized (_hostQueue) {
        for (RMI_TemporaryHost* discoveredHost in _hostQueue) {
            if (discoveredHost.uuid.length > 0 && [discoveredHost.uuid isEqualToString:uuidString]) {
                return discoveredHost;
            }
        }
    }
    return nil;
}

- (NSOperation*) createWorkerForHost:(RMI_TemporaryHost*)host {
    DiscoveryWorker* worker = [[DiscoveryWorker alloc] initWithHost:host uniqueId:_uniqueId];
    return worker;
}

@end
