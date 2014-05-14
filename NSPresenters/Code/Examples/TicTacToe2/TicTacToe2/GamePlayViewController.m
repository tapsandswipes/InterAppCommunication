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

// File Name   : GamePlayViewController.m
// Description : This looks after the main game playing logic, mostly ported over from TicTacToe Ver 1.00 

#import "GamePlayViewController.h"
#import "GameData.h"
#import "MainViewController.h"
#import "SharedUtilities.h"
#import "checkWinData.h"

#define FONT_SIZE 120
#define TAG_BUTTON_FIRST 110
#define TAG_BUTTON_EXTRA 150
#define TAG_LABEL_BOTTOM 200
#define PLAYERMODE_ONE_PLAYER 0
#define PLAYERMODE_TWO_PLAYERS 1
#define INVALID_MOVE 999


@implementation GamePlayViewController

@synthesize mainViewController;
@synthesize gamePlayGameData;

int gameArray[9];
checkWinData *checkWinArray[8]; //used to check status of all possible 8 winning row - 3 x Horizontal, 3 x Vertica, 2 x Cross
BOOL XsTurn;     // who's turn?
BOOL isGameOver; // game over yet?
BOOL computersMove; // is it computer's turn to move?
int playerMode;  // which palyer mode? 1 or 2
int XOCount;     // how many moves been made
int lastMove;    // keep track of last move


-(void) createButtonXY:(UIView *)viewName atX:(float) locX andY:(float) locY  withTagID:(int)tagID{
    
    UIButton *buttonNext;
	
	//check if that button to be created already existed
	buttonNext = (UIButton *) [self.view viewWithTag:tagID];
	
	
	if (buttonNext==nil) {
		//NSLog(@"Button with tag %d not found, creating new button",tagID);
		
		[SharedUtilities createNormalButton: buttonNext 
							  atPosX: locX
							  atPosY: locY 
						   withWidth: (MAX_X/3)
						  withHeight: (MAX_Y/3)			 
						 withBGColor: [UIColor whiteColor] 
					  withTitleColor: [UIColor blackColor] 
							 withTag: tagID 
						   withTitle: @"" 
						withFontSize: FONT_SIZE
						  withSelfID: self 
						withActionID: @selector(buttonPressed:)
						   ifEnabled: YES
							  inView: viewName];    
	} else {
		//NSLog(@"Button with tag %d already existed, no new creation required, just reset title", tagID);
		[buttonNext setTitle:@"" forState:UIControlStateNormal];
		[buttonNext setEnabled:YES];
   
	}

}

//------------------------------------------------------------------------------------
// Methods used for working out computer's move
//------------------------------------------------------------------------------------
-(int) computersTurnCheckCornerMove:(int)posStoneUser userStone:(int)userStoneValue compPos:(int)pos0 checkPos1:(int)pos1 checkPos2:(int)pos2 {
    int result;
    result=INVALID_MOVE;
    
    //NSLog(@"ino computersTurnCheckCornerMove, posStoneUser=%d, compPos=%d ", posStoneUser, pos0);
    if (((gameArray[posStoneUser]==userStoneValue) && (gameArray[pos0]!=INVALID_MOVE) && (gameArray[pos0]!=userStoneValue)) |
        ((gameArray[pos0]==userStoneValue) && (gameArray[pos0]!=INVALID_MOVE) && (gameArray[posStoneUser]!=userStoneValue)))
    {
        
        if (gameArray[pos1]==INVALID_MOVE) {
            result=pos1;
        } else if (gameArray[pos2]==INVALID_MOVE) {
            result=pos2;
        }
    } else {
        
    }
    
    return result;
}

-(int)computersTurnCheckSideMove:(int)userStoneValue corner1:(int)posCorner1 corner2:(int)posCorner2 blankPos1:(int)bPos1 blankPos2:(int)bPos2 blankPos3:(int)bPos3 {
    int result;
    result=INVALID_MOVE;
    
    if ((gameArray[posCorner1]==userStoneValue) && (gameArray[posCorner2]==userStoneValue) && 
        (gameArray[bPos1]==INVALID_MOVE) && (gameArray[bPos2]==INVALID_MOVE) && (gameArray[bPos3]==INVALID_MOVE)) {
        
        result=bPos1;
    }
    
    return result;
}


-(int) computersTurnRandomMove {
    int ii;
    do {
        ii = (arc4random() % 9);
        if (gameArray[ii]==INVALID_MOVE) {
            break;
        }
    } while (!(gameArray[ii]==INVALID_MOVE));	
    
    return ii;
}

-(int) computersTurnCheckBestMove {
    int result;
    int tmpValue;
    int whichLine;
    
    result=INVALID_MOVE;
    tmpValue=-1;
    whichLine=-1;
    
    //check which item in checkWinArray has highest score
    for (int ii=0; ii<8; ii++) {
        if ([checkWinArray[ii] getListScore]>tmpValue) {
            whichLine=ii;
            tmpValue=[checkWinArray[ii] getListScore];
        }
    }
    
    if (whichLine!=-1) {
        if (gameArray[[checkWinArray[whichLine] getPos1]]==INVALID_MOVE) result=[checkWinArray[whichLine] getPos1];
        if (gameArray[[checkWinArray[whichLine] getPos2]]==INVALID_MOVE) result=[checkWinArray[whichLine] getPos2];
        if (gameArray[[checkWinArray[whichLine] getPos3]]==INVALID_MOVE) result=[checkWinArray[whichLine] getPos3];
    }
    
    return result;
}

-(void)computersTurn {
	
    int attackNumb;
    UIButton *buttonToClick;
    UILabel *labelBottom;
    
    int stoneComp;
    int stoneUser;
	
	//NSLog(@"into computersTurn...");
    
    if (computersMove) {
        stoneComp=1;
        stoneUser=2;
    } else {
        stoneComp=2;
        stoneUser=1;
    }
	
    //update checkWinArray data for user's last move
    for (int ii=0; ii<8; ii++) {
        [checkWinArray[ii] updateNewStone:lastMove userType:stoneUser compType:stoneComp];
    }
    
    labelBottom = (UILabel *) [self.view viewWithTag:TAG_LABEL_BOTTOM];
    
    [labelBottom setText:@"Computer's turn..."];
    
    attackNumb = INVALID_MOVE;
    
    if ([gamePlayGameData currentDifficultyLevel]==levelBeginner) {
        
        //always user random move for beginner
        attackNumb = [self computersTurnRandomMove];
        
    } else {
    
        switch (XOCount) {
            case 0: // computer first
                //pick random one 
                attackNumb = [self computersTurnRandomMove]; 
                break;
                
            case 1: //user 1st, computer 2nd
                //get middle one if still available
                if (gameArray[4]==INVALID_MOVE) {
                    attackNumb = 4;
                } else {
                    //otherwise randome move, until can get 1 corner
                    do {
                        attackNumb = [self computersTurnRandomMove];
                    } while ((attackNumb!=0) && (attackNumb!=2) && (attackNumb!=6) && (attackNumb!=8));
                } 
                break;
                
            case 2: // computer 3rd
                //pick best move
                attackNumb = [self computersTurnCheckBestMove]; 
                break;
                
            case 3: // computer 4th
                
                //only check 2 special conditions in expert level
                if ([gamePlayGameData currentDifficultyLevel]==levelExpert) {
                
                        // handle tricky case #1
                        // u-> center, c-> 4 corner, u-> opposite corner or
                        // u-> corner, c-> opposite corner, u-> center
                        if ((gameArray[4]==stoneUser))
                        {
                            attackNumb = [self computersTurnCheckCornerMove:0 userStone:stoneUser compPos:8 checkPos1:2 checkPos2:6]; 

                            if (attackNumb==INVALID_MOVE) {
                                attackNumb = [self computersTurnCheckCornerMove:2 userStone:stoneUser compPos:6 checkPos1:0 checkPos2:8];
                            } else break;
                            
                        } else {
                            //handle tricky case #2
                            // u-> 1,3 (or 3,7 | 5,7 | 5,1) and blank in 0,2,6
                            
                            attackNumb = [self computersTurnCheckSideMove:stoneUser corner1:1 corner2:3 blankPos1:0 blankPos2:2 blankPos3:6];
                            
                            if (attackNumb==INVALID_MOVE) {
                                
                                attackNumb = [self computersTurnCheckSideMove:stoneUser corner1:3 corner2:7 blankPos1:6 blankPos2:0 blankPos3:8];
                                
                                if (attackNumb==INVALID_MOVE) {
                                    
                                    attackNumb = [self computersTurnCheckSideMove:stoneUser corner1:7 corner2:5 blankPos1:8 blankPos2:6 blankPos3:2];
                                    
                                    if (attackNumb==INVALID_MOVE) {
                                        
                                        attackNumb = [self computersTurnCheckSideMove:stoneUser corner1:5 corner2:1 blankPos1:2 blankPos2:0 blankPos3:8];
                                        
                                    } else break;
                                    
                                } else break;
                                
                            } else break;
                            
                        }
                }
                
                if (attackNumb==INVALID_MOVE) {
                    //check best move
                    attackNumb = [self computersTurnCheckBestMove]; 
                }
                
                break;
                
            default:
                attackNumb = [self computersTurnCheckBestMove];
                break;
        }
    }
    
    //in case any problem, use random
    if (!((attackNumb>=0) & (attackNumb<=8))) {
        attackNumb = [self computersTurnRandomMove]; 
    }
	
	//update checkWinArray data with computer's move
    for (int ii=0; ii<8; ii++) {
        [checkWinArray[ii] updateNewStone:attackNumb userType:stoneComp compType:stoneComp];
    }
    
    [labelBottom setText:@"Your turn..."];
    
    //This is for calling the same "buttonPressed" for the computer's move
    buttonToClick = (UIButton *) [self.view viewWithTag:(110+attackNumb)];
    SEL action = NSSelectorFromString(@"buttonPressed:");
    [self performSelector:action withObject:buttonToClick];
    
	//NSLog(@"end of computersTurn...");

}

//------------------------------------------------------------------------------------
// Logic for checking if game over
//------------------------------------------------------------------------------------

-(BOOL) subCheckIfGameOver:(int)index1 p2:(int)index2 p3:(int)index3 {
    if ((gameArray[index1]==gameArray[index2]) && 
        (gameArray[index1]==gameArray[index3]) &&
        !(gameArray[index1]==INVALID_MOVE)) {
	  return YES;
    }
    return NO;
}

// changed to return int instead of BOOL
// to make it easier to work out which row is the winning row
-(int) checkIfGameOver {
    
	//NSLog(@"into checkIfGameOver");
	
    //only worth to check if more than 5 stones been played
    if (XOCount>=5) {
        //Horizontal
        if ([self subCheckIfGameOver:0 p2:1 p3:2]) return 0;
        if ([self subCheckIfGameOver:3 p2:4 p3:5]) return 1;
        if ([self subCheckIfGameOver:6 p2:7 p3:8]) return 2;
        
        //Vertical
        if ([self subCheckIfGameOver:0 p2:3 p3:6]) return 3;
        if ([self subCheckIfGameOver:1 p2:4 p3:7]) return 4;
        if ([self subCheckIfGameOver:2 p2:5 p3:8]) return 5;
        
        //Cross
        if ([self subCheckIfGameOver:0 p2:4 p3:8]) return 6;
        if ([self subCheckIfGameOver:2 p2:4 p3:6]) return 7;
        
    }
    
    return -1;
}

-(void) switchBackToMainViewController {
	
	//NSLog(@"into switchBackToMainViewController");
    
    [gamePlayGameData setCallerTag:TAG_GAME_PLAY_VIEW_CONTROLLER];
    [gamePlayGameData setCurrentGameStatus:statusGameEnded];
    
    [mainViewController workOutWhereToSwitchTo];
	
	//NSLog(@"end of switchBackToMainViewController");
    
}

//------------------------------------------------------------------------------------
// Things to process after game over
//------------------------------------------------------------------------------------
-(void) animationWinningRow:(int)whichRowWon {
	UIButton *anButton[3];
	
	//work out the 3 winning buttons from checkWinArray
	anButton[0] = (UIButton *) [self.view viewWithTag:
						 ([checkWinArray[whichRowWon] getPos1]+TAG_BUTTON_FIRST)];
 	anButton[1] = (UIButton *) [self.view viewWithTag:
						 ([checkWinArray[whichRowWon] getPos2]+TAG_BUTTON_FIRST)];
    anButton[2] = (UIButton *) [self.view viewWithTag:
					     ([checkWinArray[whichRowWon] getPos3]+TAG_BUTTON_FIRST)];														  
	
	[UIView beginAnimations:@"ChangeFont1" context:NULL];
	[UIView setAnimationDuration:1.5];
	for (int ii=0; ii<3; ii++ ) {
		[anButton[ii] setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
    }	 
	[UIView commitAnimations];
	
	[UIView beginAnimations:@"ChangeFont2" context:NULL];
	[UIView setAnimationDuration:1.5];
	for (int ii=0; ii<3; ii++ ) {
		[anButton[ii] setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    }	 
	[UIView commitAnimations];
						  
}

-(void) gameOverProcessing:(BOOL)hasWinner winningRow:(int)whichRowWon{
    	
    //NSLog(@"into gameOverProcessing, whichRowWon=%d", whichRowWon);
    
    UIButton *tmpButton;
    UILabel *tmpLabel;
    NSString *tmpString;
    
    isGameOver = YES;
    
    [gamePlayGameData setNumberOfGamesPlayed:([gamePlayGameData numberOfGamesPlayed]+1)];
    
    //disable all buttons
    for (int ii=0; ii<9; ii++) {
        tmpButton = (UIButton *) [self.view viewWithTag:TAG_BUTTON_FIRST+ii];
        [tmpButton setEnabled:NO];
    }
    
    tmpString = @"Game over! ";
    
    if ((hasWinner) && (whichRowWon>=0)) {
        
        if (XsTurn) {
            if (playerMode==PLAYERMODE_TWO_PLAYERS) {
                tmpString = [tmpString stringByAppendingString:@"Winner is Player 2"];
                [gamePlayGameData setWinnerForTwoPlayerMode:2];
            } else {
                if (XsTurn==computersMove) {
                    tmpString = [tmpString stringByAppendingString:@"You are the winner"];      
                    [gamePlayGameData setScorePlayer:([gamePlayGameData scorePlayer]+1)];
                    [gamePlayGameData setIsPlayerWinnerForOnePlayerMode:YES];
                } else {
                    tmpString = [tmpString stringByAppendingString:@"You lose"];
                    [gamePlayGameData setScoreComputer:([gamePlayGameData scoreComputer]+1)];
                    [gamePlayGameData setIsPlayerWinnerForOnePlayerMode:NO];
                }
            }
        } else {
            if (playerMode==PLAYERMODE_TWO_PLAYERS) {
                tmpString = [tmpString stringByAppendingString:@"Winner is Player 1"];
                [gamePlayGameData setWinnerForTwoPlayerMode:1];
            } else {
                if (XsTurn==computersMove) {
                    tmpString = [tmpString stringByAppendingString:@"You are the winner"];      
                    [gamePlayGameData setScorePlayer:([gamePlayGameData scorePlayer]+1)];
                    [gamePlayGameData setIsPlayerWinnerForOnePlayerMode:YES];
                } else {
                    tmpString = [tmpString stringByAppendingString:@"You lose"];
                    [gamePlayGameData setScoreComputer:([gamePlayGameData scoreComputer]+1)];
                    [gamePlayGameData setIsPlayerWinnerForOnePlayerMode:NO];
                }
                
            }
        }
		
		[self animationWinningRow:whichRowWon];
		
    } else {
        tmpString = [tmpString stringByAppendingString:@"Draw! Please try again!"];
        
        [gamePlayGameData setNumberOfGamesDraw:([gamePlayGameData numberOfGamesDraw]+1)];
        
    }
    
    //update the label at the botom
    tmpLabel = (UILabel *) [self.view viewWithTag:TAG_LABEL_BOTTOM];
    [tmpLabel setText:tmpString];
	
    [self switchBackToMainViewController];
    
	//NSLog(@"end of gameOverProcessing");
}

//------------------------------------------------------------------------------------
// Updating message at the bottom of the screen
//------------------------------------------------------------------------------------
-(void)initialUpdateBottomMsg{
    
    NSString *msgToDisplay;
	
	//NSLog(@"into initialUpdateBottomMsg");
	
	msgToDisplay=@"";
    
    //only show "Computer First" button if 1 player mode
    if (playerMode==PLAYERMODE_ONE_PLAYER) {
        
        UIButton *buttonBeginning;
        
        [SharedUtilities createNormalButton: buttonBeginning 
                          atPosX: (MAX_X/3)*2
                          atPosY: MAX_Y
                       withWidth: (MAX_X/3)
                      withHeight: 30			 
                     withBGColor: [UIColor whiteColor] 
                  withTitleColor: [UIColor blackColor] 
                         withTag: TAG_BUTTON_EXTRA
                       withTitle: @"Computer First" 
                    withFontSize: 15
                      withSelfID: self 
                    withActionID: @selector(buttonPressed:)
                       ifEnabled: YES
                          inView: self.view];   
        
        msgToDisplay = [msgToDisplay stringByAppendingString:@"Please click any of 9 boxes to start, or 'Computer First' to play as Player 2"];
        
    } else {
        //msg for 2 players mode
        msgToDisplay = [msgToDisplay stringByAppendingString:@"Player 1's turn"];
    }
    
    //setup label to show message
    UILabel *labelBottom;
    
    [SharedUtilities createNormalLabel: labelBottom 
                     atPosX: 0 
                     atPosY: MAX_Y 
                  withWidth: (MAX_X/3)*2 
                 withHeight: 30
                withBGColor: [UIColor clearColor]  
              withTextColor: [UIColor blackColor] 
                    withTag: TAG_LABEL_BOTTOM 
                   withText: msgToDisplay
               withFontSize: 11
                     inView: self.view];
	
	//NSLog(@"end of initialUpdateBottomMsg");
}

//------------------------------------------------------------------------------------
// initializing game variables
//------------------------------------------------------------------------------------
-(void) initializeGame {
    
    //NSLog(@"into initializeGame!");
    
	self.view=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	
	self.view.backgroundColor=[UIColor clearColor];
    
    //draw buttons
    [self createButtonXY:self.view atX:0 andY:0 withTagID:TAG_BUTTON_FIRST];
    [self createButtonXY:self.view atX:(MAX_X/3)+1 andY:0 withTagID:TAG_BUTTON_FIRST+1];
    [self createButtonXY:self.view atX:(MAX_X/3)*2+1 andY:0 withTagID:TAG_BUTTON_FIRST+2];
    
    [self createButtonXY:self.view atX:0 andY:(MAX_Y/3) withTagID:TAG_BUTTON_FIRST+3];
    [self createButtonXY:self.view atX:(MAX_X/3)+1 andY:(MAX_Y/3) withTagID:TAG_BUTTON_FIRST+4];
    [self createButtonXY:self.view atX:(MAX_X/3)*2+1 andY:(MAX_Y/3) withTagID:TAG_BUTTON_FIRST+5];
    
    [self createButtonXY:self.view atX:0 andY:(MAX_Y/3)*2 withTagID:TAG_BUTTON_FIRST+6];
    [self createButtonXY:self.view atX:(MAX_X/3)+1 andY:(MAX_Y/3)*2 withTagID:TAG_BUTTON_FIRST+7];
    [self createButtonXY:self.view atX:(MAX_X/3)*2+1 andY:(MAX_Y/3)*2 withTagID:TAG_BUTTON_FIRST+8];
    
    //initialise Array Data
    for (int ii=0; ii<9; ii++) {
        gameArray[ii]=INVALID_MOVE;
    }
    
    //setup checkWinArray, each of them monitor one of each possible winning rows
    [checkWinArray[0] initWith3Pos:0 tPos2:1 tPos3:2];
    [checkWinArray[1] initWith3Pos:3 tPos2:4 tPos3:5];
    [checkWinArray[2] initWith3Pos:6 tPos2:7 tPos3:8];
    [checkWinArray[3] initWith3Pos:0 tPos2:3 tPos3:6];
    [checkWinArray[4] initWith3Pos:1 tPos2:4 tPos3:7];
    [checkWinArray[5] initWith3Pos:2 tPos2:5 tPos3:8];
    [checkWinArray[6] initWith3Pos:0 tPos2:4 tPos3:8];
    [checkWinArray[7] initWith3Pos:2 tPos2:4 tPos3:6];
	
    //default value
    isGameOver = NO;
    lastMove=INVALID_MOVE;
    XsTurn = YES;
    computersMove = NO;
	if ([gamePlayGameData isTwoPlayerMode]) {
		playerMode = PLAYERMODE_TWO_PLAYERS;
	} else	{
		playerMode = PLAYERMODE_ONE_PLAYER;
	}
    
    XOCount = 0;
	
	[self initialUpdateBottomMsg];
	
	//NSLog(@"end of initializeGame!");
}

//------------------------------------------------------------------------------------
// Handling button pressed action
//------------------------------------------------------------------------------------
- (IBAction) buttonPressed: (id) sender
{
    
    int whichButton;
    int whichIndex;
    int whichPlayer;
    NSString *CurPlayer;
    UIButton *clickedButton;
    UILabel *labelBottom;
    UIButton *buttonBottom;
    
    labelBottom = (UILabel *) [self.view viewWithTag:TAG_LABEL_BOTTOM];
    buttonBottom = (UIButton *) [self.view viewWithTag:TAG_BUTTON_EXTRA];
    
    whichButton = (int) ((UIButton *)sender).tag;
    
    //Convert tag to index
    whichIndex = whichButton-TAG_BUTTON_FIRST;
    
	
	//NSLog(@"into buttonPressed, whichButton=%d, whichIndex=%d",whichButton, whichIndex);
	
    //keep track of last move
    lastMove = whichIndex;
    
    //for 1 player mode, always hide bottom button if past 1st click
    if ((XOCount>=1) && (playerMode!=PLAYERMODE_TWO_PLAYERS)) {
        [buttonBottom setHidden:YES];
    }
    
    //One of the 9 center buttons clicked
    if (whichIndex<=9) {
        
        if (XsTurn) {
            CurPlayer = @"X";
            whichPlayer = 1;
            
            if (playerMode==PLAYERMODE_TWO_PLAYERS) {
                [labelBottom setText:@"Player 2's turn"];
            } else {
                [labelBottom setText:@"Player 2 (Computer)'s turn"];   
            }
        } else {
            CurPlayer = @"O";
            whichPlayer = 2;
            if (playerMode==PLAYERMODE_TWO_PLAYERS) {
                [labelBottom setText:@"Player 1's turn"];
            } else {
                [labelBottom setText:@"Player 1 (Computer)'s turn"];
            }   
        }
        
        //increase counter, this records how many moves been made
        XOCount++;
        
        //swap turn
        XsTurn = !XsTurn;
        
        //check which of the 9 buttons been clicked
        clickedButton = (UIButton *) [self.view viewWithTag:whichButton];
        
        //disable the clicked button
        [clickedButton setEnabled:NO];
        
        //change the title to show correct stone
        [clickedButton setTitle:CurPlayer forState:UIControlStateDisabled];
        
        //update gameArray data
        gameArray[whichIndex] = whichPlayer;
        
		int whichRowWinning =-1;
		whichRowWinning = [self checkIfGameOver];
        //check if game over
        if (whichRowWinning>=0) {
            //we have a winner
            [self gameOverProcessing:YES winningRow:whichRowWinning];
            
        } else {
            if (XOCount>=9) {
                //no winner
                [self gameOverProcessing:NO winningRow:-1];
            }
        }
        
        //if 1 player mode, check if computer's turn next
        if ((!isGameOver) && (playerMode!=PLAYERMODE_TWO_PLAYERS)) {
            
            if (XsTurn==computersMove) {
                [self computersTurn];
            }
        }
        
    } else {  //this is when bottom button "Computer First" been clicked at the beginning for 1 player mode
        
        if (whichButton == TAG_BUTTON_EXTRA) {
            computersMove = YES;
            
            [buttonBottom setHidden:YES];
            
            //computer's move
            [self computersTurn];            
        }
    }
	//NSLog(@"end of GamePlay buttonPressed");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   //NSLog(@"into GamePlayViewController - initWithNibName ");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//------------------------------------------------------------------------------------
// loadView and dealloc
//------------------------------------------------------------------------------------
- (void)loadView {
    self.view=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view.backgroundColor=BACKGROUND_COLOR;
	//NSLog(@"This is loadView in GamePlayViewController");
	
    //initialize checkWinArray 
    for (int ii=0; ii<8; ii++) {
        checkWinArray[ii]=[checkWinData new];
    }    
}


- (void)dealloc {
    //NSLog(@"GamePlayViewController - dealloc");
    //dealloc checkWinArray
    for (int ii=0; ii<8; ii++) {
        [checkWinArray[ii] dealloc];
        checkWinArray[ii]=nil;
    }
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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
