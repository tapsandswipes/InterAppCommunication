//
//  SRViewController.h
//  SoundPlayerRemote
//
//  Created by Antonio Cabezuelo Vivo on 15/02/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *getButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)getSounds:(UIButton *)sender;
@end
