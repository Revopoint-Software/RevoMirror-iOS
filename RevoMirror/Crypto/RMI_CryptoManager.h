//
//  RMI_CryptoManager.h
//  Revo Mirror
//
//  Created by Diego Waxemberg on 10/14/14.
//  Copyright (c) 2014 RevoMirror. All rights reserved.
//

@interface RMI_CryptoManager : NSObject

+ (void) generateKeyPairUsingSSL;
+ (NSData*) readCertFromFile;
+ (NSData*) readKeyFromFile;
+ (NSData*) readP12FromFile;
+ (NSData*) getSignatureFromCert:(NSData*)cert;
+ (NSData*) pemToDer:(NSData*)pemCertBytes;

- (NSData*) createAESKeyFromSaltSHA1:(NSData*)saltedPIN;
- (NSData*) createAESKeyFromSaltSHA256:(NSData*)saltedPIN;
- (NSData*) SHA1HashData:(NSData*)data;
- (NSData*) SHA256HashData:(NSData*)data;
- (NSData*) aesEncrypt:(NSData*)data withKey:(NSData*)key;
- (NSData*) aesDecrypt:(NSData*)data withKey:(NSData*)key;
- (bool) verifySignature:(NSData *)data withSignature:(NSData*)signature andCert:(NSData*)cert;
- (NSData*) signData:(NSData*)data withKey:(NSData*)key;

@end
