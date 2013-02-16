//
//  ChromeIACClient.h
//  IACSample
//
//  Created by Antonio Cabezuelo Vivo on 11/02/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import "IACClient.h"

@interface GoogleChromeIACClient : IACClient

- (void)openURL:(NSString*)url;
- (void)openNewTabWithURL:(NSString*)url;
- (void)openURL:(NSString*)url onSuccess:(void(^)(void))onSuccess onFailure:(void(^)(NSError*))onError;
- (void)openNewTabWithURL:(NSString*)url onSuccess:(void(^)(void))onSuccess onFailure:(void(^)(NSError*))onError;


@end
