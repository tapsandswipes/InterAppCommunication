//
//  CSViewController.h
//  ChromeSample
//
//  Created by Antonio Cabezuelo Vivo on 13/02/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface CSViewController : UIViewController <UITextFieldDelegate, UIWebViewDelegate, SKStoreProductViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *openButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)openInChrome:(id)sender;
@end
