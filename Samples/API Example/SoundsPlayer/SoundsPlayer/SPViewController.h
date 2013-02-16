//
//  SPViewController.h
//  SoundsPlayer
//
//  Created by Antonio Cabezuelo Vivo on 15/02/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPViewController : UIViewController

@property (strong, readonly, nonatomic) NSArray *soundNames;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

- (IBAction)play:(UIButton *)sender;

- (BOOL)playSoundWithName:(NSString*)name;
@end
