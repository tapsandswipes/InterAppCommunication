//
//  FunboxIACClient.m
//  IACSample
//
//  Created by Antonio Cabezuelo Vivo on 10/02/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import "FunboxIACClient.h"

#if !__has_feature(objc_arc)
#error InterAppComutication must be built with ARC.
// You can turn on ARC for only InterAppComutication files by adding -fobjc-arc to the build phase for each of its files.
#endif


@implementation FunboxIACClient

- (instancetype)init {
    return [self initWithURLScheme:@"funbox"];
}

- (void)playSound:(NSString*)soundName {
    [self playSound:soundName onSuccess:nil onFailure:nil];
}

- (void)playSound:(NSString*)soundName onSuccess:(void(^)(void))onSuccess onFailure:(void(^)(NSError*))onError {
    [self performAction:@"player"
             parameters:@{@"sound": soundName}
        onSuccess:^(NSDictionary* params) {
            if (onSuccess) {
                onSuccess();
            }
        }
        onFailure:onError
     ];
}

- (void)downloadSoundFromUrl:(NSString*)url {
    [self performAction:@"download"
             parameters:@{@"url": url}
     ];
}



@end
