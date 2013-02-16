//
//  InstapaperIACClient.h
//  IACSample
//
//  Created by Antonio Cabezuelo Vivo on 12/02/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import "IACClient.h"

@interface InstapaperIACClient : IACClient

- (void)add:(NSString*)url;
- (void)add:(NSString*)url onSuccess:(void(^)(void))onSuccess onFailure:(void(^)(NSError*))onError;

@end
