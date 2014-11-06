//
//  TTTIACClient.m
//  TicTacToe
//
//  Created by Antonio Cabezuelo Vivo on 15/05/14.
//  Copyright (c) 2014 Taps and Swipes. All rights reserved.
//

#import "TTTIACClient.h"

NSString * const TTTShowAction = @"show";
NSString * const TTTInitGameAction = @"initGame";
NSString * const TTTSelectSpotAction = @"selectSpot";

NSString * const kOponentKey = @"oponent";
NSString * const kSpotKey = @"spot";

static NSString * const schemeA = @"iacttta";
static NSString * const schemeB = @"iactttb";

@implementation TTTIACClient

+ (instancetype)clientForOpponent:(NSString *)oponentSchema {
    if ([oponentSchema isEqualToString:schemeA]) {
        return [[self alloc] initClientA];
    }
    
    if ([oponentSchema isEqualToString:schemeB]) {
        return [[self alloc] initClientB];
    }
    
    return nil;
}

- (instancetype)initClientA {
    return [self initWithURLScheme:schemeA];
}

- (instancetype)initClientB {
    return [self initWithURLScheme:schemeB];
}

- (void)show {
    [self performAction:TTTShowAction];
}

- (void)initGame {
    [self performAction:TTTInitGameAction parameters:@{kOponentKey:self.URLScheme == schemeA ? schemeB : schemeA}];
}

- (void)selectSpot:(NSUInteger)spot {
    [self performAction:TTTSelectSpotAction parameters:@{kSpotKey:@(spot)}];
}

@end
