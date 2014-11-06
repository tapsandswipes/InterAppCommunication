//
//  TTTIACClient.h
//  TicTacToe
//
//  Created by Antonio Cabezuelo Vivo on 15/05/14.
//  Copyright (c) 2014 Taps and Swipes. All rights reserved.
//

#import "IACClient.h"

extern NSString * const TTTShowAction;
extern NSString * const TTTInitGameAction;
extern NSString * const TTTSelectSpotAction;

extern NSString * const kOponentKey;
extern NSString * const kSpotKey;

@interface TTTIACClient : IACClient

+ (instancetype)clientForOpponent:(NSString *)oponentSchema;

- (instancetype)initClientA;
- (instancetype)initClientB;

- (void)show;
- (void)initGame;
- (void)selectSpot:(NSUInteger)spot;

@end
