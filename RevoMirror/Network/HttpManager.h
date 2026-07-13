//
//  HttpManager.h
//  Revo Mirror
//
//  Created by Diego Waxemberg on 10/16/14.
//  Copyright (c) 2014 RevoMirror. All rights reserved.
//

#import "HttpResponse.h"
#import "HttpRequest.h"
#import "RMI_StreamConfiguration.h"
#import "RMI_TemporaryHost.h"

@interface HttpManager : NSObject <NSURLSessionDelegate>

- (id) initWithHost:(RMI_TemporaryHost*) host;
- (id) initWithAddress:(NSString*) hostAddressPortString httpsPort:(unsigned short) httpsPort serverCert:(NSData*) serverCert;
- (void) setServerCert:(NSData*) serverCert;
- (NSURLRequest*) newPairRequest:(NSData*)salt clientCert:(NSData*)clientCert;
- (NSURLRequest*) newUnpairRequest;
- (NSURLRequest*) newChallengeRequest:(NSData*)challenge;
- (NSURLRequest*) newChallengeRespRequest:(NSData*)challengeResp;
- (NSURLRequest*) newClientSecretRespRequest:(NSString*)clientPairSecret;
- (NSURLRequest*) newPairChallenge;
- (NSURLRequest*) newAppListRequest;
- (NSURLRequest*) newServerInfoRequest:(bool)fastFail;
- (NSURLRequest*) newHttpServerInfoRequest:(bool)fastFail;
- (NSURLRequest*) newHttpServerInfoRequest;
- (NSURLRequest*) newLaunchOrResumeRequest:(NSString*)verb config:(RMI_StreamConfiguration*)config;
- (NSURLRequest*) newQuitAppRequest;
- (NSURLRequest*) newAppAssetRequestWithAppId:(NSString*)appId;
- (void) executeRequestSynchronously:(HttpRequest*)request;

@end


