//
//  SoundPlayerIACClient.m
//  SoundPlayerRemote
//
//  Created by Antonio Cabezuelo Vivo on 15/02/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import "SoundPlayerIACClient.h"

@implementation SoundPlayerIACClient

- (instancetype)init {
    return [self initWithURLScheme:@"iacsoundplayer"];
}

- (void)getSoundNamesWithCallback:(void(^)(NSArray *soundNames, NSError *error))callback {
    if (!callback) return;
    
    [self performAction:@"getSoundNames"
             parameters:nil
              onSuccess:^(NSDictionary *result) {
                  NSString *jsonArray = result[@"names"];
                  NSError * __autoreleasing jserr = nil;
                  NSArray *names = [NSJSONSerialization JSONObjectWithData:[jsonArray dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jserr];
                  
                  if (!jserr) {
                      callback(names, nil);
                  } else {
                      callback(nil, jserr);
                  }
              }
              onFailure:^(NSError *error) {
                  callback(nil, error);
              }
     ];
}

- (void)playSoundWithName:(NSString*)name {
    [self performAction:@"play" parameters:@{@"sound": name}];
}

@end
