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

// File Name   : SharedUtilities.m
// Description : This static class holds shared utilities for creating buttons and labels

#import "SharedUtilities.h"

@implementation SharedUtilities

+(void) showHideButton:(int)buttonTag ifHideButton:(BOOL)settingAboutButtonHide inView: (UIView *)whichView {
    UIButton *button1;
    
    button1 = (UIButton *) [whichView viewWithTag:buttonTag];
    
    if (button1!=nil) {
      [button1 setHidden:settingAboutButtonHide];
    }
    
}

+(void) createNormalButton: (UIButton *) buttonObj 
                    atPosX: (double) buttonPositionX
                    atPosY: (double) buttonPositionY 				  
                 withWidth: (double) buttonWidth  
                withHeight: (double) buttonHeight 
               withBGColor: (UIColor *) buttonBGColor 
            withTitleColor: (UIColor *) buttonTitleColor
                   withTag: (int) buttonTag 
                 withTitle: (NSString *) buttonTitle  
              withFontSize: (int)buttonFontSize
                withSelfID: (id)buttonSelfID 
              withActionID: (SEL)selectorID 
                 ifEnabled: (BOOL)buttonEnabled 
                    inView: (UIView *)viewToAddTo

{
    
	buttonObj = [UIButton buttonWithType:UIButtonTypeRoundedRect];					
	[buttonObj setFrame:CGRectMake(buttonPositionX, buttonPositionY, buttonWidth, buttonHeight)]; 
	[buttonObj setTitle: buttonTitle forState:UIControlStateNormal];				
    [buttonObj.titleLabel setFont:[UIFont systemFontOfSize:buttonFontSize]];
    //   [buttonObj.titleLabel setBackgroundColor:buttonBGColor];
    //	  [buttonObj setTitleShadowColor:buttonBGColor forState:UIControlStateNormal];	
    //   [buttonObj setTitleShadowColor:buttonBGColor forState:UIControlStateSelected];	
    //   [buttonObj setBackgroundColor: buttonBGColor];
    //   [buttonObj setReversesTitleShadowWhenHighlighted:YES];	
	[buttonObj setTag: buttonTag];    
    [buttonObj addTarget:buttonSelfID action:selectorID forControlEvents:UIControlEventTouchUpInside];
    //  [buttonObj setTitleColor:buttonTitleColor forState:UIControlStateNormal];	
    //  [buttonObj setTitleColor:buttonTitleColor forState:UIControlStateSelected];
    //	[buttonObj setTitleColor:buttonTitleColor forState:UIControlStateHighlighted];	
    if (buttonEnabled) {
        [buttonObj setEnabled:YES];
        
    } else {
        [buttonObj setEnabled:NO];
    }    
	[viewToAddTo addSubview:buttonObj];													
	[[buttonObj retain] autorelease];
}

+(void) createNormalLabel: (UILabel *) labelObj 
                   atPosX: (double)labelPositionX 
                   atPosY: (double)labelPositionY  
                withWidth: (double)labelWidth 
               withHeight: (double)labelHeight                 
              withBGColor: (UIColor *) labelBGColor  
            withTextColor: (UIColor *) labelTextColor  
                  withTag: (int) labelTag                  
                 withText: (NSString *)labelText 
             withFontSize: (int) labelFontSize
                   inView: (UIView *)viewToAddTo
{
    labelObj = [[UILabel alloc] initWithFrame:CGRectMake(labelPositionX, labelPositionY, labelWidth, labelHeight)];
    
	[labelObj setTag:labelTag];
	[labelObj setText:labelText];
    [labelObj setFont:[UIFont systemFontOfSize:labelFontSize]];
    [labelObj setTextColor:labelTextColor];
	[labelObj setBackgroundColor:labelBGColor];
	[labelObj setNumberOfLines:0];
	[labelObj sizeToFit];
   // [labelObj setOpaque:YES];
   // [labelObj setAlpha:0.5];
    
    
	[viewToAddTo addSubview:labelObj];
	
	[labelObj release];
}


@end
