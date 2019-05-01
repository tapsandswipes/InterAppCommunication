# Inter-App Communication

## x-callback-url made easy

Inter-App Communication, **IAC** from now on, is a framework that allows your iOS app to communicate, very easily, with other iOS apps installed in the device that supports the [**x-callback-url**](http://x-callback-url.com/) protocol. With **IAC** you can also add an **x-callback-url** **API** to your app in a very easy and intuitive way.

**IAC** currently supports the **x-callback-url** [1.0 DRAFT specification](http://x-callback-url.com/specifications/).


## Usage

### Call external app

From anywhere in your app you can call any external app on the device with the following code

```objective-c
#import "IACClient.h"

IACClient *client = [IACClient clientWithURLScheme:@"appscheme"];
[client performAction@"action" parameters:@{@"param1": value1, @"param2": value2}];
```


You can also use, if available, client subclasses for the app you are calling. Within the framework there are clients for Instapaper and Google Chrome and many more will be added in the future. 

For example, to add a url to Instapaper from your app, you can do:

* Without specific client class:

```objective-c
#import "IACClient.h"

IACClient *client = [IACClient clientWithURLScheme:@"x-callback-instapaper"];
[client performAction@"add" parameters:@{@"url": @"http://tapsandswipes.com"}];
```

* With the client class specific for Instapaper:

```objective-c
#import "InstapaperIACClient.h"

[[InstapaperIACClient client] add:@"http://tapsandswipes.com"];
```


### Receive callbacks from the external app

If you want to be called back from the external app you can specify success and failure handler blocks, for example:

```objective-c
IACClient *client = [IACClient clientWithURLScheme:@"appscheme"];
[client performAction:@"action"
            parameters:@{@"param1": value1, @"param2": value2}
            onSuccess:^(NSDictionary *resultParams){
                NSLog(@"The app response was: %@", resultParams)
            }
            onFailure:^(NSError *error){
                NSLog(@"ERROR: %@", [error localizedDescription]);
            }
];
```

 
For the callbacks to work, your app must support the **x-callback-url** protocol. The easiest way is to let **IAC** manage that.

### Add x-callback-url support to your app

Follow these simple steps to add **x-callback-url** support to your app:

1. Define the url scheme that your app will respond to in the `Info.plist` of your app. See the section **Register Your URL Scheme** in [this article](https://developer.apple.com/documentation/uikit/core_app/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app).
 
2. Assign this scheme to the IACManager instance with `[IACManager sharedManager].callbackURLScheme = @"myappscheme";`. I recommend doing this in the delegate method `-application:didFinishLaunchingWithOptions:`

3. Call `-handleOpenURL:` from the URL handling method in the app`s delegate. For example:

```objective-c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url 
    sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
            
    return [[IACManager sharedManager] handleOpenURL:url];
}
```

With these three steps your app will be available to call other apps and receive callbacks from them.

### Add an x-callback-url API to your app

If you want to add an external **API** to your app through the **x-callback-url** protocol you can use any of these two options or both:

- Add handler blocks for your actions directly to the `IACManager` instance calling `-handleAction:withBlock:` for each action.

- Implement the `IACDelegate` protocol in any of your classes and assign the delegate to the `IACManager` instance, preferably in the app delegate `-application:didFinishLaunchingWithOptions:` method.

Action handlers take precedence over the delegate for the same action.

Explore the sample code to see all of these in place.



## Installation

#### Via CocoaPods
 
The easiest way to install **IAC** is via [CocoaPods](http://cocoapods.org). Add this line to your Podfile:
 
```sh
pod 'InterAppCommunication'
```

and run `pod install`. 
 
#### Manual
 
You can also install it manually by copying to your project the contents of the directory `InterAppCommunication`.

Within the directory `AppClients` you can find clients for some apps, copy the files for the client you want to use to your project. 


### Requirements

* **IAC** uses ARC but it may be used with non-ARC projects by setting the: ` -fobjc-arc ` compiler flag on all ` IAC*.m ` files. You can set this flag under Target -> Build Phases -> Compile Sources
* Requires iOS 5.0+ and Xcode 4.3+.



## Create an IAC client class for your app

If you have an app that already have an x-callback-url API, you can help other apps to communicate with your app by creating an `IACClient` subclass and share these classes with them.

This way you can implement the exposed API as if the app were an internal component within the caller app. You can implement the methods with the required parameters and even make some validation before the call is made.

Inside the `AppClients` directory you can find all the client subclasses currently implemented. If you have implemented one for your own app, do not hesitate to contact me and I will add it to the repository. 



## Contact

- [Personal website](http://tapsandswipes.com)
- [GitHub](http://github.com/tapsandswipes)
- [Twitter](http://twitter.com/acvivo)
- [LinkedIn](http://www.linkedin.com/in/acvivo)
- [Email](mailto:antonio@tapsandswipes.com)

If you use/enjoy Inter-app Communication framework, let me know!



## License

### MIT License

Copyright (c) 2013 Antonio Cabezuelo Vivo (http://tapsandswipes.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
