//
//  ChromeIACClient.m
//  IACSample
//
//  Created by Antonio Cabezuelo Vivo on 11/02/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import "GoogleChromeIACClient.h"

@implementation GoogleChromeIACClient

- (instancetype)init {
    return [self initWithURLScheme:@"googlechrome-x-callback"];
}

- (void)openURL:(NSString*)url {
    [self openURL:url onSuccess:nil onFailure:nil];
}

- (void)openNewTabWithURL:(NSString*)url {
    [self openNewTabWithURL:url onSuccess:nil onFailure:nil];
}

- (void)openURL:(NSString*)url onSuccess:(void(^)(void))onSuccess onFailure:(void(^)(NSError*))onError {
    [self performAction:@"open"
             parameters:@{ @"url": url }
              onSuccess:^(NSDictionary* params) {
                  if (onSuccess) {
                      onSuccess();
                  }
              }
              onFailure:onError
     ];

}

- (void)openNewTabWithURL:(NSString*)url onSuccess:(void(^)(void))onSuccess onFailure:(void(^)(NSError*))onError {
    [self performAction:@"open"
             parameters:@{ @"url": url, @"create-new-tab": @YES }
              onSuccess:^(NSDictionary* params) {
                  if (onSuccess) {
                      onSuccess();
                  }
              }
              onFailure:onError
     ];
}

@end
