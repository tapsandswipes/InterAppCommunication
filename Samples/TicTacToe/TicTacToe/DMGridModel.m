//
//  DMGridModel.m
//  tictactoe
//
//  Created by Dennis Wilkins on 5/26/12.
//  Copyright (c) 2012 Delicious Morsel LLC. All rights reserved.
//

#import "DMGridModel.h"

@implementation DMGridModel

- (id)init {
	return [self initWithSize:3];
}

- (id)initWithSize:(NSUInteger) gridSize {
	self = [super init];
	self.size = gridSize;
	NSUInteger fullSize = gridSize * gridSize;
	self.grid = [NSMutableArray arrayWithCapacity:fullSize];
	for (int i = 0; i < fullSize; i++) {
		[self.grid insertObject:@(PlayerNone) atIndex:i];
	}
	[self createSolvables];
	
	return self;
}

- (void)resetGrid {
	for (int i = 0; i < [self.grid count]; i++) {
		[self.grid replaceObjectAtIndex:i withObject:@(PlayerNone)];
	}
}

- (BOOL)setPlayer:(DMPlayer)player atGridLocation:(NSUInteger)location {
	NSNumber *playerInSpace = [self.grid objectAtIndex:location];
	if ([playerInSpace isEqualToNumber:@(PlayerNone)]) {
		[self.grid replaceObjectAtIndex:location withObject:@(player)];
		return YES;
	}
	return NO;
}

- (DMPlayer)playerAtGridIndex:(NSUInteger)idx {
    if (idx >= [self.grid count]) {
        return PlayerNone;
    }
    
    return [self.grid[idx] unsignedIntegerValue];
}


- (void)createSolvables {
	NSUInteger solveSize = self.size * 2 + 2;
	self.solves = [NSMutableArray arrayWithCapacity:solveSize];
	NSUInteger y;
	NSUInteger x;
	NSMutableArray *innerSolve; // solveable
	for(x=0; x < solveSize; x++) { // init them all up
		[self.solves addObject: [NSMutableArray arrayWithCapacity:self.size]]; // pre init hte size, cause we know it.
	}
	for(x = 0; x < self.size; x++) {
		for(y = 0; y < self.size; y++) {
			
			innerSolve = [self.solves objectAtIndex:x];// X axis solves
			[innerSolve addObject: @((x * self.size) + y)];
			
			innerSolve = [self.solves objectAtIndex: self.size + y];// Y axis solves
			[innerSolve addObject: @((x * self.size) + y)];
			
			if (x == y) {
				innerSolve = [self.solves objectAtIndex: self.size * 2]; // top left going down diagnoally
				[innerSolve addObject: @((x * self.size) + y)];
			}
			
			if ((x + y) == (self.size - 1)) {
				innerSolve = [self.solves objectAtIndex: self.size * 2 + 1]; // top right
				[innerSolve addObject: @(x * self.size + y)];
			}
		}
	}
}

- (DMPlayer)getWinner {
	NSUInteger i;
	NSUInteger j;
	NSMutableArray *solve;
	NSNumber *location;
	DMPlayer player;
	DMPlayer gridPlayer;
	NSNumber *gridLocationPlayer;
	for(i = 0; i < [self.solves count]; i++) {
		solve = [self.solves objectAtIndex:i];
		player = PlayerNone;
		for(j = 0; j < [solve count]; j++) {
			location = [solve objectAtIndex:j];
			gridLocationPlayer = [self.grid objectAtIndex: [location unsignedIntValue]];
			gridPlayer = [gridLocationPlayer unsignedIntegerValue];
			if (gridPlayer == PlayerNone) {
				player = PlayerNone;
				break;
			}
			if (player > PlayerNone && player != gridPlayer) {
				player = PlayerNone;
				break;
			} else {
				player = gridPlayer;
			}
		}
		
		if (player > PlayerNone) {
			return player;
		}
	}
	/// check if its draw, or still in progress
	for (i = 0; i < [self.grid count]; i++) {
		if ([[self.grid objectAtIndex: i] unsignedIntegerValue] == PlayerNone) {
			return PlayerNone; // PlayerNone = in progress
		}
	}
	return PlayerDraw;
}

- (NSInteger)getNextOpenSpot {
	NSUInteger i = 0;
	NSUInteger c = [self.grid count];
	for (i = 0; i < c; i++) {
		if ([self  playerAtGridIndex:i] == PlayerNone) {
			return i;
		}
	}
	return -1;
}

- (void)dealloc {
	self.grid = nil;
	self.size = 0;
	self.solves = nil;
}

- (BOOL)gridIsEmpty {
    BOOL empty = YES;
    
    for (int i = 0; i < [self.grid count]; i++) {
        if ([self playerAtGridIndex:i] != PlayerNone) {
            empty = NO;
            break;
        }
    }

    return empty;
}

- (NSUInteger)randomMove {
    sleep(2);
    return 2;
    
    NSUInteger move = arc4random_uniform((u_int32_t)self.grid.count);

    if ([self playerAtGridIndex:move] != PlayerNone) {
        move = [self randomMove];
    }
    
    return move;
}

+ (NSArray *)getBestMoveForPlayer:(DMPlayer)player inGrid:(DMGridModel *)gridModel depth:(NSInteger)depth {
    NSUInteger i;
    NSUInteger gridCount = [gridModel.grid count];
    NSUInteger gridHuge = gridCount * gridCount;
    
    NSInteger bestMove = NSNotFound;
    NSInteger bestScore = (player == PlayerA ? -gridHuge : gridHuge);
    NSUInteger move;
    NSInteger score;
    DMPlayer winner;
    NSArray *results;
    DMPlayer playerAtGridLocation;
    
    if ([gridModel gridIsEmpty]) {
        return @[@([gridModel randomMove]), @(bestScore)];
    }
    
    for (i = 0; i < gridCount; i++) {
        playerAtGridLocation = [gridModel.grid[i] unsignedIntegerValue];
        if (playerAtGridLocation == PlayerNone) { // no one in there.
            [gridModel.grid replaceObjectAtIndex:i withObject:@(player)]; // replace
            winner = [gridModel getWinner];
            if (winner > PlayerNone) {
                score = (player == PlayerA ? depth * -1 : depth);
                move = i;
            } else {
                results = [self getBestMoveForPlayer:(player == PlayerA ? PlayerB : PlayerA)
                                              inGrid:gridModel
                                              depth:depth + 1];
                move = [results[0] unsignedIntegerValue];
                score = [results[1] unsignedIntegerValue];
            }
            if (player == PlayerA ? score > bestScore : score < bestScore) {
                bestScore = score;
                bestMove = move;
            }
            
            [gridModel.grid replaceObjectAtIndex:i withObject:@(playerAtGridLocation)]; // replace
        }
        
    }
    return @[@(bestMove) , @(bestScore)];

}

@end
