//
// Tic Tac Toe
//
// Version History:
//  1.00  3rd July 2011 - Two player mode has fully working ok for a while. Single player finally have a "smart" enough computer player in this version. Published to blog.
//  2.00 12th July 2011 - migrated to Multi-View and split file version, add 3 difficulty levels
//  2.01 13th July 2011 - put in some memory leak fixes
//
//  Created by new2objectivec@gmail.com 
//  http:// new2objectivec.blogspot.com
//
//  Copyright 2011. All rights reserved.
//
//	This code is released under the "Take your kids, family or love ones for a few hours of outdoor activities license"
//	In order to use any code in your project you must take your kids, family or love ones for at least a few hours of
//	outdoor activities. And please give some sort of credit to the author of the code either
//	on your product's website, about box, or legal agreement.
//

// File Name   : GameData.h
// Description : Header file of "GameData.m"

#import <UIKit/UIKit.h>
#define TAG_MAIN_VIEW_CONTROLLER 1001
#define TAG_INTRODUCTION_VIEW_CONTROLLER 1002
#define TAG_GAME_PLAY_VIEW_CONTROLLER 1003
#define TAG_ENDING_VIEW_CONTROLLER 1004

#define TAG_RETRY_SAME_GAME_TYPE 2001 
#define TAG_START_NEW_GAME_TYPE 2002

#define MAX_X 320.0
#define MAX_Y 450.0

#define BACKGROUND_COLOR [UIColor lightGrayColor]

typedef enum {
    statusWaitingForIntro,
    statusWaitingForEnding,
    statusWaitingToStartGame,
    statusJumpToMainMenuForNewGame,
    statusRestartSameGame,
    statusGameEnded,
    statusGameInProgress
} gameStatus;

typedef enum {
    levelBeginner,
    levelAdvanced,
    levelExpert
} difficultyLevel;

@interface GameData : NSObject {

    BOOL isTwoPlayerMode;
    BOOL isPlayerWinnerForOnePlayerMode;
    int winnerForTwoPlayerMode;
    int scoreComputer;
    int scorePlayer;
    int numberOfGamesPlayed;
    int numberOfGamesDraw;
    int callerTag;              //the caller, used to decide which view to switch to
    
    gameStatus currentGameStatus;
    difficultyLevel currentDifficultyLevel;
}


@property (nonatomic, assign) BOOL isTwoPlayerMode;
@property (nonatomic, assign) BOOL isPlayerWinnerForOnePlayerMode;
@property (nonatomic, assign) int winnerForTwoPlayerMode;
@property (nonatomic, assign) int scoreComputer;
@property (nonatomic, assign) int scorePlayer;
@property (nonatomic, assign) int numberOfGamesPlayed;
@property (nonatomic, assign) int numberOfGamesDraw;
@property (nonatomic, assign) int callerTag;
@property (nonatomic, assign) gameStatus currentGameStatus;
@property (nonatomic, assign) difficultyLevel currentDifficultyLevel;

-(NSString *)getGameStatusString:(gameStatus) theStatus;
-(NSString *)getGameDifficultyString:(difficultyLevel) theDiffLevel;
@end
