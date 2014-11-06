//
//  TTTViewController.m
//  TicTacToe
//
//  Created by Antonio Cabezuelo Vivo on 14/05/14.
//  Copyright (c) 2014 Taps and Swipes. All rights reserved.
//

#import "TTTIntroViewController.h"
#import "TTTBoardViewController.h"
#import <InterAppCommunication/IACManager.h>
#import "TTTIACClient.h"

@interface TTTIntroViewController ()

@end

@implementation TTTIntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[IACManager sharedManager] handleAction:TTTInitGameAction withBlock:^(NSDictionary *inputParameters, IACSuccessBlock success, IACFailureBlock failure) {
        TTTBoardViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TTTBoardViewController"];
        controller.gameType = GameTypeZeroPlayers;
        controller.remoteClient = [TTTIACClient clientForOpponent:inputParameters[kOponentKey]];
        controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        if (self.presentedViewController) {
            [self dismissViewControllerAnimated:YES completion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:controller animated:YES completion:nil];
                });
            }];
        } else {
            [self presentViewController:controller animated:YES completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
     TTTBoardViewController *controller = (TTTBoardViewController *)[segue destinationViewController];
     controller.gameType = sender.tag;
}

@end
