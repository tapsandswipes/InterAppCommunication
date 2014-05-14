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

// File Name   : IntroductionViewController.m
// Description : This looks after the initial one/two player choice menu
//               can further enhanced to include "options/credit/help ....."
 
#import "IntroductionViewController.h"
#import "SharedUtilities.h"
#import "GameData.h"
#import "MainViewController.h"

#define TAG_ONE_PLAYER 101
#define TAG_TWO_PLAYERS 102
#define TAG_LEVEL_BEGINNER 401
#define TAG_LEVEL_ADVANCED 402
#define TAG_LEVEL_EXPERT 403


@implementation IntroductionViewController
@synthesize mainViewController;
@synthesize introGameData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //NSLog(@"into IntroductionViewController - initWithNibName ");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)dealloc
{
    //NSLog(@"IntroductionViewController - dealloc");
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view.backgroundColor=BACKGROUND_COLOR;
    //NSLog(@"loadView from IntroductionViewController");
    
    UILabel *labelBottom; 
    [SharedUtilities createNormalLabel: labelBottom 
                                atPosX: MAX_X/7
                                atPosY: MAX_Y/6
                             withWidth: MAX_X
                            withHeight: 150
                           withBGColor: [UIColor clearColor]  
                         withTextColor: [UIColor blackColor] 
                               withTag: 12345
                              withText: @"Tic Tac Toe"
                          withFontSize: 45
                                inView: self.view];
    
    UIButton *button1;
    
    [SharedUtilities createNormalButton: button1 
                                 atPosX: (MAX_X / 2) - 100
                                 atPosY: 200
                              withWidth: 200
                             withHeight: 30			 
                            withBGColor: [UIColor whiteColor] 
                         withTitleColor: [UIColor blackColor] 
                                withTag: TAG_ONE_PLAYER
                              withTitle: @"1 Player" 
                           withFontSize: 15
                             withSelfID: self 
                           withActionID: @selector(buttonClicked:)
                              ifEnabled: YES
                                 inView: self.view];
    
    UIButton *button2;
    
    [SharedUtilities createNormalButton: button2 
                                 atPosX: (MAX_X / 2) - 100
                                 atPosY: 300
                              withWidth: 200
                             withHeight: 30			 
                            withBGColor: [UIColor whiteColor] 
                         withTitleColor: [UIColor blackColor] 
                                withTag: TAG_TWO_PLAYERS
                              withTitle: @"2 Players" 
                           withFontSize: 15
                             withSelfID: self 
                           withActionID: @selector(buttonClicked:)
                              ifEnabled: YES
                                 inView: self.view];
    
}

-(void) switchBackToMainViewController { 
    //NSLog(@"switchBackToMainViewController - in IntroductionViewController!");
        
    [introGameData setCallerTag:TAG_INTRODUCTION_VIEW_CONTROLLER];
    [introGameData setCurrentGameStatus:statusWaitingToStartGame];
        
    [mainViewController workOutWhereToSwitchTo];
    
}


-(void) askDifficultyLevel {
    //hide 2 previous buttons
    [SharedUtilities showHideButton:TAG_ONE_PLAYER ifHideButton:YES inView:self.view];
    [SharedUtilities showHideButton:TAG_TWO_PLAYERS ifHideButton:YES inView:self.view];
    
    UIButton *button1;
    
    [SharedUtilities createNormalButton: button1 
                                 atPosX: (MAX_X / 2) - 100
                                 atPosY: 250
                              withWidth: 200
                             withHeight: 30			 
                            withBGColor: [UIColor whiteColor] 
                         withTitleColor: [UIColor blackColor] 
                                withTag: TAG_LEVEL_BEGINNER
                              withTitle: @"Beginner" 
                           withFontSize: 15
                             withSelfID: self 
                           withActionID: @selector(buttonClicked:)
                              ifEnabled: YES
                                 inView: self.view];
    
    UIButton *button2;
    
    [SharedUtilities createNormalButton: button2 
                                 atPosX: (MAX_X / 2) - 100
                                 atPosY: 300
                              withWidth: 200
                             withHeight: 30			 
                            withBGColor: [UIColor whiteColor] 
                         withTitleColor: [UIColor blackColor] 
                                withTag: TAG_LEVEL_ADVANCED
                              withTitle: @"Advanced" 
                           withFontSize: 15
                             withSelfID: self 
                           withActionID: @selector(buttonClicked:)
                              ifEnabled: YES
                                 inView: self.view];
    
    UIButton *button3;
    
    [SharedUtilities createNormalButton: button3
                                 atPosX: (MAX_X / 2) - 100
                                 atPosY: 350
                              withWidth: 200
                             withHeight: 30			 
                            withBGColor: [UIColor whiteColor] 
                         withTitleColor: [UIColor blackColor] 
                                withTag: TAG_LEVEL_EXPERT
                              withTitle: @"Expert" 
                           withFontSize: 15
                             withSelfID: self 
                           withActionID: @selector(buttonClicked:)
                              ifEnabled: YES
                                 inView: self.view];
}

//------------------------------------------------------------------------------------
// Handling button pressed action
//------------------------------------------------------------------------------------
- (IBAction) buttonClicked: (id) sender
{
    
    int whichButton;

    
    whichButton = (int) ((UIButton *)sender).tag;
    //NSLog(@"in buttonClicked whichButton = %d",whichButton);

    
    if (whichButton==TAG_ONE_PLAYER) {
        [introGameData setIsTwoPlayerMode:NO];
        [self askDifficultyLevel];
       
    } else if (whichButton==TAG_TWO_PLAYERS) {
        [introGameData setIsTwoPlayerMode:YES];
        
        [self switchBackToMainViewController];

    } else {
        
      if (whichButton==TAG_LEVEL_BEGINNER) {
        [introGameData setCurrentDifficultyLevel:levelBeginner];
      } else if (whichButton==TAG_LEVEL_ADVANCED) {
          [introGameData setCurrentDifficultyLevel:levelAdvanced];
      } else if (whichButton==TAG_LEVEL_EXPERT) {
          [introGameData setCurrentDifficultyLevel:levelExpert];
      }
    
      //hide 3 difficulty buttons
      [SharedUtilities showHideButton:TAG_LEVEL_BEGINNER ifHideButton:YES inView:self.view];
      [SharedUtilities showHideButton:TAG_LEVEL_ADVANCED ifHideButton:YES inView:self.view];
      [SharedUtilities showHideButton:TAG_LEVEL_EXPERT ifHideButton:YES inView:self.view];
    
      //show 2 previous buttons
      [SharedUtilities showHideButton:TAG_ONE_PLAYER ifHideButton:NO inView:self.view];
      [SharedUtilities showHideButton:TAG_TWO_PLAYERS ifHideButton:NO inView:self.view];
        
      [self switchBackToMainViewController];
        
    }    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
