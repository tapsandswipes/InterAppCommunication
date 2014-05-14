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

// File Name   : MainViewController.m
// Description : This ViewController looks after switching between each child ViewController
//               and makes sure the GameData is correctly updated/passed over
//               Note that all child ViewControllers are loaded in the beginning and never reload/released
//               until the end

#import "MainViewController.h"
#import "IntroductionViewController.h"
#import "GamePlayViewController.h"
#import "EndingViewController.h"
#import "GameData.h"


@implementation MainViewController

@synthesize currentGameData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //NSLog(@"into MainViewController - initWithNibName ");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)switchToIntroductionView {
    //NSLog(@"==inside switchToIntroductionView");
    [currentGameData setCurrentGameStatus:statusWaitingForIntro];
	[self.view bringSubviewToFront:controllerIntro.view];

}
-(void)switchToGamePlayView {
    //NSLog(@"==inside switchToGamePlayView");
	[currentGameData setCurrentGameStatus:statusGameInProgress];
	[controllerGamePlay initializeGame];
	[self.view bringSubviewToFront:controllerGamePlay.view];
    
}
-(void)switchToEndingView {
    //NSLog(@"==inside switchToEndingView");
    [currentGameData setCurrentGameStatus:statusWaitingForEnding];
    [controllerEnding refreshDisplay];
   	[self.view bringSubviewToFront:controllerEnding.view];
}

//This looks after the decision of switching to which child viewcontroller
-(void)workOutWhereToSwitchTo {
 
    /*
	NSLog(@"into workOutWhereToSwitchTo of MainViewController");       
    NSLog(@"callerTag=%d, gameStatus=%@, isTwoPlayerMode=%@",[currentGameData callerTag],[currentGameData getGameStatusString:[currentGameData currentGameStatus]], 
          ([currentGameData isTwoPlayerMode] ? @"YES" : @"NO"));
    NSLog(@"numberOfGamesPlayed=%d, numberOfGamesDraw=%d, scoreComputer=%d, scorePlayer=%d, winnerForTwoPlayerMode=%d, isPlayerWinnerForOnePlayerMode=%@",
          [currentGameData numberOfGamesPlayed], [currentGameData numberOfGamesDraw], [currentGameData scoreComputer], [currentGameData scorePlayer],
          [currentGameData winnerForTwoPlayerMode], ([currentGameData isPlayerWinnerForOnePlayerMode] ? @"YES" : @"NO"));
    NSLog(@"diffculty level=%@",[currentGameData getGameDifficultyString:[currentGameData currentDifficultyLevel]]);
	*/
    
    if ([currentGameData callerTag]==TAG_INTRODUCTION_VIEW_CONTROLLER) {
		
        [self switchToGamePlayView];
		
    } else if ([currentGameData callerTag]==TAG_GAME_PLAY_VIEW_CONTROLLER) {
        
        [self switchToEndingView];
		
    } else if ([currentGameData callerTag]==TAG_ENDING_VIEW_CONTROLLER) {
		
		if ([currentGameData currentGameStatus]==statusRestartSameGame) {
			
			[self switchToGamePlayView];
			
		} else if ([currentGameData currentGameStatus]==statusJumpToMainMenuForNewGame) {
		
            [self switchToIntroductionView];
		}
    }
}

- (void)loadView {
	//NSLog(@"This is loadView from MainViewController");
	
	self.view=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view.backgroundColor=[UIColor clearColor];
    
	//create GameData
    currentGameData = [[GameData alloc] init];
    [currentGameData setCurrentGameStatus:statusWaitingToStartGame];
    
	//Load all child view controllers
	controllerIntro = [[IntroductionViewController alloc]
					   initWithNibName:nil
					   bundle:nil]; 
    [controllerIntro setMainViewController:self];
    [controllerIntro setIntroGameData: currentGameData];
	[self.view addSubview:controllerIntro.view];

	controllerEnding = [[EndingViewController alloc]
						initWithNibName:nil
						bundle:nil]; 
	[controllerEnding setMainViewController:self];
    [controllerEnding setEndingGameData:currentGameData];
	[self.view addSubview:controllerEnding.view];

	controllerGamePlay = [[GamePlayViewController alloc]
						  initWithNibName:nil
						  bundle:nil]; 
    [controllerGamePlay setMainViewController:self];
    [controllerGamePlay setGamePlayGameData:currentGameData];
	[self.view addSubview:controllerGamePlay.view];
    
	//switch to introduction view at the beginning
    [self switchToIntroductionView];

}

- (void)dealloc {
	//NSLog(@"MainViewController - dealloc");
    [controllerIntro release];
    [controllerGamePlay release];
    [controllerEnding release];
    [currentGameData release];

	[super dealloc];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
