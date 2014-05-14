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

// File Name   : checkWinData.m
// Description : This class is mainly to check which row "is going to win", used in computer move logic

#import "checkWinData.h"


@implementation checkWinData
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)initWith3Pos:(int)xPos1 tPos2:(int)xPos2 tPos3:(int)xPos3  {
    pos1=xPos1;
    pos2=xPos2;
    pos3=xPos3;
    listScore=0;
    stoneCount=0;
    prevSType=-1;
}

-(int)getListScore { return listScore; }

-(int)getListScoreIfInRow:(int)xPos {
    int result;
    result=0;
    
    if ((pos1==xPos) | (pos2==xPos) | (pos3==xPos)) {
        result = listScore;
    }    
    
    return result;
}

-(int)getStoneCount { return stoneCount; }

-(int)getPos1 { return pos1; }

-(int)getPos2 { return pos2; }

-(int)getPos3 { return pos3; }

-(void)updateNewStone:(int)xPos userType:(int)xUserType compType:(int)xCompType {
    
    if ((pos1==xPos) | (pos2==xPos) | (pos3==xPos)) {
        stoneCount++;
        
        
        if (stoneCount>=3) {
            listScore = -1;  // should lowest score if all 3 position occupied 
        } else {
            
            //if computer's turn
            if (xUserType==xCompType) {
                //if current list already has a computer stone and not full yet
                if ((prevSType==xUserType) && (stoneCount==2)){
                    listScore = listScore + 5000;
                } else {
                    listScore = listScore + VALUE_COMP_MOVE;
                }
                
            } else { //if user's turn
                if ((prevSType==xUserType) && (stoneCount==2)){
                    listScore = listScore + 4000;
                } else {
                    listScore = listScore + VALUE_USER_MOVE;
                }
            }
        }
        
        prevSType = xUserType;
        
    }
    
}

- (void)dealloc
{
    [super dealloc];
}

@end
