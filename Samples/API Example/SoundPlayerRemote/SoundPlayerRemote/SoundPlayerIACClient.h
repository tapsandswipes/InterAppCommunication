//
//  SoundPlayerIACClient.h
//  SoundPlayerRemote
//
//  Created by Antonio Cabezuelo Vivo on 15/02/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import "IACClient.h"

@interface SoundPlayerIACClient : IACClient

- (void)getSoundNamesWithCallback:(void(^)(NSArray *soundNames, NSError *error))callback;
- (void)playSoundWithName:(NSString*)name;
@end
