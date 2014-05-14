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

// File Name   : GameData.m
// Description : Used to store all game related data

#import "GameData.h"


@implementation GameData

@synthesize isTwoPlayerMode;
@synthesize isPlayerWinnerForOnePlayerMode;
@synthesize winnerForTwoPlayerMode;
@synthesize scoreComputer;
@synthesize scorePlayer;
@synthesize numberOfGamesPlayed;
@synthesize numberOfGamesDraw;
@synthesize callerTag;
@synthesize currentGameStatus;
@synthesize currentDifficultyLevel;

- (id)init
{
    //NSLog(@"init in GameData");
    self = [super init];
    if (self) {
        // Initialization code here.
        isTwoPlayerMode = YES;
        isPlayerWinnerForOnePlayerMode = NO;
        scorePlayer=0;
        scoreComputer=0;
        numberOfGamesPlayed=0;
        numberOfGamesDraw=0;
        callerTag=-1;
        currentGameStatus=statusWaitingForIntro;
        winnerForTwoPlayerMode=-1;
    }
    
    return self;
}

//Used to return current game status in human readable string instead of number
//good for debugging
-(NSString *)getGameStatusString:(gameStatus) theStatus {
	NSString *returnStr;
	
	returnStr=@"";
	
	switch (theStatus) {
		case statusGameEnded:
			returnStr = [returnStr stringByAppendingString:@"Game Ended Status"];
			break;
		case statusGameInProgress:
			returnStr = [returnStr stringByAppendingString:@"Game In progress Status"];
			break;
		case statusJumpToMainMenuForNewGame:
			returnStr = [returnStr stringByAppendingString:@"Jump to main menu for new game Status"];
			break;
		case statusRestartSameGame:
			returnStr = [returnStr stringByAppendingString:@"Restart same Game Status"];
			break;
		case statusWaitingForEnding:
			returnStr = [returnStr stringByAppendingString:@"Waiting for ending Status"];
			break;
		case statusWaitingForIntro:
			returnStr = [returnStr stringByAppendingString:@"Waiting for intro Status"];
			break;
		case statusWaitingToStartGame:
			returnStr = [returnStr stringByAppendingString:@"Waiting to start Game Status"];
			break;
	}
	
	return returnStr;
}

-(NSString *)getGameDifficultyString:(difficultyLevel) theDiffLevel {
    NSString *returnStr;
	
	returnStr = @"";
    
    switch (theDiffLevel) {
        case levelBeginner:
            returnStr = [returnStr stringByAppendingString:@"Beginner Level"];
            break;
        case levelAdvanced:
            returnStr = [returnStr stringByAppendingString:@"Advanced Level"];
            break;
        case levelExpert:
            returnStr = [returnStr stringByAppendingString:@"Expert Level"];
            break;            
    }
    
    return returnStr;
}

- (void)dealloc
{
    [super dealloc];
}
@end
