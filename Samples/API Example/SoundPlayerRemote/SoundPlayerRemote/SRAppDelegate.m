//
//  SRAppDelegate.m
//  SoundPlayerRemote
//
//  Created by Antonio Cabezuelo Vivo on 15/02/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import "SRAppDelegate.h"
#import "SRViewController.h"
#import "IACManager.h"

@implementation SRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [IACManager sharedManager].callbackURLScheme = @"iacplayerremote";
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[SRViewController alloc] initWithNibName:@"SRViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{    
    return [[IACManager sharedManager] handleOpenURL:url];
}


@end
