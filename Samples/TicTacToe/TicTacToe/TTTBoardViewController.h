//
//  TTTBoardViewController.h
//  TicTacToe
//
//  Created by Antonio Cabezuelo Vivo on 14/05/14.
//  Copyright (c) 2014 Taps and Swipes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTTIACClient;

typedef NS_ENUM(NSUInteger, GameType) {
    GameTypeOnePlayer,
    GameTypeTwoPlayers,
    GameTypeZeroPlayers
};

@interface TTTBoardViewController : UIViewController

@property (nonatomic) GameType gameType;
@property (strong, nonatomic) TTTIACClient *remoteClient;

@end
