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

// File Name   : SharedUtilities.h
// Description : Header file of "SharedUtilities.m"

#import <UIKit/UIKit.h>


@interface SharedUtilities : NSObject {
}

+(void) showHideButton:(int)buttonTag ifHideButton:(BOOL)settingAboutButtonHide inView: (UIView *)whichView;

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
                    inView: (UIView *)viewToAddTo;

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
                   inView: (UIView *)viewToAddTo;
@end
