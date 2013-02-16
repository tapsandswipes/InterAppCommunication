//
//  InstapaperIACClient.m
//  IACSample
//
//  Created by Antonio Cabezuelo Vivo on 12/02/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import "InstapaperIACClient.h"

@implementation InstapaperIACClient

- (instancetype)init {
    return [self initWithURLScheme:@"x-callback-instapaper"];
}

- (void)add:(NSString*)url {
    [self add:url onSuccess:nil onFailure:nil];
}

- (void)add:(NSString*)url onSuccess:(void(^)(void))onSuccess onFailure:(void(^)(NSError*))onError {
    [self performAction:@"add"
             parameters:@{@"url": url}
              onSuccess:^(NSDictionary* params) {
                  if (onSuccess) {
                      onSuccess();
                  }
              }
              onFailure:onError
     ];
}

@end
