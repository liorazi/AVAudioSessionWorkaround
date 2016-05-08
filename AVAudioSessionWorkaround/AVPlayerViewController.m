//
//  ViewController.m
//  AVAudioSessionWorkaround
//
//  Created by Lior on 08/05/2016.
//  Copyright © 2016 Azi Software. All rights reserved.
//

#import "AVPlayerViewController.h"
@import AVFoundation;

@interface AVPlayerViewController () {
    
}

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation AVPlayerViewController


- (void)playAudio {
    NSString *mySoundFile = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"mp3"];
    NSURL *alertSound = [NSURL fileURLWithPath:mySoundFile];
    
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:@"AVAudioSessionCategoryPlayback" error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    if (error) {
        NSLog(@"Error %@", [error description]);
    }
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:alertSound error:&error];

    [_player setNumberOfLoops:-1];
    [_player prepareToPlay];
    [_player play];
    
}

- (void)addInterruptionNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:@"AVAudioSessionInterruptionNotification" object:nil];
}

- (void)handleInterruption:(NSNotification *) notification{
    if (notification.name != AVAudioSessionInterruptionNotification || notification.userInfo == nil) {
        return;
    }
    
    NSDictionary *info = notification.userInfo;
    
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        
        if ([[info valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
            NSLog(@"InterruptionTypeBegan");
        } else {
            NSLog(@"InterruptionTypeEnded");
            
            //*The* Workaround - Add a small delay to the avplayer's play call.
            //(I didn't play much with the times, but 0.01 works with my iPhone 6S 9.3.1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSLog(@"playing");
                [_player play];
            });
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addInterruptionNotification];
    [self playAudio];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnWasPressed:(id)sender {
    if (_player.isPlaying) {
        [_player pause];
    }
    else {
        [_player play];
    }
}

@end
