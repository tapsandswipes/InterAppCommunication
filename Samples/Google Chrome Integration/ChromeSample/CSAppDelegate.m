//
//  CSAppDelegate.m
//  ChromeSample
//
//  Created by Antonio Cabezuelo Vivo on 13/02/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import "CSAppDelegate.h"

#import "CSViewController.h"
#import "IACManager.h"

@implementation CSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // We add the url scheme configured in the ChromeSample-Info.plist file under URL types.
    [IACManager sharedManager].callbackURLScheme = @"iacchromesample";
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[CSViewController alloc] initWithNibName:@"CSViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // Let the manager handle external calls
    return [[IACManager sharedManager] handleOpenURL:url];
}


@end
