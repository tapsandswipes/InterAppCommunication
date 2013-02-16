//
//  CSViewController.m
//  ChromeSample
//
//  Created by Antonio Cabezuelo Vivo on 13/02/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import "CSViewController.h"
#import "GoogleChromeIACClient.h"

@interface CSViewController ()

@end

@implementation CSViewController {
    GoogleChromeIACClient *chromeClient;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.urlField.text = @"http://tapsandswipes.com";
    [self openURLString:self.urlField.text];
    
    chromeClient = [GoogleChromeIACClient client];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![chromeClient isAppInstalled]) {
        self.openButton.title = @"Install chrome";
    }
}

- (IBAction)openInChrome:(id)sender {
    
    if ([chromeClient isAppInstalled]) {
        [chromeClient openURL:self.urlField.text
                    onSuccess:^{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                        message:@"URL opened in Chrome"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                    onFailure:^(NSError *error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:[error localizedDescription]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }];
    } else {
        if (NSClassFromString(@"SKStoreProductViewController")) {
            self.openButton.enabled = NO;
            SKStoreProductViewController *controller = [[SKStoreProductViewController alloc] init];
            controller.delegate = self;
            [controller loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: @"535886823"} completionBlock:^(BOOL result, NSError *error){
                if (result) {
                    [self presentModalViewController:controller animated:YES];
                } else {
                    self.openButton.enabled = YES;
                }
             }];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=535886823"]];
        }
    }
}

- (void)openURLString:(NSString*)url {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[request.URL scheme] hasPrefix:@"http"]) {
        self.urlField.text = [request.URL absoluteString];
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self openURLString:self.urlField.text];
    [textField resignFirstResponder];
    return YES;
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
    self.openButton.enabled = YES;
}
@end
