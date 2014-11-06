//
//  FunboxIACClient.h
//  IACSample
//
//  Created by Antonio Cabezuelo Vivo on 10/02/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import "IACClient.h"

typedef NS_ENUM(NSInteger, FunboxError) {
    FunboxSoundNotFoundError = -1
};

@interface FunboxIACClient : IACClient

- (void)playSound:(NSString*)soundName;
- (void)playSound:(NSString*)soundName onSuccess:(void(^)(void))onSuccess onFailure:(void(^)(NSError*))onError;
- (void)downloadSoundFromUrl:(NSString*)url;

@end
