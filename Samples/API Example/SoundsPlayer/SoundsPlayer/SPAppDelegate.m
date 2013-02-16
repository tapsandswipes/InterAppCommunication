//
//  SPAppDelegate.m
//  SoundsPlayer
//
//  Created by Antonio Cabezuelo Vivo on 15/02/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import "SPAppDelegate.h"
#import "SPViewController.h"
#import "IACManager.h"

@implementation SPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[SPViewController alloc] initWithNibName:@"SPViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [IACManager sharedManager].callbackURLScheme = @"iacsoundplayer";
    [self addAPIHandlers];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[IACManager sharedManager] handleOpenURL:url];
}

- (void)addAPIHandlers {
    [[IACManager sharedManager] handleAction:@"getSoundNames"
                                   withBlock:^(NSDictionary *inputParameters, IACSuccessBlock success, IACFailureBlock failure) {
                                       if (success) {
                                           NSError * __autoreleasing jserr = nil;
                                           NSString *json = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self.viewController.soundNames options:0 error:&jserr] encoding:NSUTF8StringEncoding];
                                           
                                           success(@{@"names": json}, NO);
                                       }
                                   }];
    
    [[IACManager sharedManager] handleAction:@"play"
                                   withBlock:^(NSDictionary *inputParameters, IACSuccessBlock success, IACFailureBlock failure) {
                                       BOOL played = [self.viewController playSoundWithName:inputParameters[@"sound"]];
                                       if (played) {
                                           if (success) {
                                               success(nil, NO);
                                           }
                                       } else {
                                           if (failure) {
                                               NSError *error = [NSError errorWithDomain:@"com.iac.soundplayer.error.domain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Sound not found"}];
                                               failure(error);
                                           }
                                       }
                                   }];
}
@end
