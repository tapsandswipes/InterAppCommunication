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

// File Name   : checkWinData.h
// Description : Header file of "checkWinData.m"

#import <UIKit/UIKit.h>
#define VALUE_COMP_MOVE 50
#define VALUE_USER_MOVE 40

@interface checkWinData : NSObject {
@private
    int stoneCount; // how many stones in this target row (min 0 max 3)
    int listScore;  // total score based on number of stones from user/computer
    int prevSType;  // type of previous stone
    int pos1;       // 3 positions covered
    int pos2;
    int pos3;
}

-(void)initWith3Pos:(int)xPos1 tPos2:(int)xPos2 tPos3:(int)xPos3;
-(void)updateNewStone:(int)xPos userType:(int)xUserType compType:(int)xCompType;
-(int)getListScore;
-(int)getListScoreIfInRow:(int)xPos;
-(int)getStoneCount;
-(int)getPos1;
-(int)getPos2;
-(int)getPos3;
@end
