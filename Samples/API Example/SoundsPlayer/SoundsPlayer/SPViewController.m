//
//  SPViewController.m
//  SoundsPlayer
//
//  Created by Antonio Cabezuelo Vivo on 15/02/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "SPViewController.h"

@interface SPViewController ()
@property (strong, readwrite, nonatomic) NSArray *soundNames;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@end

@implementation SPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.soundNames = @[ @"applause", @"bell", @"boing", @"car key"];
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        if (idx < [self.soundNames count]) {
            [obj setTitle:self.soundNames[idx] forState:UIControlStateNormal];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play:(UIButton *)sender {
    NSUInteger idx = [self.buttons indexOfObject:sender];
    
    if (idx < [self.soundNames count]) {
        [self playSoundWithName:self.soundNames[idx]];
    }
}

- (BOOL)playSoundWithName:(NSString*)name {
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"m4a"]];
    
    if (url) {
        NSError* __autoreleasing error;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];

        if (self.audioPlayer != nil) {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];

            [self.audioPlayer prepareToPlay];
            [self.audioPlayer play];

            return YES;
        }
    }
    
    return NO;
}

@end
