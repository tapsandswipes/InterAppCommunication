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

// File Name   : EndingViewController.m
// Description : This looks after the ending part, can enhance to display score and other stuffs

#import "EndingViewController.h"
#import "GameData.h"
#import "MainViewController.h"
#import "SharedUtilities.h"

#define TAG_ENDING_SCORE_LABEL 3001


@implementation EndingViewController

@synthesize mainViewController;
@synthesize endingGameData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //NSLog(@"into EndingViewController - initWithNibName ");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) switchBackToMainViewController { 
    //NSLog(@"switchBackToMainViewController - in EndingViewController!");
    
    [endingGameData setCallerTag:TAG_ENDING_VIEW_CONTROLLER];
    
    [mainViewController workOutWhereToSwitchTo];
    
}

- (void)dealloc
{
    //NSLog(@"EndingViewController - dealloc");
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) refreshDisplay {
    
	//NSLog(@"EndingViewController - into refreshDisplay");
		  
    UILabel *labelMsg;
    NSString *msgToDisplay;
	
	msgToDisplay = @"";

    if ([endingGameData isTwoPlayerMode]) {
        msgToDisplay = [msgToDisplay stringByAppendingFormat:@"Game #%d\n\nWinner:\n Player %d", 
                        [endingGameData numberOfGamesPlayed], [endingGameData winnerForTwoPlayerMode]];
    } else {
        msgToDisplay = [msgToDisplay stringByAppendingFormat:@"Game #%d\n\nPlayer:%d\niPhone:%d", 
                        [endingGameData numberOfGamesPlayed], [endingGameData scorePlayer], [endingGameData scoreComputer]];
    }

    labelMsg = (UILabel *) [self.view viewWithTag:TAG_ENDING_SCORE_LABEL];
    
    [labelMsg setText:msgToDisplay];
	
    [labelMsg setTextColor:[UIColor blackColor]];
    [labelMsg setFont:[UIFont systemFontOfSize:40]];
    [labelMsg sizeToFit];
		
}

#pragma mark - View lifecycle


- (void)loadView
{
    //NSLog(@"This is loadView in EndingViewController");
    self.view=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];

    self.view.backgroundColor=[UIColor clearColor];
	
    UIButton *button1;
    
    [SharedUtilities createNormalButton: button1 
                                 atPosX: 0
                                 atPosY: MAX_Y-30
                              withWidth: (MAX_X/2)-10
                             withHeight: 30			 
                            withBGColor: [UIColor whiteColor] 
                         withTitleColor: [UIColor blackColor] 
                                withTag: TAG_RETRY_SAME_GAME_TYPE
                              withTitle: @"Try again" 
                           withFontSize: 15
                             withSelfID: self 
                           withActionID: @selector(buttonClicked:)
                              ifEnabled: YES
                                 inView: self.view];
    
    UIButton *button2;
    
    [SharedUtilities createNormalButton: button2 
                                 atPosX: (MAX_X / 2)
                                 atPosY: MAX_Y-30
                              withWidth: (MAX_X/2)-10
                             withHeight: 30			 
                            withBGColor: [UIColor whiteColor] 
                         withTitleColor: [UIColor blackColor] 
                                withTag: TAG_START_NEW_GAME_TYPE
                              withTitle: @"Start new game" 
                           withFontSize: 15
                             withSelfID: self 
                           withActionID: @selector(buttonClicked:)
                              ifEnabled: YES
                                 inView: self.view];
    
    //setup label to show message
    UILabel *labelBottom; 
    [SharedUtilities createNormalLabel: labelBottom 
                                atPosX: MAX_X/4
                                atPosY: MAX_Y/4
                             withWidth: MAX_X -5
                            withHeight: 150
                           withBGColor: [UIColor clearColor]  
                         withTextColor: [UIColor blackColor] 
                               withTag: TAG_ENDING_SCORE_LABEL 
                              withText: @""
                          withFontSize: 40
                                inView: self.view];    
	
}

//------------------------------------------------------------------------------------
// Handling button pressed action
//------------------------------------------------------------------------------------
- (IBAction) buttonClicked: (id) sender
{
    int whichButton;
	
	//NSLog(@"EndingViewController - buttonClicked");
	    
    whichButton = (int) ((UIButton *)sender).tag;	
    
    if (whichButton==TAG_RETRY_SAME_GAME_TYPE) {

        [endingGameData setCurrentGameStatus:statusRestartSameGame];
		
    } else if (whichButton==TAG_START_NEW_GAME_TYPE) {

        //reset current status/scores
        [endingGameData setNumberOfGamesDraw:0];
        [endingGameData setNumberOfGamesPlayed:0];
        [endingGameData setScorePlayer:0];
        [endingGameData setScoreComputer:0];
        
        [endingGameData setCurrentGameStatus:statusJumpToMainMenuForNewGame];

    }
    
    [self switchBackToMainViewController];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
