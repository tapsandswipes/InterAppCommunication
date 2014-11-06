//
//  DMGridModel.h
//  tictactoe
//
//  Created by Dennis Wilkins on 5/26/12.
//  Copyright (c) 2012 Delicious Morsel LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DMPlayer) {
    PlayerDraw,
    PlayerNone,
    PlayerA,
    PlayerB,
};

@interface DMGridModel : NSObject

@property (nonatomic , retain) NSMutableArray *grid;
@property (nonatomic , retain) NSMutableArray *solves;
@property (nonatomic , assign) NSUInteger size;

- (id)init;
- (id)initWithSize:(NSUInteger) gridSize;
- (void)resetGrid;
- (BOOL)setPlayer:(DMPlayer)player atGridLocation:(NSUInteger)location;
- (DMPlayer)playerAtGridIndex:(NSUInteger)idx;
- (void)createSolvables;
- (DMPlayer)getWinner;
- (NSInteger)getNextOpenSpot;

+ (NSArray *)getBestMoveForPlayer:(DMPlayer)player inGrid:(DMGridModel *)grid depth:(NSInteger)depth;


@end
