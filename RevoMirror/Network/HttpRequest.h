//
//  HttpRequest.h
//  Revo Mirror
//
//  Created by Diego Waxemberg on 2/1/15.
//  Copyright (c) 2015 RevoMirror. All rights reserved.
//

#import "HttpResponse.h"

@interface HttpRequest : NSObject

@property (nonatomic) id<Response> response;
@property (nonatomic) NSURLRequest* request;
@property (nonatomic) int fallbackError;
@property (nonatomic) NSURLRequest* fallbackRequest;

+ (instancetype) requestForResponse:(id<Response>)response withUrlRequest:(NSURLRequest*)req fallbackError:(int)error fallbackRequest:(NSURLRequest*) fallbackReq;
+ (instancetype) requestForResponse:(id<Response>)response withUrlRequest:(NSURLRequest*)req;
+ (instancetype) requestWithUrlRequest:(NSURLRequest*)req;

@end
