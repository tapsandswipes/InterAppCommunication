//
//  TTTBoardViewController.m
//  TicTacToe
//
//  Created by Antonio Cabezuelo Vivo on 14/05/14.
//  Copyright (c) 2014 Taps and Swipes. All rights reserved.
//

#import "TTTBoardViewController.h"
#import "DMGridModel.h"
#import "TTTIACClient.h"
#import <InterAppCommunication/IACManager.h>

@interface TTTBoardViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (nonatomic) DMPlayer currentPlayer;
@property (strong, nonatomic) DMGridModel *gridModel;
@property (nonatomic, getter = isMaster) BOOL master;
@property (nonatomic) NSUInteger drawsCount;

@end

@implementation TTTBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.gridModel = [[DMGridModel alloc] initWithSize:3];
    self.currentPlayer = PlayerA;
    
    [[IACManager sharedManager] handleAction:TTTSelectSpotAction withBlock:^(NSDictionary *inputParameters, IACSuccessBlock success, IACFailureBlock failure) {
        NSInteger spot = [inputParameters[kSpotKey] integerValue];
        [self playerMovedToSpot:spot];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.gameType == GameTypeZeroPlayers) {
        if (!self.remoteClient) {
            [IACManager sharedManager].callbackURLScheme = @"iacttta";
            self.master = YES;
            
            self.remoteClient = [[TTTIACClient alloc] initClientB];
            [self.remoteClient initGame];
            self.currentPlayer = PlayerB;
            [self startComputerTurn];
        } else {
            self.master = NO;
            [self.remoteClient show];
        }
    }
}

- (IBAction)buttonAction:(UIButton *)sender {
    if (self.gameType != GameTypeZeroPlayers) {
        if (self.gameType == GameTypeOnePlayer && self.currentPlayer == PlayerB) {
            return;
        }
        
        [self playerMovedToSpot:sender.tag];
    }
}

- (IBAction)resetAction:(UIButton *)sender {
    [self resetGame];
    
}

- (IBAction)backAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)playerMovedToSpot:(NSUInteger)spot {
    [self.gridModel setPlayer:self.currentPlayer atGridLocation:spot];
    [self updateGridView];
    [self endPlayerTurn];
}

- (void)updateGridView {
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        DMPlayer player = [self.gridModel playerAtGridIndex:idx];
        UIImage *image = nil;
        
        if (player != PlayerNone) {
            if (self.gameType == GameTypeZeroPlayers && !self.isMaster) {
                image = (player == PlayerA ? [UIImage imageNamed:@"X"] : [UIImage imageNamed:@"O"]);
            } else {
                image = (player == PlayerA ? [UIImage imageNamed:@"O"] : [UIImage imageNamed:@"X"]);
            }
        }
        
        [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }];
}

- (void)resetGame {
    [self.gridModel resetGrid];
    self.currentPlayer = PlayerA;
    [self updateGridView];
    
    if (self.gameType == GameTypeZeroPlayers) {
        if (self.isMaster) {
            [self.remoteClient initGame];
            self.currentPlayer = PlayerB;
            [self startComputerTurn];
        }
    }
}

- (void)endPlayerTurn {
	DMPlayer winner = [self.gridModel getWinner];
	if (winner != PlayerNone) { // game is over
		self.currentPlayer = PlayerNone; // no ones turn.
        if (winner == PlayerDraw && self.gameType == GameTypeZeroPlayers && self.isMaster) {
            self.drawsCount++;
            if (self.drawsCount < 2) {
                [self performSelector:@selector(resetGame) withObject:nil afterDelay:1];
            } else {
                [self apocalypseNow];
            }
        } else {
//            [self resetGame];
        }
	} else {
        if (self.gameType == GameTypeZeroPlayers) {
            [self performSelector:@selector(nextPlayerTurn) withObject:nil afterDelay:1.0];
        } else {
            [self nextPlayerTurn];
        }
	}
	
}

- (void)nextPlayerTurn {
	if (self.currentPlayer == PlayerA) {
		self.currentPlayer = PlayerB;
        if (self.gameType != GameTypeTwoPlayers) {
            [self startComputerTurn];
        }
	} else {
		self.currentPlayer = PlayerA;
	}
}

- (void)startComputerTurn {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *result = [DMGridModel getBestMoveForPlayer:PlayerB inGrid:self.gridModel depth:0];
        NSInteger bestMove = [result[0] integerValue];
        if (bestMove == NSNotFound) {
            bestMove = [self.gridModel getNextOpenSpot];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.gridModel setPlayer:PlayerB atGridLocation:bestMove];
            [self updateGridView];
            [self endPlayerTurn];
            if (self.currentPlayer != PlayerNone) {
                if (self.gameType == GameTypeZeroPlayers) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.remoteClient selectSpot:bestMove];
                    });
                }
            }
        });
    });
}

- (void)apocalypseNow {
    UIImage *apocalypseAnimation = [UIImage animatedImageNamed:@"apocalypse" duration:2];
    UIImageView *apocalypseView = [[UIImageView alloc] initWithImage:apocalypseAnimation];
    apocalypseView.frame = CGRectMake(125.0, 18.0, 311.0, 233.0);
    [self.view addSubview:apocalypseView];
    [apocalypseView startAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
